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
_THEOREM_RE = re.compile(
    r'\b(Theorem|Lemma|Proposition|Corollary|Definition)\s+(\d+\.\d+)'
    r'\s*(?:\(([^)]+)\))?',
    re.MULTILINE
)


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
    parser = argparse.ArgumentParser(
        description='Preprocess textbook PDF into subsection markdown.')
    parser.add_argument('pdf', help='Path to PDF file')
    parser.add_argument('--chapter', type=int, default=None,
                        help='Process only this chapter number')
    args = parser.parse_args()
    preprocess_textbook(Path(args.pdf), chapter=args.chapter)


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

        theorems = detect_theorems(sub['content'])

        # Preserve existing lean_files status from previous run
        existing_lean: dict[str, str] = {}
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


def write_index(paper_dir: Path) -> Path:
    """Regenerate paper_dir/index.md from all section files."""
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

    def chapter_at(pos: int) -> tuple:
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
        # Infer chapter number from subsection header (e.g. "## 1.1")
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
