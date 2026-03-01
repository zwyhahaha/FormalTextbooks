"""TeX source preprocessing pipeline: Bubeck15 TeX → subsection-level markdown files."""
import datetime, json, re, subprocess, sys, tempfile
from pathlib import Path
import yaml

LOG_FILE = Path("logs/pipeline.log")

CHAPTER_FILES = [
    (1, "Introduction",                                                      "intro2.tex"),
    (2, "Convex optimization in finite dimension",                           "finitedim2.tex"),
    (3, "Dimension-free convex optimization",                                "dimfree2.tex"),
    (4, "Almost dimension-free convex optimization in non-Euclidean spaces", "mirror2.tex"),
    (5, "Beyond the black-box model",                                        "beyond2.tex"),
    (6, "Convex optimization and randomness",                                "rand2.tex"),
]

THEOREM_ENVS = {"theorem", "lemma", "proposition", "corollary", "definition", "remark"}


# Matches: \newcommand{\NAME}{EXPANSION} or \renewcommand{\NAME}{EXPANSION}
# Expansion group handles one level of nested braces (e.g. \mathbb{R})
_NEWCMD_RE = re.compile(
    r'\\(?:new|renew)command\{(\\[a-zA-Z]+)\}\{((?:[^{}]|\{[^{}]*\})*)\}'
)


def load_macros(commands_path: Path) -> dict[str, str]:
    """Parse Commands.tex and return {macro: expansion} dict.

    Only captures simple one-argument-free macros (no #1 parameters).
    Skips macros whose expansion contains '#' (parameterized).
    """
    text = commands_path.read_text(encoding="utf-8")
    result = {}
    for m in _NEWCMD_RE.finditer(text):
        name, expansion = m.group(1), m.group(2)
        if "#" not in expansion:
            result[name] = expansion
    return result


# Matches \section{Title} or \section*{Title}, captures optional \label{...} nearby
_SECTION_RE = re.compile(
    r'\\section\*?\{([^}]+)\}'
    r'(?:\s*\\label\{([^}]+)\})?',
    re.MULTILINE,
)
_SUBSECTION_RE = re.compile(
    r'\\subsection\*?\{([^}]+)\}'
    r'(?:\s*\\label\{([^}]+)\})?',
    re.MULTILINE,
)
# Standalone \label{...} that may appear on the next line after a \section
_LABEL_NEARBY_RE = re.compile(r'\\label\{([^}]+)\}')


def _extract_label_after(text: str, pos: int, window: int = 120) -> str | None:
    """Look for \\label{...} within `window` chars after `pos`."""
    snippet = text[pos:pos + window]
    m = _LABEL_NEARBY_RE.search(snippet)
    return m.group(1) if m else None


def parse_chunks(tex_text: str, chapter_num: int, chapter_title: str) -> list[dict]:
    """Split chapter TeX into section/subsection chunks.

    Returns list of dicts:
      chapter, chapter_title, section, section_title, tex_label,
      subsection (None or int), subsection_title (None or str), body_tex
    """
    # Collect all split points: (position, kind, title, raw_label_or_None)
    points: list[tuple[int, str, str, str | None]] = []

    for m in _SECTION_RE.finditer(tex_text):
        label = m.group(2) or _extract_label_after(tex_text, m.end())
        points.append((m.start(), "section", m.group(1).strip(), label))

    for m in _SUBSECTION_RE.finditer(tex_text):
        label = m.group(2) or _extract_label_after(tex_text, m.end())
        points.append((m.start(), "subsection", m.group(1).strip(), label))

    points.sort(key=lambda p: p[0])

    chunks: list[dict] = []
    sec_counter = 0
    sub_counter = 0
    current_section = 0
    current_section_title = ""

    # Capture content before the first \section{} (e.g. chapter-level definitions)
    preamble_body = tex_text[:points[0][0]].strip() if points else tex_text.strip()
    if preamble_body:
        chunks.append({
            "chapter": chapter_num,
            "chapter_title": chapter_title,
            "section": 0,
            "section_title": chapter_title,
            "subsection": None,
            "subsection_title": None,
            "section_id": f"{chapter_num}.0",
            "tex_label": "",
            "body_tex": preamble_body,
        })

    for i, (pos, kind, title, label) in enumerate(points):
        end = points[i + 1][0] if i + 1 < len(points) else len(tex_text)
        body = tex_text[pos:end].strip()

        if kind == "section":
            sec_counter += 1
            sub_counter = 0
            current_section = sec_counter
            current_section_title = title
            chunks.append({
                "chapter": chapter_num,
                "chapter_title": chapter_title,
                "section": sec_counter,
                "section_title": title,
                "subsection": None,
                "subsection_title": None,
                "section_id": f"{chapter_num}.{sec_counter}",
                "tex_label": label,
                "body_tex": body,
            })
        else:  # subsection
            sub_counter += 1
            chunks.append({
                "chapter": chapter_num,
                "chapter_title": chapter_title,
                "section": current_section,
                "section_title": current_section_title,
                "subsection": sub_counter,
                "subsection_title": title,
                "section_id": f"{chapter_num}.{current_section}.{sub_counter}",
                "tex_label": label,
                "body_tex": body,
            })

    return chunks


# Matches \begin{theorem}[Optional Name] or \begin{theorem}
_ENV_BEGIN_RE = re.compile(
    r'\\begin\{(' + '|'.join(THEOREM_ENVS) + r')\}'
    r'(?:\[([^\]]*)\])?'          # optional [Name]
    r'(?:\s*\\label\{([^}]+)\})?', # optional inline \label
    re.IGNORECASE,
)
_LABEL_RE = re.compile(r'\\label\{([^}]+)\}')


def detect_theorems_tex(body_tex: str, chapter_num: int, counter: list[int]) -> list[dict]:
    """Find theorem-like environments in raw TeX chunk.

    `counter` is a mutable [int] shared across chunks within the same chapter.
    All theorem-like envs (theorem, lemma, proposition, corollary, definition, remark)
    share one counter, matching now.cls behavior.

    Returns list of {id, label, tex_label}.
    """
    _cite_re = re.compile(r'\\cite\{[^}]*\}')
    results = []
    for m in _ENV_BEGIN_RE.finditer(body_tex):
        env_type = m.group(1).capitalize()
        name = _cite_re.sub("", (m.group(2) or "")).strip()
        tex_label = m.group(3)

        # If \label not inline, look for it in the next 200 chars
        if not tex_label:
            snippet = body_tex[m.end():m.end() + 200]
            lm = _LABEL_RE.search(snippet)
            tex_label = lm.group(1) if lm else None

        counter[0] += 1
        thm_id = f"{env_type} {chapter_num}.{counter[0]}"
        results.append({"id": thm_id, "label": name, "tex_label": tex_label or ""})

    return results


# Light TeX cleaner used as pandoc fallback
_COMMENT_RE = re.compile(r'(?<!\\)%[^\n]*')
_BEGIN_ENV_RE = re.compile(r'\\begin\{(\w+)\}(?:\[([^\]]*)\])?')
_END_ENV_RE = re.compile(r'\\end\{(\w+)\}')
_EMPH_RE = re.compile(r'\\(?:emph|textit)\{([^}]+)\}')
_BF_RE = re.compile(r'\\(?:textbf|mathbf)\{([^}]+)\}')
_FOOTNOTE_RE = re.compile(r'\\footnote\{[^}]*\}')


def _light_clean(tex: str) -> str:
    """Minimal TeX → readable text without pandoc."""
    text = _COMMENT_RE.sub("", tex)
    text = _FOOTNOTE_RE.sub("", text)

    def replace_begin(m: re.Match) -> str:
        env, name = m.group(1), m.group(2) or ""
        if env in THEOREM_ENVS:
            label = f" ({name})" if name else ""
            return f"\n**{env.capitalize()}**{label}\n"
        if env == "proof":
            return "\n*Proof.*\n"
        return ""

    text = _BEGIN_ENV_RE.sub(replace_begin, text)
    text = _END_ENV_RE.sub("", text)
    text = _EMPH_RE.sub(r"*\1*", text)
    text = _BF_RE.sub(r"**\1**", text)
    # Collapse excess blank lines
    text = re.sub(r'\n{3,}', '\n\n', text)
    return text.strip()


def convert_to_markdown(body_tex: str, tex_dir: Path) -> str:
    """Convert TeX chunk to markdown via pandoc; fall back to light cleaner."""
    commands_tex = tex_dir / "Commands.tex"
    preamble = (
        r"\documentclass{article}" + "\n"
        r"\usepackage{amsmath,amssymb,amsthm}" + "\n"
        r"\newtheorem{theorem}{Theorem}[section]" + "\n"
        r"\newtheorem{lemma}[theorem]{Lemma}" + "\n"
        r"\newtheorem{proposition}[theorem]{Proposition}" + "\n"
        r"\newtheorem{corollary}[theorem]{Corollary}" + "\n"
        r"\newtheorem{definition}[theorem]{Definition}" + "\n"
        r"\newtheorem{remark}[theorem]{Remark}" + "\n"
    )
    if commands_tex.exists():
        preamble += r"\input{" + str(commands_tex.resolve()) + "}\n"
    preamble += r"\begin{document}" + "\n"
    full_tex = preamble + body_tex + "\n" + r"\end{document}"

    try:
        with tempfile.NamedTemporaryFile(suffix=".tex", mode="w",
                                         delete=False, encoding="utf-8") as f:
            f.write(full_tex)
            tmp_path = f.name
        result = subprocess.run(
            ["pandoc", tmp_path, "--from", "latex",
             "--to", "markdown-raw_tex", "--wrap=none"],
            capture_output=True, text=True, timeout=30,
        )
        Path(tmp_path).unlink(missing_ok=True)
        if result.returncode == 0 and result.stdout.strip():
            return result.stdout.strip()
    except (FileNotFoundError, subprocess.TimeoutExpired):
        pass

    # Fallback: light TeX cleaning
    return _light_clean(body_tex)


def _title_to_slug(title: str) -> str:
    slug = re.sub(r'[^a-z0-9]+', '_', title.lower()).strip('_')
    return slug[:40]


def _read_existing_status(path: Path) -> dict[str, str]:
    """Return {theorem_id: status} from existing section file's lean_files."""
    if not path.exists():
        return {}
    text = path.read_text(encoding="utf-8")
    if not text.startswith("---"):
        return {}
    end = text.find("\n---", 3)
    if end == -1:
        return {}
    try:
        fm = yaml.safe_load(text[3:end])
        return {lf["id"]: lf.get("status", "pending")
                for lf in (fm.get("lean_files") or [])}
    except yaml.YAMLError:
        return {}


def write_section_files(chunks: list[dict], paper_dir: Path, book: str) -> list[Path]:
    """Write section/subsection markdown files to paper_dir/sections/.

    Each chunk must have keys: chapter, chapter_title, section, section_title,
    subsection, subsection_title, section_id, tex_label, theorems, markdown.
    Preserves existing lean_files status on re-runs.
    Returns list of written Paths.
    """
    sections_dir = paper_dir / "sections"
    sections_dir.mkdir(parents=True, exist_ok=True)
    written = []

    for chunk in chunks:
        sub = chunk["subsection"]
        if sub is None:
            slug = _title_to_slug(chunk["section_title"])
            sec = chunk["section"]
            filename = f"{chunk['chapter']:02d}_{sec:02d}_{slug}.md"
        else:
            slug = _title_to_slug(chunk["subsection_title"] or chunk["section_title"])
            filename = (f"{chunk['chapter']:02d}_{chunk['section']:02d}"
                        f"_{sub:02d}_{slug}.md")

        out_path = sections_dir / filename
        existing_status = _read_existing_status(out_path)

        lean_files = [
            {
                "id": t["id"],
                "path": (f"proofs/{book}/"
                         f"{t['id'].replace(' ', '').replace('.', '')}.lean"),
                "status": existing_status.get(t["id"], "pending"),
            }
            for t in chunk.get("theorems", [])
        ]

        fm = {
            "book": book,
            "chapter": chunk["chapter"],
            "chapter_title": chunk["chapter_title"],
            "section": chunk["section"],
            "section_title": chunk["section_title"],
            "subsection": chunk["subsection"],
            "subsection_title": chunk["subsection_title"],
            "section_id": chunk["section_id"],
            "tex_label": chunk.get("tex_label") or "",
            "theorems": chunk.get("theorems", []),
            "lean_files": lean_files,
        }
        front_matter = "---\n" + yaml.dump(fm, allow_unicode=True, sort_keys=False) + "---\n\n"
        out_path.write_text(front_matter + chunk.get("markdown", ""), encoding="utf-8")
        written.append(out_path)

    return written


def write_index(paper_dir: Path) -> Path:
    """Regenerate paper_dir/index.md from all section files."""
    sections_dir = paper_dir / "sections"
    rows = []
    for md_file in sorted(sections_dir.glob("*.md")):
        text = md_file.read_text(encoding="utf-8")
        if not text.startswith("---"):
            continue
        end = text.find("\n---", 3)
        if end == -1:
            continue
        try:
            fm = yaml.safe_load(text[3:end])
        except yaml.YAMLError:
            continue
        section_id = fm.get("section_id", "")
        section_title = fm.get("subsection_title") or fm.get("section_title", "")
        # Build theorem id → label map from the theorems list
        thm_label_map = {t["id"]: t.get("label", "") for t in (fm.get("theorems") or [])}
        for lf in (fm.get("lean_files") or []):
            rows.append({
                "id": lf["id"],
                "name": thm_label_map.get(lf["id"], ""),
                "section_id": section_id,
                "section_title": section_title,
                "path": lf.get("path", ""),
                "status": lf.get("status", "pending"),
            })

    header = (
        "# Theorem & Lemma Index\n\n"
        "| ID | Name | Section | Section Title | Lean file | Status |\n"
        "|----|------|---------|---------------|-----------|--------|\n"
    )
    rows_text = "".join(
        f"| {r['id']} | {r['name']} | {r['section_id']} | {r['section_title']} "
        f"| {r['path']} | {r['status']} |\n"
        for r in rows
    )
    index_path = paper_dir / "index.md"
    index_path.write_text(header + rows_text, encoding="utf-8")
    return index_path


def _log(event: str, data: dict) -> None:
    LOG_FILE.parent.mkdir(parents=True, exist_ok=True)
    entry = {"ts": datetime.datetime.now().isoformat(timespec="seconds"), "event": event, **data}
    with LOG_FILE.open("a") as f:
        f.write(json.dumps(entry) + "\n")


def preprocess_tex(tex_dir: Path, chapter: int | None = None) -> None:
    """Main entry point: process Bubeck15 TeX source into papers/Bubeck_convex_optimization/."""
    tex_dir = Path(tex_dir)
    if not tex_dir.exists():
        raise FileNotFoundError(f"TeX directory not found: {tex_dir}")

    book = "Bubeck_convex_optimization"
    paper_dir = Path("papers") / book
    paper_dir.mkdir(parents=True, exist_ok=True)
    commands_tex = tex_dir / "Commands.tex"

    _log("preprocess_tex_start", {"tex_dir": str(tex_dir), "book": book})

    chapters_to_process = CHAPTER_FILES
    if chapter is not None:
        chapters_to_process = [(n, t, f) for n, t, f in CHAPTER_FILES if n == chapter]
        if not chapters_to_process:
            raise ValueError(f"Chapter {chapter} not found in CHAPTER_FILES")

    all_chunks: list[dict] = []

    for ch_num, ch_title, tex_filename in chapters_to_process:
        tex_path = tex_dir / tex_filename
        if not tex_path.exists():
            print(f"[tex] WARNING: {tex_path} not found, skipping")
            continue

        print(f"[tex] Processing chapter {ch_num}: {tex_filename}")
        tex_text = tex_path.read_text(encoding="utf-8")
        chunks = parse_chunks(tex_text, chapter_num=ch_num, chapter_title=ch_title)
        print(f"[tex]   {len(chunks)} chunk(s)")

        counter = [0]  # shared per chapter
        for chunk in chunks:
            chunk["theorems"] = detect_theorems_tex(
                chunk["body_tex"], chapter_num=ch_num, counter=counter
            )
            chunk["markdown"] = convert_to_markdown(chunk["body_tex"], tex_dir)

        all_chunks.extend(chunks)

    written = write_section_files(all_chunks, paper_dir, book=book)
    for p in written:
        print(f"[tex]   wrote {p}")

    index_path = write_index(paper_dir)
    print(f"[tex] Index → {index_path}")

    total_theorems = sum(len(c.get("theorems", [])) for c in all_chunks)
    _log("preprocess_tex_done", {
        "book": book,
        "chapter_filter": chapter,
        "chunks_count": len(all_chunks),
        "theorems_count": total_theorems,
        "output_dir": str(paper_dir / "sections"),
    })
    print(f"[tex] Done. {len(all_chunks)} sections, {total_theorems} theorems.")


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(
        description="Preprocess Bubeck15 TeX source into subsection markdown files."
    )
    parser.add_argument("tex_dir", help="Path to TeX source directory")
    parser.add_argument("--chapter", type=int, default=None,
                        help="Process only this chapter number")
    args = parser.parse_args()
    preprocess_tex(Path(args.tex_dir), chapter=args.chapter)
