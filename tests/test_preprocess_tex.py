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


from preprocess_tex import convert_to_markdown

MATH_TEX = r"""
\begin{theorem}[Test]
Let $f : \cX \rightarrow \R$ be convex. Then
$$f(x) \leq f(y) + g^\top(x - y).$$
\end{theorem}
\begin{proof}
Obvious. \qed
\end{proof}
"""


def test_convert_contains_math():
    result = convert_to_markdown(MATH_TEX, TEX_DIR)
    assert "f(x)" in result or "f(y)" in result


def test_convert_strips_begin_end():
    result = convert_to_markdown(MATH_TEX, TEX_DIR)
    assert r"\begin{theorem}" not in result


def test_convert_returns_string():
    result = convert_to_markdown(MATH_TEX, TEX_DIR)
    assert isinstance(result, str)
    assert len(result) > 10


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
