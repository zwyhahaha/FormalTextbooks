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
