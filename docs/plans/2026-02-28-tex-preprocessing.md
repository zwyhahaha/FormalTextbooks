# TeX Preprocessing Pipeline Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Create `scripts/preprocess_tex.py` that converts the Bubeck15 TeX source into
`papers/Bubeck_convex_optimization/` with the same structure as `papers/Bubeck15/` (YAML
front-matter per section, master index, theorem tracking) but with clean pandoc-rendered math
instead of OCR output.

**Architecture:** Pure Python script split into focused functions: macro loading → TeX chunk
splitting (section/subsection) → theorem detection on raw TeX → pandoc conversion → file
writing → index generation. Pandoc handles TeX→markdown; if unavailable, a light TeX cleaner
serves as fallback.

**Tech Stack:** Python 3.12, PyYAML (already available), pandoc (optional, install via brew),
pytest (existing test suite in `tests/`).

---

## Reference Files

Read these before implementing:

- `scripts/preprocess_textbook.py` — existing pipeline to mirror in structure
- `tests/test_preprocess_textbook.py` — existing test style to follow
- `textbook/Bubeck15-arXiv-1405.4980v2/Commands.tex` — macro definitions
- `textbook/Bubeck15-arXiv-1405.4980v2/intro2.tex` — simplest chapter (6 sections, no subsections)
- `textbook/Bubeck15-arXiv-1405.4980v2/finitedim2.tex` — chapter with subsections
- `papers/Bubeck15/sections/01_02_basic_properties_of_convexity.md` — target output format

## Chapter Mapping (hardcoded in script)

```python
CHAPTER_FILES = [
    (1, "Introduction",                                                     "intro2.tex"),
    (2, "Convex optimization in finite dimension",                          "finitedim2.tex"),
    (3, "Dimension-free convex optimization",                               "dimfree2.tex"),
    (4, "Almost dimension-free convex optimization in non-Euclidean spaces","mirror2.tex"),
    (5, "Beyond the black-box model",                                       "beyond2.tex"),
    (6, "Convex optimization and randomness",                               "rand2.tex"),
]
```

---

## Task 1: Scaffold script and test file

**Files:**
- Create: `scripts/preprocess_tex.py`
- Create: `tests/test_preprocess_tex.py`

**Step 1: Create the test file with one smoke test**

```python
# tests/test_preprocess_tex.py
"""Tests for preprocess_tex pipeline."""
import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'scripts'))

def test_import():
    import preprocess_tex  # noqa: F401
```

**Step 2: Run to confirm it fails**

```bash
cd "/Users/apple/Documents/formal verification/prover"
python3 -m pytest tests/test_preprocess_tex.py -v
```

Expected: `ModuleNotFoundError: No module named 'preprocess_tex'`

**Step 3: Create the script scaffold**

```python
# scripts/preprocess_tex.py
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

def _log(event: str, data: dict) -> None:
    LOG_FILE.parent.mkdir(parents=True, exist_ok=True)
    entry = {"ts": datetime.datetime.now().isoformat(timespec="seconds"), "event": event, **data}
    with LOG_FILE.open("a") as f:
        f.write(json.dumps(entry) + "\n")

if __name__ == "__main__":
    print("preprocess_tex scaffold ok")
```

**Step 4: Run smoke test to confirm it passes**

```bash
python3 -m pytest tests/test_preprocess_tex.py -v
```

Expected: `PASSED`

**Step 5: Commit**

```bash
git add scripts/preprocess_tex.py tests/test_preprocess_tex.py
git commit -m "feat: scaffold preprocess_tex script and test"
```

---

## Task 2: Macro loading

Parse `Commands.tex` and return a substitution map used later when theorem names reference macros.

**Files:**
- Modify: `scripts/preprocess_tex.py`
- Modify: `tests/test_preprocess_tex.py`

**Step 1: Write failing tests**

```python
# add to tests/test_preprocess_tex.py
from preprocess_tex import load_macros
from pathlib import Path

TEX_DIR = Path("textbook/Bubeck15-arXiv-1405.4980v2")

def test_load_macros_basic():
    macros = load_macros(TEX_DIR / "Commands.tex")
    assert macros[r"\R"] == r"\mathbb{R}"
    assert macros[r"\cX"] == r"\mathcal{X}"
    assert macros[r"\E"] == r"\mathbb{E}"

def test_load_macros_returns_dict():
    macros = load_macros(TEX_DIR / "Commands.tex")
    assert isinstance(macros, dict)
    assert len(macros) > 10
```

**Step 2: Run to confirm failure**

```bash
python3 -m pytest tests/test_preprocess_tex.py::test_load_macros_basic -v
```

Expected: `ImportError` (function not defined yet)

**Step 3: Implement `load_macros`**

Add to `scripts/preprocess_tex.py`:

```python
# Matches: \newcommand{\NAME}{EXPANSION} or \renewcommand{\NAME}{EXPANSION}
_NEWCMD_RE = re.compile(
    r'\\(?:new|renew)command\{(\\[a-zA-Z]+)\}\{([^}]*)\}'
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
```

**Step 4: Run tests**

```bash
python3 -m pytest tests/test_preprocess_tex.py -k "macro" -v
```

Expected: both PASS

**Step 5: Commit**

```bash
git add scripts/preprocess_tex.py tests/test_preprocess_tex.py
git commit -m "feat: add load_macros for Commands.tex parsing"
```

---

## Task 3: TeX chunk splitting

Split a chapter's TeX into section and subsection chunks. Each chunk is a dict with metadata
and raw TeX body.

**Files:**
- Modify: `scripts/preprocess_tex.py`
- Modify: `tests/test_preprocess_tex.py`

**Step 1: Write failing tests**

```python
# add to tests/test_preprocess_tex.py
from preprocess_tex import parse_chunks

SIMPLE_TEX = r"""
Some chapter intro text.

\section{First section} \label{sec:first}
Content of first section.

\section{Second section}
Content of second section.

\subsection{A subsection} \label{sub:a}
Subsection content.
"""

def test_parse_chunks_count():
    chunks = parse_chunks(SIMPLE_TEX, chapter_num=2, chapter_title="Chapter Two")
    # expect: intro(if text before first section), sec1, sec2, sec2.sub1
    section_chunks = [c for c in chunks if c["subsection"] is None]
    sub_chunks = [c for c in chunks if c["subsection"] is not None]
    assert len(section_chunks) == 2
    assert len(sub_chunks) == 1

def test_parse_chunks_metadata():
    chunks = parse_chunks(SIMPLE_TEX, chapter_num=2, chapter_title="Chapter Two")
    sec1 = next(c for c in chunks if c["section_title"] == "First section")
    assert sec1["chapter"] == 2
    assert sec1["section"] == 1
    assert sec1["tex_label"] == "sec:first"
    assert sec1["subsection"] is None

def test_parse_chunks_subsection():
    chunks = parse_chunks(SIMPLE_TEX, chapter_num=2, chapter_title="Chapter Two")
    sub = next(c for c in chunks if c["subsection"] is not None)
    assert sub["section"] == 2
    assert sub["subsection"] == 1
    assert sub["subsection_title"] == "A subsection"
    assert sub["tex_label"] == "sub:a"

def test_parse_chunks_body():
    chunks = parse_chunks(SIMPLE_TEX, chapter_num=2, chapter_title="Chapter Two")
    sec1 = next(c for c in chunks if c["section_title"] == "First section")
    assert "Content of first section" in sec1["body_tex"]
```

**Step 2: Run to confirm failure**

```bash
python3 -m pytest tests/test_preprocess_tex.py -k "chunks" -v
```

**Step 3: Implement `parse_chunks`**

Add to `scripts/preprocess_tex.py`:

```python
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
    current_section_label = None

    for i, (pos, kind, title, label) in enumerate(points):
        end = points[i + 1][0] if i + 1 < len(points) else len(tex_text)
        body = tex_text[pos:end].strip()

        if kind == "section":
            sec_counter += 1
            sub_counter = 0
            current_section = sec_counter
            current_section_title = title
            current_section_label = label
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
```

**Step 4: Run tests**

```bash
python3 -m pytest tests/test_preprocess_tex.py -k "chunks" -v
```

Expected: all 4 PASS

**Step 5: Commit**

```bash
git add scripts/preprocess_tex.py tests/test_preprocess_tex.py
git commit -m "feat: add parse_chunks for section/subsection splitting"
```

---

## Task 4: Theorem detection from raw TeX

Extract theorem-like environments from a TeX chunk body. Returns list of `{id, label, tex_label}`.
Theorem numbering uses a shared per-chapter counter (all envs share one counter, matching
the `now.cls` class behavior).

**Files:**
- Modify: `scripts/preprocess_tex.py`
- Modify: `tests/test_preprocess_tex.py`

**Step 1: Write failing tests**

```python
# add to tests/test_preprocess_tex.py
from preprocess_tex import detect_theorems_tex

THM_TEX = r"""
\begin{theorem}[Separation Theorem]
\label{th:separation}
Let $\cX$ be a closed convex set.
\end{theorem}

\begin{proposition}[Existence of subgradients] \label{prop:subgrad}
Let $f$ be convex.
\end{proposition}

\begin{definition}[Convex function]
A function $f$ is convex if...
\end{definition}
"""

def test_detect_theorems_tex_count():
    counter = [0]
    thms = detect_theorems_tex(THM_TEX, chapter_num=1, counter=counter)
    assert len(thms) == 3
    assert counter[0] == 3

def test_detect_theorems_tex_ids():
    counter = [0]
    thms = detect_theorems_tex(THM_TEX, chapter_num=1, counter=counter)
    assert thms[0]["id"] == "Theorem 1.1"
    assert thms[1]["id"] == "Proposition 1.2"
    assert thms[2]["id"] == "Definition 1.3"

def test_detect_theorems_tex_labels():
    counter = [0]
    thms = detect_theorems_tex(THM_TEX, chapter_num=1, counter=counter)
    assert thms[0]["label"] == "Separation Theorem"
    assert thms[0]["tex_label"] == "th:separation"
    assert thms[1]["tex_label"] == "prop:subgrad"

def test_detect_theorems_tex_no_name():
    tex = r"\begin{theorem}" + "\n" + r"\label{th:main}" + "\nContent\n" + r"\end{theorem}"
    counter = [0]
    thms = detect_theorems_tex(tex, chapter_num=2, counter=counter)
    assert thms[0]["id"] == "Theorem 2.1"
    assert thms[0]["label"] == ""
    assert thms[0]["tex_label"] == "th:main"
```

**Step 2: Run to confirm failure**

```bash
python3 -m pytest tests/test_preprocess_tex.py -k "detect_theorems_tex" -v
```

**Step 3: Implement `detect_theorems_tex`**

Add to `scripts/preprocess_tex.py`:

```python
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
    results = []
    for m in _ENV_BEGIN_RE.finditer(body_tex):
        env_type = m.group(1).capitalize()
        name = (m.group(2) or "").strip()
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
```

**Step 4: Run tests**

```bash
python3 -m pytest tests/test_preprocess_tex.py -k "detect_theorems_tex" -v
```

Expected: all 4 PASS

**Step 5: Commit**

```bash
git add scripts/preprocess_tex.py tests/test_preprocess_tex.py
git commit -m "feat: add detect_theorems_tex with shared chapter counter"
```

---

## Task 5: TeX-to-markdown conversion

Convert raw TeX body to readable markdown. Try pandoc first; fall back to light TeX cleaning.

**Files:**
- Modify: `scripts/preprocess_tex.py`
- Modify: `tests/test_preprocess_tex.py`

**Step 1: Install pandoc (if not present)**

```bash
brew install pandoc
pandoc --version
```

If brew unavailable, skip — the fallback handles it.

**Step 2: Write failing tests**

```python
# add to tests/test_preprocess_tex.py
from preprocess_tex import convert_to_markdown

TEX_DIR = Path("textbook/Bubeck15-arXiv-1405.4980v2")

MATH_TEX = r"""
\begin{theorem}[Test]
Let $f : \cX \rightarrow \R$ be convex. Then
$$f(x) \leq f(y) + g^\top(x - y).$$
\end{theorem}
\begin{proof}
Obvious. \qed
\end{proof}
"""

def test_convert_contains_math(tmp_path):
    result = convert_to_markdown(MATH_TEX, TEX_DIR)
    # Math should survive in some form
    assert "f(x)" in result or "f(y)" in result

def test_convert_strips_begin_end(tmp_path):
    result = convert_to_markdown(MATH_TEX, TEX_DIR)
    # Raw \begin{theorem} should not appear verbatim in output
    assert r"\begin{theorem}" not in result

def test_convert_returns_string():
    result = convert_to_markdown(MATH_TEX, TEX_DIR)
    assert isinstance(result, str)
    assert len(result) > 10
```

**Step 3: Run to confirm failure**

```bash
python3 -m pytest tests/test_preprocess_tex.py -k "convert" -v
```

**Step 4: Implement `convert_to_markdown`**

Add to `scripts/preprocess_tex.py`:

```python
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
```

**Step 5: Run tests**

```bash
python3 -m pytest tests/test_preprocess_tex.py -k "convert" -v
```

Expected: all 3 PASS (pandoc path or fallback path)

**Step 6: Commit**

```bash
git add scripts/preprocess_tex.py tests/test_preprocess_tex.py
git commit -m "feat: add convert_to_markdown with pandoc + light-clean fallback"
```

---

## Task 6: Section file writing

Write each chunk as a markdown file with YAML front-matter. Preserve existing `lean_files`
status on re-runs (same logic as `preprocess_textbook.py`).

**Files:**
- Modify: `scripts/preprocess_tex.py`
- Modify: `tests/test_preprocess_tex.py`

**Step 1: Write failing tests**

```python
# add to tests/test_preprocess_tex.py
import yaml
from preprocess_tex import write_section_files

def _make_chunk(ch=1, sec=1, sub=None, sec_title="Section One",
                sub_title=None, label="sec:one", body="Some content."):
    return {
        "chapter": ch, "chapter_title": "Intro",
        "section": sec, "section_title": sec_title,
        "subsection": sub, "subsection_title": sub_title,
        "section_id": f"{ch}.{sec}" if sub is None else f"{ch}.{sec}.{sub}",
        "tex_label": label, "body_tex": body,
        "theorems": [],
        "markdown": "Some content.",
    }

def test_write_section_files_creates_files(tmp_path):
    chunks = [_make_chunk()]
    written = write_section_files(chunks, tmp_path, book="TestBook")
    assert len(written) == 1
    assert written[0].exists()

def test_write_section_files_filename_section(tmp_path):
    chunks = [_make_chunk(ch=2, sec=3, sec_title="The gravity method")]
    written = write_section_files(chunks, tmp_path, book="TestBook")
    assert written[0].name == "02_03_the_gravity_method.md"

def test_write_section_files_filename_subsection(tmp_path):
    chunks = [_make_chunk(ch=2, sec=3, sub=1, sec_title="Vaidya",
                          sub_title="Volumetric barrier")]
    written = write_section_files(chunks, tmp_path, book="TestBook")
    assert written[0].name == "02_03_01_volumetric_barrier.md"

def test_write_section_files_yaml_frontmatter(tmp_path):
    chunks = [_make_chunk(ch=1, sec=2, sec_title="Basic convexity",
                          label="sec:basic")]
    written = write_section_files(chunks, tmp_path, book="MyBook")
    text = written[0].read_text()
    assert text.startswith("---\n")
    end = text.index("\n---", 3)
    fm = yaml.safe_load(text[3:end])
    assert fm["book"] == "MyBook"
    assert fm["chapter"] == 1
    assert fm["section"] == 2
    assert fm["tex_label"] == "sec:basic"

def test_write_section_files_preserves_status(tmp_path):
    sections_dir = tmp_path / "sections"
    sections_dir.mkdir()
    existing = sections_dir / "01_01_section_one.md"
    existing_fm = {
        "book": "TestBook", "chapter": 1, "chapter_title": "Intro",
        "section": 1, "section_title": "Section One", "subsection": None,
        "subsection_title": None, "section_id": "1.1", "tex_label": "sec:one",
        "theorems": [{"id": "Theorem 1.1", "label": "Main", "tex_label": "th:main"}],
        "lean_files": [{"id": "Theorem 1.1",
                        "path": "proofs/TestBook/Theorem11.lean",
                        "status": "proved"}],
    }
    existing.write_text("---\n" + yaml.dump(existing_fm) + "---\n\nContent")

    chunks = [_make_chunk()]
    chunks[0]["theorems"] = [{"id": "Theorem 1.1", "label": "Main", "tex_label": "th:main"}]
    write_section_files(chunks, tmp_path, book="TestBook")

    text = existing.read_text()
    end = text.index("\n---", 3)
    fm = yaml.safe_load(text[3:end])
    assert fm["lean_files"][0]["status"] == "proved"  # preserved
```

**Step 2: Run to confirm failure**

```bash
python3 -m pytest tests/test_preprocess_tex.py -k "write_section" -v
```

**Step 3: Implement `write_section_files`**

Note: chunks passed in already have `theorems` and `markdown` keys added by the caller.

Add to `scripts/preprocess_tex.py`:

```python
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
            filename = f"{chunk['chapter']:02d}_{chunk['section']:02d}_{slug}.md"
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
```

**Step 4: Run tests**

```bash
python3 -m pytest tests/test_preprocess_tex.py -k "write_section" -v
```

Expected: all 5 PASS

**Step 5: Commit**

```bash
git add scripts/preprocess_tex.py tests/test_preprocess_tex.py
git commit -m "feat: add write_section_files with YAML front-matter and status preservation"
```

---

## Task 7: Index generation

Regenerate `index.md` from all section files. Reuse logic from `preprocess_textbook.py`.

**Files:**
- Modify: `scripts/preprocess_tex.py`
- Modify: `tests/test_preprocess_tex.py`

**Step 1: Write failing test**

```python
# add to tests/test_preprocess_tex.py
from preprocess_tex import write_index

def test_write_index(tmp_path):
    sections_dir = tmp_path / "sections"
    sections_dir.mkdir()
    fm = {
        "book": "TestBook", "chapter": 1, "chapter_title": "Intro",
        "section": 2, "section_title": "Basic convexity", "subsection": None,
        "subsection_title": None, "section_id": "1.2", "tex_label": "",
        "theorems": [{"id": "Proposition 1.1", "label": "Subgradients", "tex_label": ""}],
        "lean_files": [{"id": "Proposition 1.1",
                        "path": "proofs/TestBook/Proposition11.lean",
                        "status": "pending"}],
    }
    (sections_dir / "01_02_basic_convexity.md").write_text(
        "---\n" + yaml.dump(fm) + "---\n\nContent"
    )
    index_path = write_index(tmp_path)
    assert index_path.exists()
    text = index_path.read_text()
    assert "Proposition 1.1" in text
    assert "1.2" in text
    assert "pending" in text
```

**Step 2: Run to confirm failure**

```bash
python3 -m pytest tests/test_preprocess_tex.py::test_write_index -v
```

**Step 3: Implement `write_index`**

Add to `scripts/preprocess_tex.py`:

```python
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
        sub_title = fm.get("subsection_title") or fm.get("section_title", "")
        for lf in (fm.get("lean_files") or []):
            rows.append({
                "id": lf["id"],
                "section_id": section_id,
                "subsection_title": sub_title,
                "path": lf.get("path", ""),
                "status": lf.get("status", "pending"),
            })

    header = (
        "# Theorem & Lemma Index\n\n"
        "| ID | Section | Title | Lean file | Status |\n"
        "|----|---------|-------|-----------|--------|\n"
    )
    rows_text = "".join(
        f"| {r['id']} | {r['section_id']} | {r['subsection_title']} "
        f"| {r['path']} | {r['status']} |\n"
        for r in rows
    )
    index_path = paper_dir / "index.md"
    index_path.write_text(header + rows_text, encoding="utf-8")
    return index_path
```

**Step 4: Run test**

```bash
python3 -m pytest tests/test_preprocess_tex.py::test_write_index -v
```

Expected: PASS

**Step 5: Commit**

```bash
git add scripts/preprocess_tex.py tests/test_preprocess_tex.py
git commit -m "feat: add write_index for master theorem tracker"
```

---

## Task 8: Main entry point and CLI

Wire all functions together into `preprocess_tex(tex_dir, chapter=None)` and add `argparse` CLI.

**Files:**
- Modify: `scripts/preprocess_tex.py`

**Step 1: Add main pipeline function**

Replace the `if __name__ == "__main__":` block at the bottom with:

```python
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

        # Detect theorems and convert markdown per chunk
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
```

**Step 2: Run a quick integration test on chapter 1 only**

```bash
cd "/Users/apple/Documents/formal verification/prover"
python3 scripts/preprocess_tex.py textbook/Bubeck15-arXiv-1405.4980v2 --chapter 1
```

Expected output:
```
[tex] Processing chapter 1: intro2.tex
[tex]   6 chunk(s)
[tex]   wrote papers/Bubeck_convex_optimization/sections/01_01_...md
...
[tex] Index → papers/Bubeck_convex_optimization/index.md
[tex] Done. 6 sections, N theorems.
```

**Step 3: Inspect output**

```bash
ls papers/Bubeck_convex_optimization/sections/
cat papers/Bubeck_convex_optimization/index.md
head -40 papers/Bubeck_convex_optimization/sections/01_02_basic_properties_of_convexity.md
```

Verify: YAML front-matter is valid, theorems detected, math is readable.

**Step 4: Commit**

```bash
git add scripts/preprocess_tex.py
git commit -m "feat: add preprocess_tex main pipeline and CLI"
```

---

## Task 9: Full run and CLAUDE.md update

Run on all 6 chapters, verify output, then document the new workflow in CLAUDE.md.

**Step 1: Run full pipeline**

```bash
python3 scripts/preprocess_tex.py textbook/Bubeck15-arXiv-1405.4980v2/
```

**Step 2: Spot-check output**

```bash
# Check section count
ls papers/Bubeck_convex_optimization/sections/ | wc -l

# Check a theorem-rich chapter
cat papers/Bubeck_convex_optimization/sections/03_*.md | grep "^| " | head -20

# Check index
cat papers/Bubeck_convex_optimization/index.md
```

**Step 3: Run full test suite to confirm no regressions**

```bash
python3 -m pytest tests/ -v
```

Expected: all tests PASS

**Step 4: Add Workflow D to CLAUDE.md**

Add after the existing Workflow C block:

```markdown
### Workflow D — TeX source → Subsections → Prove a theorem

Use `scripts/preprocess_tex.py` when the TeX source is available (higher quality than PDF).

```bash
# Process all chapters
python3 scripts/preprocess_tex.py textbook/Bubeck15-arXiv-1405.4980v2/

# Or just one chapter
python3 scripts/preprocess_tex.py textbook/Bubeck15-arXiv-1405.4980v2/ --chapter 2

# Output: papers/Bubeck_convex_optimization/sections/*.md + index.md
```

Output structure mirrors Workflow C (same YAML front-matter, same index format).
Re-runs preserve existing lean_files status.
```

**Step 5: Commit everything**

```bash
git add papers/Bubeck_convex_optimization/ CLAUDE.md
git commit -m "feat: run preprocess_tex on Bubeck15 TeX source, add Workflow D to CLAUDE.md"
```

---

## Summary

| Task | What it builds |
|------|---------------|
| 1 | Script scaffold + test file |
| 2 | `load_macros` — parse Commands.tex |
| 3 | `parse_chunks` — split TeX at `\section`/`\subsection` |
| 4 | `detect_theorems_tex` — find theorem environments in raw TeX |
| 5 | `convert_to_markdown` — pandoc + light-clean fallback |
| 6 | `write_section_files` — YAML + markdown output, status preservation |
| 7 | `write_index` — master theorem tracker |
| 8 | `preprocess_tex` — main pipeline + CLI |
| 9 | Full run + CLAUDE.md update |
