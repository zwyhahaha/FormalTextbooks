"""Tests for the preprocessing pipeline section splitter."""
import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'scripts'))

from preprocess import split_sections, write_section_files


def test_splits_by_top_level_header():
    md = """# Introduction
Some intro text.

# Convergence Analysis
Let $f$ be $L$-smooth.

**Theorem 1**: ...
"""
    sections = split_sections(md)
    assert len(sections) == 2
    assert sections[0]['title'] == 'Introduction'
    assert sections[1]['title'] == 'Convergence Analysis'


def test_section_content_preserved():
    md = """# Preliminaries
Let $f: \\mathbb{R}^n \\to \\mathbb{R}$ be convex.
"""
    sections = split_sections(md)
    assert len(sections) == 1
    assert '$f:' in sections[0]['content']


def test_section_numbers():
    md = "# A\nfoo\n\n# B\nbar\n\n# C\nbaz\n"
    sections = split_sections(md)
    assert [s['number'] for s in sections] == [1, 2, 3]


def test_empty_input():
    sections = split_sections("")
    assert sections == []


def test_no_headers():
    sections = split_sections("Just some text without headers.")
    assert sections == []


def test_metadata_frontmatter():
    """Each section dict has title, number, content keys."""
    md = "# My Section\nContent here.\n"
    sections = split_sections(md)
    assert 'title' in sections[0]
    assert 'number' in sections[0]
    assert 'content' in sections[0]


def test_title_with_colon_yaml_safe():
    """Titles containing colons must be quoted in YAML front-matter."""
    import tempfile
    from pathlib import Path

    md = "# Analysis: Proof\nContent.\n"
    sections = split_sections(md)
    with tempfile.TemporaryDirectory() as tmpdir:
        paper_dir = Path(tmpdir)
        write_section_files(sections, paper_dir, 'paper')
        files = list((paper_dir / 'sections').iterdir())
        assert len(files) == 1
        content = files[0].read_text()
        # title line should be: title: "Analysis: Proof" (quoted)
        assert 'title: "Analysis: Proof"' in content
