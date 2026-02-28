"""Tests for preprocess_textbook pipeline."""
import sys
import os
import tempfile
from pathlib import Path

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'scripts'))

from preprocess_textbook import split_subsections, detect_theorems, write_section_files, write_index


# --- detect_theorems tests ---

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


# --- write_section_files tests ---

def _make_sub(ch=1, sub=1, ch_title="Intro", sub_title="Topic",
              content="## 1.1 Topic\n\nText."):
    return {
        'chapter': ch, 'chapter_title': ch_title,
        'subsection': sub, 'subsection_title': sub_title,
        'section_id': f'{ch}.{sub}', 'content': content,
    }


def test_write_creates_file():
    with tempfile.TemporaryDirectory() as tmp:
        paper_dir = Path(tmp)
        write_section_files([_make_sub()], paper_dir, book="Bubeck15")
        files = list((paper_dir / 'sections').iterdir())
        assert len(files) == 1
        assert files[0].name == '01_01_topic.md'


def test_write_yaml_frontmatter():
    with tempfile.TemporaryDirectory() as tmp:
        paper_dir = Path(tmp)
        write_section_files([_make_sub()], paper_dir, book="Bubeck15")
        content = (paper_dir / 'sections' / '01_01_topic.md').read_text()
        # Check key fields are present (not quoting-style dependent)
        assert 'book:' in content and 'Bubeck15' in content
        assert 'chapter: 1' in content
        assert 'section_id:' in content and '1.1' in content


def test_write_preserves_lean_files_on_rerun():
    with tempfile.TemporaryDirectory() as tmp:
        paper_dir = Path(tmp)
        # Use content that contains Theorem 1.1 so it appears in lean_files
        sub = _make_sub(content="## 1.1 Topic\n\nTheorem 1.1 (Key result). Proof.")
        write_section_files([sub], paper_dir, book="Bubeck15")
        path = paper_dir / 'sections' / '01_01_topic.md'
        # Manually update status to 'proved' in the file
        text = path.read_text()
        text = text.replace('status: pending', 'status: proved')
        path.write_text(text)
        # Re-run: should preserve proved status
        write_section_files([sub], paper_dir, book="Bubeck15")
        new_text = path.read_text()
        assert 'proved' in new_text


# --- write_index tests ---

def test_write_index_creates_file():
    with tempfile.TemporaryDirectory() as tmp:
        paper_dir = Path(tmp)
        sub = _make_sub(content="## 1.1 Topic\n\nTheorem 1.1 (Key result). Proof here.")
        write_section_files([sub], paper_dir, book="Bubeck15")
        write_index(paper_dir)
        assert (paper_dir / 'index.md').exists()


def test_write_index_contains_theorem():
    with tempfile.TemporaryDirectory() as tmp:
        paper_dir = Path(tmp)
        sub = _make_sub(content="## 1.1 Topic\n\nTheorem 1.1 (Key result). Proof here.")
        write_section_files([sub], paper_dir, book="Bubeck15")
        write_index(paper_dir)
        index_text = (paper_dir / 'index.md').read_text()
        assert 'Theorem 1.1' in index_text
        assert '1.1' in index_text


def test_write_index_empty_sections():
    with tempfile.TemporaryDirectory() as tmp:
        paper_dir = Path(tmp)
        (paper_dir / 'sections').mkdir()
        write_index(paper_dir)
        index_text = (paper_dir / 'index.md').read_text()
        assert '# Theorem' in index_text


# --- split_subsections tests ---

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
