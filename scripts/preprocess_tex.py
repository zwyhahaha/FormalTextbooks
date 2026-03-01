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


def _log(event: str, data: dict) -> None:
    LOG_FILE.parent.mkdir(parents=True, exist_ok=True)
    entry = {"ts": datetime.datetime.now().isoformat(timespec="seconds"), "event": event, **data}
    with LOG_FILE.open("a") as f:
        f.write(json.dumps(entry) + "\n")


if __name__ == "__main__":
    print("preprocess_tex scaffold ok")
