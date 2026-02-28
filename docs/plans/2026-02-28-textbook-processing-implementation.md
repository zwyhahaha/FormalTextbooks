# Textbook Processing Pipeline Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build `scripts/preprocess_textbook.py` that converts a textbook PDF into subsection-level markdown files with YAML front-matter, theorem detection, and a master `index.md` tracker.

**Architecture:** `marker_single` handles PDF→markdown (same as `preprocess.py`). A new script splits at `## X.Y` subsection headers, runs regex theorem detection on each, writes YAML-prefixed section files (preserving existing lean_files status on re-runs), and regenerates a master `index.md`. All logic is pure functions; CLI wires them together.

**Tech Stack:** Python 3.12, `marker_single` (at `/Library/Frameworks/Python.framework/Versions/3.12/bin/marker_single`), `pytest`, `pyyaml`

---

### Task 1: Test `split_subsections` — basic splitting

**Files:**
- Create: `tests/test_preprocess_textbook.py`

**Step 1: Write the failing test**

```python
"""Tests for preprocess_textbook pipeline."""
import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'scripts'))

from preprocess_textbook import split_subsections

def test_split_basic():
    md = """# 1 Introduction

## 1.1 Some convex problems

Content about convex problems.

## 1.2 Basic properties

Content about properties.
"""
    subs = split_subsections(md)
    assert len(subs) == 2
    assert subs[0]['chapter'] == 1
    assert subs[0]['chapter_title'] == 'Introduction'
    assert subs[0]['subsection'] == 1
    assert subs[0]['subsection_title'] == 'Some convex problems'
    assert subs[0]['section_id'] == '1.1'
    assert subs[1]['subsection'] == 2
    assert subs[1]['section_id'] == '1.2'
```

**Step 2: Run test to verify it fails**

```bash
cd "/Users/apple/Documents/formal verification/prover"
python -m pytest tests/test_preprocess_textbook.py::test_split_basic -v
```
Expected: `ImportError` or `ModuleNotFoundError` (script doesn't exist yet).

**Step 3: Create `scripts/preprocess_textbook.py` with `split_subsections`**

```python
"""Textbook preprocessing pipeline: PDF → subsection-level markdown files."""
import datetime
import json
import re
import shutil
import subprocess
import sys
from pathlib import Path

import yaml

LOG_FILE = Path("logs/pipeline.log")

MARKER_SINGLE_FULL_PATH = (
    "/Library/Frameworks/Python.framework/Versions/3.12/bin/marker_single"
)

_CHAPTER_RE = re.compile(r'^# (?:(\d+)\s+)?(.+)$', re.MULTILINE)
_SUBSECTION_RE = re.compile(r'^## (\d+)\.(\d+)\s+(.+)$', re.MULTILINE)


def split_subsections(markdown: str) -> list[dict]:
    """Split markdown at '## X.Y Title' subsection headers.

    Each returned dict has:
      chapter, chapter_title, subsection, subsection_title, section_id, content
    """
    if not markdown:
        return []

    # Build a map of position → chapter info from '#' headers
    chapter_map = []
    for m in _CHAPTER_RE.finditer(markdown):
        num = int(m.group(1)) if m.group(1) else None
        chapter_map.append((m.start(), num, m.group(2).strip()))

    def chapter_at(pos: int) -> tuple[int | None, str]:
        """Return (chapter_num, chapter_title) for the chapter containing pos."""
        result = (None, "")
        for cpos, cnum, ctitle in chapter_map:
            if cpos <= pos:
                result = (cnum, ctitle)
        return result

    subsection_headers = list(_SUBSECTION_RE.finditer(markdown))
    if not subsection_headers:
        return []

    result = []
    for idx, match in enumerate(subsection_headers):
        ch_num, ch_title = chapter_at(match.start())
        sub_num = int(match.group(2))
        sub_title = match.group(3).strip()
        # Infer chapter number from subsection header if chapter header had no number
        actual_ch = int(match.group(1))
        start = match.start()
        end = (subsection_headers[idx + 1].start()
               if idx + 1 < len(subsection_headers) else len(markdown))
        result.append({
            'chapter': actual_ch,
            'chapter_title': ch_title,
            'subsection': sub_num,
            'subsection_title': sub_title,
            'section_id': f'{actual_ch}.{sub_num}',
            'content': markdown[start:end].rstrip(),
        })
    return result
```

**Step 4: Run test to verify it passes**

```bash
python -m pytest tests/test_preprocess_textbook.py::test_split_basic -v
```
Expected: `PASSED`

**Step 5: Commit**

```bash
git add scripts/preprocess_textbook.py tests/test_preprocess_textbook.py
git commit -m "feat: add split_subsections with basic test"
```

---

### Task 2: Test `split_subsections` — edge cases

**Files:**
- Modify: `tests/test_preprocess_textbook.py`

**Step 1: Add edge-case tests**

```python
def test_split_empty():
    assert split_subsections("") == []

def test_split_no_subsections():
    assert split_subsections("# 1 Intro\n\nSome text.") == []

def test_split_cross_chapter():
    md = """# 1 Introduction

## 1.1 First

Content A.

# 2 Methods

## 2.1 Setup

Content B.

## 2.2 Details

Content C.
"""
    subs = split_subsections(md)
    assert len(subs) == 3
    assert subs[0]['chapter'] == 1
    assert subs[0]['chapter_title'] == 'Introduction'
    assert subs[1]['chapter'] == 2
    assert subs[1]['chapter_title'] == 'Methods'
    assert subs[2]['section_id'] == '2.2'

def test_split_content_preserved():
    md = "# 1 Intro\n\n## 1.1 Topic\n\nLet $f: \\mathbb{R}^n \\to \\mathbb{R}$.\n"
    subs = split_subsections(md)
    assert '$f:' in subs[0]['content']
```

**Step 2: Run tests**

```bash
python -m pytest tests/test_preprocess_textbook.py -v -k "split"
```
Expected: all 5 split tests `PASSED`

**Step 3: Commit**

```bash
git add tests/test_preprocess_textbook.py
git commit -m "test: add edge-case tests for split_subsections"
```

---

### Task 3: Test and implement `detect_theorems`

**Files:**
- Modify: `tests/test_preprocess_textbook.py`
- Modify: `scripts/preprocess_textbook.py`

**Step 1: Write the failing tests**

```python
from preprocess_textbook import detect_theorems

def test_detect_basic():
    content = "See Theorem 3.2 for the main result."
    thms = detect_theorems(content)
    assert len(thms) == 1
    assert thms[0]['id'] == 'Theorem 3.2'
    assert thms[0]['label'] == ''

def test_detect_with_label():
    content = "Lemma 1.1 (Projection onto convex set). Let $C$ be convex."
    thms = detect_theorems(content)
    assert len(thms) == 1
    assert thms[0]['id'] == 'Lemma 1.1'
    assert thms[0]['label'] == 'Projection onto convex set'

def test_detect_multiple():
    content = """
Theorem 3.2. GD converges.
Corollary 3.3 (Rate). The rate is O(1/k).
Definition 4.1. A function is L-smooth if...
"""
    thms = detect_theorems(content)
    ids = [t['id'] for t in thms]
    assert 'Theorem 3.2' in ids
    assert 'Corollary 3.3' in ids
    assert 'Definition 4.1' in ids

def test_detect_empty():
    assert detect_theorems("") == []

def test_detect_no_theorems():
    assert detect_theorems("Just some regular prose.") == []
```

**Step 2: Run to verify failure**

```bash
python -m pytest tests/test_preprocess_textbook.py -v -k "detect"
```
Expected: `ImportError` for `detect_theorems`

**Step 3: Implement `detect_theorems` in `scripts/preprocess_textbook.py`**

```python
_THEOREM_RE = re.compile(
    r'\b(Theorem|Lemma|Proposition|Corollary|Definition)\s+(\d+\.\d+)'
    r'\s*(?:\(([^)]+)\))?',
    re.MULTILINE
)


def detect_theorems(content: str) -> list[dict]:
    """Find Theorem/Lemma/Proposition/Corollary/Definition X.Y in content.

    Returns list of {id, label} dicts. label is empty string if no parenthetical.
    Deduplicates by id (first occurrence wins).
    """
    seen: set[str] = set()
    result = []
    for m in _THEOREM_RE.finditer(content):
        thm_id = f'{m.group(1)} {m.group(2)}'
        if thm_id in seen:
            continue
        seen.add(thm_id)
        result.append({
            'id': thm_id,
            'label': (m.group(3) or '').strip(),
        })
    return result
```

**Step 4: Run tests**

```bash
python -m pytest tests/test_preprocess_textbook.py -v -k "detect"
```
Expected: all 5 detect tests `PASSED`

**Step 5: Commit**

```bash
git add scripts/preprocess_textbook.py tests/test_preprocess_textbook.py
git commit -m "feat: add detect_theorems with tests"
```

---

### Task 4: Test and implement `write_section_files`

**Files:**
- Modify: `tests/test_preprocess_textbook.py`
- Modify: `scripts/preprocess_textbook.py`

**Step 1: Write the failing tests**

```python
import tempfile
from pathlib import Path
from preprocess_textbook import write_section_files

def _make_sub(ch=1, sub=1, ch_title="Intro", sub_title="Topic", content="## 1.1 Topic\n\nText."):
    return {
        'chapter': ch, 'chapter_title': ch_title,
        'subsection': sub, 'subsection_title': sub_title,
        'section_id': f'{ch}.{sub}', 'content': content,
    }

def test_write_creates_file():
    with tempfile.TemporaryDirectory() as tmp:
        paper_dir = Path(tmp)
        subs = [_make_sub()]
        write_section_files(subs, paper_dir, book="Bubeck15")
        files = list((paper_dir / 'sections').iterdir())
        assert len(files) == 1
        assert files[0].name == '01_01_topic.md'

def test_write_yaml_frontmatter():
    with tempfile.TemporaryDirectory() as tmp:
        paper_dir = Path(tmp)
        subs = [_make_sub()]
        write_section_files(subs, paper_dir, book="Bubeck15")
        content = (paper_dir / 'sections' / '01_01_topic.md').read_text()
        assert 'book: "Bubeck15"' in content
        assert 'chapter: 1' in content
        assert 'section_id: "1.1"' in content

def test_write_preserves_lean_files_on_rerun():
    with tempfile.TemporaryDirectory() as tmp:
        paper_dir = Path(tmp)
        subs = [_make_sub()]
        # First run: no theorems, no lean_files
        write_section_files(subs, paper_dir, book="Bubeck15")
        # Manually inject a lean_files entry
        path = paper_dir / 'sections' / '01_01_topic.md'
        text = path.read_text()
        # Insert lean_files into YAML
        text = text.replace(
            'lean_files: []',
            'lean_files:\n  - {id: "Theorem 1.1", path: "proofs/T.lean", status: proved}'
        )
        path.write_text(text)
        # Second run: should preserve status
        write_section_files(subs, paper_dir, book="Bubeck15")
        new_text = path.read_text()
        assert 'status: proved' in new_text
```

**Step 2: Run to verify failure**

```bash
python -m pytest tests/test_preprocess_textbook.py -v -k "write_section"
```

**Step 3: Add `title_to_slug` and `write_section_files` to `scripts/preprocess_textbook.py`**

```python
def title_to_slug(title: str) -> str:
    """Lowercase, replace non-alphanumeric runs with '_', strip edges, max 40 chars."""
    slug = re.sub(r'[^a-z0-9]+', '_', title.lower()).strip('_')
    return slug[:40]


def _read_existing_lean_files(path: Path) -> list[dict]:
    """Parse YAML front-matter from an existing section file and return lean_files list."""
    text = path.read_text(encoding='utf-8')
    if not text.startswith('---'):
        return []
    end = text.find('\n---', 3)
    if end == -1:
        return []
    try:
        fm = yaml.safe_load(text[3:end])
        return fm.get('lean_files', []) or []
    except yaml.YAMLError:
        return []


def write_section_files(subsections: list[dict], paper_dir: Path, book: str) -> list[Path]:
    """Write each subsection to paper_dir/sections/{ch:02d}_{sub:02d}_{slug}.md.

    Preserves existing lean_files status on re-runs.
    Returns list of written Paths.
    """
    sections_dir = paper_dir / 'sections'
    sections_dir.mkdir(parents=True, exist_ok=True)
    written = []

    for sub in subsections:
        slug = title_to_slug(sub['subsection_title'])
        filename = f"{sub['chapter']:02d}_{sub['subsection']:02d}_{slug}.md"
        out_path = sections_dir / filename

        # Detect theorems in this subsection
        theorems = detect_theorems(sub['content'])

        # Preserve existing lean_files status from previous run
        existing_lean = {}
        if out_path.exists():
            for lf in _read_existing_lean_files(out_path):
                existing_lean[lf['id']] = lf.get('status', 'pending')

        lean_files = [
            {
                'id': t['id'],
                'path': f"proofs/{book}/{t['id'].replace(' ', '').replace('.', '')}.lean",
                'status': existing_lean.get(t['id'], 'pending'),
            }
            for t in theorems
        ]

        fm = {
            'book': book,
            'chapter': sub['chapter'],
            'chapter_title': sub['chapter_title'],
            'subsection': sub['subsection'],
            'subsection_title': sub['subsection_title'],
            'section_id': sub['section_id'],
            'theorems': theorems,
            'lean_files': lean_files,
        }
        front_matter = '---\n' + yaml.dump(fm, allow_unicode=True, sort_keys=False) + '---\n\n'
        out_path.write_text(front_matter + sub['content'], encoding='utf-8')
        written.append(out_path)

    return written
```

**Step 4: Run tests**

```bash
python -m pytest tests/test_preprocess_textbook.py -v -k "write_section"
```
Expected: all 3 write_section tests `PASSED`

**Step 5: Commit**

```bash
git add scripts/preprocess_textbook.py tests/test_preprocess_textbook.py
git commit -m "feat: add write_section_files with YAML front-matter and lean_files preservation"
```

---

### Task 5: Test and implement `write_index`

**Files:**
- Modify: `tests/test_preprocess_textbook.py`
- Modify: `scripts/preprocess_textbook.py`

**Step 1: Write the failing tests**

```python
from preprocess_textbook import write_index

def test_write_index_creates_file():
    with tempfile.TemporaryDirectory() as tmp:
        paper_dir = Path(tmp)
        # Write a section file first
        subs = [_make_sub(content="## 1.1 Topic\n\nTheorem 1.1 (Key result). Proof here.")]
        write_section_files(subs, paper_dir, book="Bubeck15")
        write_index(paper_dir)
        assert (paper_dir / 'index.md').exists()

def test_write_index_contains_theorem():
    with tempfile.TemporaryDirectory() as tmp:
        paper_dir = Path(tmp)
        subs = [_make_sub(content="## 1.1 Topic\n\nTheorem 1.1 (Key result). Proof here.")]
        write_section_files(subs, paper_dir, book="Bubeck15")
        write_index(paper_dir)
        index_text = (paper_dir / 'index.md').read_text()
        assert 'Theorem 1.1' in index_text
        assert '1.1' in index_text  # section_id column

def test_write_index_empty_sections():
    with tempfile.TemporaryDirectory() as tmp:
        paper_dir = Path(tmp)
        (paper_dir / 'sections').mkdir()
        write_index(paper_dir)
        index_text = (paper_dir / 'index.md').read_text()
        assert '# ' in index_text  # header still written
```

**Step 2: Run to verify failure**

```bash
python -m pytest tests/test_preprocess_textbook.py -v -k "write_index"
```

**Step 3: Implement `write_index` in `scripts/preprocess_textbook.py`**

```python
def write_index(paper_dir: Path) -> Path:
    """Regenerate paper_dir/index.md from all section files.

    Reads YAML front-matter from every sections/*.md file and builds
    a markdown table of all theorems/lemmas with their lean_files status.
    """
    sections_dir = paper_dir / 'sections'
    rows = []

    for md_file in sorted(sections_dir.glob('*.md')):
        text = md_file.read_text(encoding='utf-8')
        if not text.startswith('---'):
            continue
        end = text.find('\n---', 3)
        if end == -1:
            continue
        try:
            fm = yaml.safe_load(text[3:end])
        except yaml.YAMLError:
            continue

        section_id = fm.get('section_id', '')
        sub_title = fm.get('subsection_title', '')
        for lf in (fm.get('lean_files') or []):
            rows.append({
                'id': lf['id'],
                'section_id': section_id,
                'subsection_title': sub_title,
                'path': lf.get('path', ''),
                'status': lf.get('status', 'pending'),
            })

    header = (
        '# Theorem & Lemma Index\n\n'
        '| ID | Section | Subsection Title | Lean file | Status |\n'
        '|----|---------|------------------|-----------|--------|\n'
    )
    table_rows = ''.join(
        f"| {r['id']} | {r['section_id']} | {r['subsection_title']} "
        f"| {r['path']} | {r['status']} |\n"
        for r in rows
    )

    index_path = paper_dir / 'index.md'
    index_path.write_text(header + table_rows, encoding='utf-8')
    return index_path
```

**Step 4: Run tests**

```bash
python -m pytest tests/test_preprocess_textbook.py -v -k "write_index"
```
Expected: all 3 index tests `PASSED`

**Step 5: Commit**

```bash
git add scripts/preprocess_textbook.py tests/test_preprocess_textbook.py
git commit -m "feat: add write_index generating master theorem tracker"
```

---

### Task 6: Implement `convert_pdf_to_markdown` and `_log`

**Files:**
- Modify: `scripts/preprocess_textbook.py`

No new tests needed — this is a thin wrapper around `marker_single`, same logic as `preprocess.py`.

**Step 1: Add to `scripts/preprocess_textbook.py`**

```python
def _log(event: str, data: dict) -> None:
    """Append JSON-Lines entry to logs/pipeline.log."""
    LOG_FILE.parent.mkdir(parents=True, exist_ok=True)
    entry = {'ts': datetime.datetime.now().isoformat(timespec='seconds'), 'event': event, **data}
    with LOG_FILE.open('a', encoding='utf-8') as f:
        f.write(json.dumps(entry) + '\n')


def convert_pdf_to_markdown(pdf_path: Path, output_dir: Path) -> Path:
    """Convert PDF to markdown via marker_single. Returns path to .md file."""
    output_dir.mkdir(parents=True, exist_ok=True)
    candidates = [
        [MARKER_SINGLE_FULL_PATH, str(pdf_path), '--output_dir', str(output_dir)],
        ['marker_single', str(pdf_path), '--output_dir', str(output_dir)],
        ['marker', str(pdf_path), '--output_dir', str(output_dir)],
    ]
    last_error = None
    for cmd in candidates:
        try:
            result = subprocess.run(cmd, capture_output=True, text=True)
            if result.returncode == 0:
                stem = pdf_path.stem
                md_files = list(output_dir.rglob(f'{stem}.md')) or list(output_dir.rglob('*.md'))
                if md_files:
                    return md_files[0]
            last_error = result.stderr or f'exit code {result.returncode}'
        except FileNotFoundError as exc:
            last_error = str(exc)
    raise RuntimeError(f'marker_single failed: {last_error}')
```

**Step 2: Run all tests to confirm nothing broken**

```bash
python -m pytest tests/test_preprocess_textbook.py -v
```
Expected: all tests `PASSED`

**Step 3: Commit**

```bash
git add scripts/preprocess_textbook.py
git commit -m "feat: add convert_pdf_to_markdown and _log to textbook pipeline"
```

---

### Task 7: Wire up `preprocess_textbook` main entry point and CLI

**Files:**
- Modify: `scripts/preprocess_textbook.py`

**Step 1: Add `preprocess_textbook` function and `__main__` block**

```python
def preprocess_textbook(pdf_path: Path, chapter: int | None = None) -> None:
    """Main entry point: convert PDF, split, write section files and index."""
    pdf_path = Path(pdf_path)
    if not pdf_path.exists():
        raise FileNotFoundError(f'PDF not found: {pdf_path}')

    book = pdf_path.stem
    paper_dir = Path('papers') / book
    paper_dir.mkdir(parents=True, exist_ok=True)

    _log('preprocess_textbook_start', {'pdf': str(pdf_path), 'book': book})
    print(f'[textbook] Converting {pdf_path} …')

    tmp_dir = paper_dir / '_marker_tmp'
    md_path = convert_pdf_to_markdown(pdf_path, tmp_dir)

    full_md = paper_dir / 'full.md'
    shutil.copy2(md_path, full_md)
    print(f'[textbook] Full markdown → {full_md}')

    markdown = full_md.read_text(encoding='utf-8')
    subsections = split_subsections(markdown)

    if chapter is not None:
        subsections = [s for s in subsections if s['chapter'] == chapter]
        print(f'[textbook] Filtered to chapter {chapter}: {len(subsections)} subsection(s)')

    print(f'[textbook] {len(subsections)} subsection(s) found')
    written = write_section_files(subsections, paper_dir, book=book)
    for p in written:
        print(f'[textbook]   wrote {p}')

    index_path = write_index(paper_dir)
    print(f'[textbook] Index → {index_path}')

    all_theorems = sum(len(s.get('theorems', [])) for s in subsections)
    _log('preprocess_textbook_done', {
        'book': book,
        'chapter_filter': chapter,
        'subsections_count': len(subsections),
        'theorems_count': all_theorems,
        'output_dir': str(paper_dir / 'sections'),
    })
    print('[textbook] Done.')


if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser(description='Preprocess textbook PDF into subsection markdown.')
    parser.add_argument('pdf', help='Path to PDF file')
    parser.add_argument('--chapter', type=int, default=None, help='Process only this chapter number')
    args = parser.parse_args()
    preprocess_textbook(Path(args.pdf), chapter=args.chapter)
```

**Step 2: Run all tests**

```bash
python -m pytest tests/ -v
```
Expected: all tests in both test files `PASSED`

**Step 3: Commit**

```bash
git add scripts/preprocess_textbook.py
git commit -m "feat: wire up preprocess_textbook main entry point and --chapter CLI flag"
```

---

### Task 8: Unit test — run Chapter 1 on Bubeck15.pdf

**Files:**
- Read output: `papers/Bubeck15/sections/01_*.md`, `papers/Bubeck15/index.md`

**Step 1: Run Chapter 1 only**

```bash
cd "/Users/apple/Documents/formal verification/prover"
python3 scripts/preprocess_textbook.py textbook/Bubeck15.pdf --chapter 1
```
Expected output:
```
[textbook] Converting textbook/Bubeck15.pdf …
[textbook] Full markdown → papers/Bubeck15/full.md
[textbook] Filtered to chapter 1: 6 subsection(s)
[textbook]   wrote papers/Bubeck15/sections/01_01_*.md
...
[textbook] Index → papers/Bubeck15/index.md
[textbook] Done.
```

**Step 2: Inspect output**

```bash
ls papers/Bubeck15/sections/
cat papers/Bubeck15/sections/01_01_*.md | head -30
cat papers/Bubeck15/index.md
```

**Step 3: Show output to user for review**

Present the first section file (YAML + first 20 lines of content) and the index.md for user inspection. Ask: "Does this look right? Any adjustments needed?"

**Step 4: Commit if approved**

```bash
git add papers/Bubeck15/
git commit -m "data: add Bubeck15 Chapter 1 preprocessed sections (unit test)"
```

---

### Task 9: Update CLAUDE.md

**Files:**
- Modify: `CLAUDE.md`

**Step 1: Add textbook pipeline to CLAUDE.md**

Add under the "Quick Start" section:

```markdown
### Workflow C — Textbook → Subsections → Prove a theorem
```bash
# Step 1: preprocess a chapter (unit test)
python3 scripts/preprocess_textbook.py textbook/Bubeck15.pdf --chapter 1

# Step 2: inspect subsections
ls papers/Bubeck15/sections/
cat papers/Bubeck15/index.md

# Step 3: full book
python3 scripts/preprocess_textbook.py textbook/Bubeck15.pdf

# Step 4: formalize a subsection theorem
# "Prove Theorem 3.2 from papers/Bubeck15/sections/03_02_gradient_descent_for_smooth.md"
#   → /lean4:autoprove or /lean4:prove
#   → /lean4:checkpoint
#   → update lean_files status in section file + index
```
```

**Step 2: Commit**

```bash
git add CLAUDE.md
git commit -m "docs: add Workflow C for textbook preprocessing to CLAUDE.md"
```
