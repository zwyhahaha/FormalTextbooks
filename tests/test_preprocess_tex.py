"""Tests for preprocess_tex pipeline."""
import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'scripts'))


def test_import():
    import preprocess_tex  # noqa: F401


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
