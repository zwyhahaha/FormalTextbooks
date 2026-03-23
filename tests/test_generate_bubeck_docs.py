"""Tests for the formalization docs generator."""

from __future__ import annotations

import json
import os
import shutil
import subprocess
import sys
from pathlib import Path

import pytest
import yaml

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "scripts"))

from generate_bubeck_docs import (
    build_site_manifest,
    compute_status,
    extract_intro_and_blocks,
    extract_lean_snippet,
    generate_docs,
    parse_selected_books,
    sort_key_for_section_id,
)


def write_section(
    path: Path,
    *,
    book: str,
    chapter: int,
    chapter_title: str,
    section_title: str,
    section_id: str,
    theorems: list[dict[str, str]],
    lean_files: list[dict[str, str]],
    body: str,
) -> None:
    """Write a structured section markdown file."""
    front_matter = {
        "book": book,
        "chapter": chapter,
        "chapter_title": chapter_title,
        "section_title": section_title,
        "subsection_title": None,
        "section_id": section_id,
        "theorems": theorems,
        "lean_files": lean_files,
    }
    text = "---\n" + yaml.safe_dump(front_matter, sort_keys=False) + "---\n\n" + body
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")


def write_book_metadata(root: Path, book: str, *, title: str, description: str) -> None:
    """Write per-book site metadata."""
    path = root / "docs" / "roadmaps" / book / "book.yml"
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        yaml.safe_dump(
            {
                "book_title": title,
                "book_description": description,
            },
            sort_keys=False,
        ),
        encoding="utf-8",
    )


def write_roadmap(
    root: Path,
    book: str,
    chapter: int,
    *,
    chapter_title: str,
    goal: str,
    priority: str,
) -> None:
    """Write a chapter roadmap markdown file."""
    path = root / "docs" / "roadmaps" / book / f"chapter-{chapter}.md"
    path.parent.mkdir(parents=True, exist_ok=True)
    front_matter = {
        "chapter": chapter,
        "chapter_title": chapter_title,
        "goal": goal,
        "priority": priority,
        "milestones": [{"title": "First milestone", "status": "done"}],
        "known_blockers": ["Needs follow-up"],
        "suggested_proof_order": ["Theorem 1.1"],
        "dependencies": ["Shared helper lemmas"],
    }
    text = (
        "---\n"
        + yaml.safe_dump(front_matter, sort_keys=False)
        + "---\n\n"
        + "Roadmap note for this chapter.\n"
    )
    path.write_text(text, encoding="utf-8")


def test_compute_status_missing_file_pending(tmp_path: Path) -> None:
    status, exists = compute_status(tmp_path / "Missing.lean", "pending")
    assert status == "pending"
    assert exists is False


def test_compute_status_missing_file_failed(tmp_path: Path) -> None:
    status, exists = compute_status(tmp_path / "Missing.lean", "failed")
    assert status == "failed"
    assert exists is False


def test_compute_status_partial(tmp_path: Path) -> None:
    lean_file = tmp_path / "Lemma22.lean"
    lean_file.write_text("theorem lemma_2_2 : True := by\n  sorry\n", encoding="utf-8")
    status, exists = compute_status(lean_file, "pending")
    assert status == "partial"
    assert exists is True


def test_compute_status_proved(tmp_path: Path) -> None:
    lean_file = tmp_path / "Lemma31.lean"
    lean_file.write_text("theorem lemma_3_1 : True := by\n  trivial\n", encoding="utf-8")
    status, exists = compute_status(lean_file, "partial")
    assert status == "proved"
    assert exists is True


def test_sort_key_for_section_id_orders_numerically() -> None:
    ordered = sorted(["3.10", "3.2", "3.2.1"], key=sort_key_for_section_id)
    assert ordered == ["3.2", "3.2.1", "3.10"]


def test_extract_intro_and_blocks_walks_multiple_results() -> None:
    body = """
\\section{Gradient descent}
Intro paragraph.

**Theorem**
Main statement.

*Proof.*
Proof body.

**Lemma**
Auxiliary statement.
"""
    intro, blocks = extract_intro_and_blocks(body)
    assert "Intro paragraph" in intro
    assert len(blocks) == 2
    assert blocks[0]["kind"] == "Theorem"
    assert "Main statement" in blocks[0]["statement"]
    assert "*Proof.*" not in blocks[0]["statement"]
    assert blocks[1]["kind"] == "Lemma"


def test_extract_lean_snippet_prefers_matching_declaration(tmp_path: Path) -> None:
    lean_file = tmp_path / "Proposition16.lean"
    lean_file.write_text(
        """import Mathlib

/-!
# Proposition 1.6
-/

theorem proposition_1_6_local_is_global : True := by
  trivial

theorem proposition_1_6_zero_subdiff_iff : True := by
  trivial
""",
        encoding="utf-8",
    )
    snippet, symbol = extract_lean_snippet(lean_file, "Proposition 1.6")
    assert "proposition_1_6_local_is_global" in snippet
    assert "proposition_1_6_zero_subdiff_iff" in snippet
    assert symbol == "proposition_1_6_local_is_global"


def test_build_site_manifest_supports_multiple_books_and_roadmaps(tmp_path: Path) -> None:
    root = tmp_path

    write_book_metadata(root, "BookA", title="Book A", description="Primary test book")
    write_book_metadata(root, "BookB", title="Book B", description="Secondary test book")
    write_roadmap(root, "BookA", 1, chapter_title="Intro", goal="Finish the first chapter", priority="high")
    write_roadmap(root, "BookB", 1, chapter_title="Setup", goal="Stage the alternate source", priority="exploratory")

    proof_a = root / "proofs" / "BookA" / "Theorem11.lean"
    proof_a.parent.mkdir(parents=True, exist_ok=True)
    proof_a.write_text(
        """import Mathlib

theorem theorem_1_1 : True := by
  trivial
""",
        encoding="utf-8",
    )

    write_section(
        root / "papers" / "BookA" / "sections" / "01_01_intro.md",
        book="BookA",
        chapter=1,
        chapter_title="Intro",
        section_title="Intro",
        section_id="1.1",
        theorems=[{"id": "Theorem 1.1", "label": "A theorem"}],
        lean_files=[{"id": "Theorem 1.1", "path": "proofs/BookA/Theorem11.lean", "status": "pending"}],
        body=r"""
\section{Intro}
Context.

**Theorem**
Statement.
\label{th:test}
$$x^2 + y^2 \leq z^2$$
""".strip(),
    )
    (root / "papers" / "BookA" / "index.md").write_text(
        "\n".join(
            [
                "# Theorem & Lemma Index",
                "",
                "| ID | Name | Section | Section Title | Lean file | Status | Time |",
                "|----|------|---------|---------------|-----------|--------|------|",
                "| Theorem 1.1 | A theorem | 1.1 | Intro | proofs/BookA/Theorem11.lean | pending | 1m |",
            ]
        ),
        encoding="utf-8",
    )

    write_section(
        root / "papers" / "BookB" / "sections" / "01_01_setup.md",
        book="BookB",
        chapter=1,
        chapter_title="Setup",
        section_title="Setup",
        section_id="1.1",
        theorems=[{"id": "Theorem 1.1", "label": "Pending theorem"}],
        lean_files=[{"id": "Theorem 1.1", "path": "proofs/BookB/Theorem11.lean", "status": "pending"}],
        body="""
\\section{Setup}
Alt source.

**Theorem**
Pending statement.
""".strip(),
    )
    (root / "papers" / "BookB" / "index.md").write_text(
        "\n".join(
            [
                "# Theorem & Lemma Index",
                "",
                "| ID | Section | Subsection Title | Lean file | Status |",
                "|----|---------|------------------|-----------|--------|",
                "| Theorem 1.1 | 1.1 | Setup | proofs/BookB/Theorem11.lean | pending |",
            ]
        ),
        encoding="utf-8",
    )

    manifest = build_site_manifest(root=root, selected_books=None, repo_url="https://github.com/example/repo")

    assert manifest["book_count"] == 2
    assert [book["book_slug"] for book in manifest["books"]] == ["BookA", "BookB"]

    book_a = manifest["books"][0]
    result_a = book_a["results"][0]
    assert book_a["book_title"] == "Book A"
    assert book_a["chapters"][0]["roadmap"]["goal"] == "Finish the first chapter"
    assert result_a["computed_status"] == "proved"
    assert result_a["proof_file_status"] == "present"
    assert "theorem_1_1" in result_a["lean_snippet"]
    assert result_a["lean_symbol_name"] == "theorem_1_1"

    book_b = manifest["books"][1]
    assert book_b["results"][0]["computed_status"] == "pending"
    assert book_b["results"][0]["lean_snippet"] == ""


def test_generate_docs_writes_multibook_pages_and_manifests(tmp_path: Path) -> None:
    root = tmp_path
    out_dir = root / "site_docs" / "generated"
    (root / "site_docs").mkdir(parents=True)

    write_book_metadata(root, "BookA", title="Book A", description="Primary test book")
    write_roadmap(root, "BookA", 1, chapter_title="Intro", goal="Ship chapter 1", priority="high")

    proof_a = root / "proofs" / "BookA" / "Theorem11.lean"
    proof_a.parent.mkdir(parents=True, exist_ok=True)
    proof_a.write_text(
        """import Mathlib

theorem theorem_1_1 : True := by
  trivial
""",
        encoding="utf-8",
    )

    write_section(
        root / "papers" / "BookA" / "sections" / "01_01_intro.md",
        book="BookA",
        chapter=1,
        chapter_title="Intro",
        section_title="Intro",
        section_id="1.1",
        theorems=[{"id": "Theorem 1.1", "label": "A theorem"}],
        lean_files=[{"id": "Theorem 1.1", "path": "proofs/BookA/Theorem11.lean", "status": "pending"}],
        body=r"""
\section{Intro}
Context.

**Theorem**
Statement.
\label{th:test}
$$x^2 + y^2 \leq z^2$$
""".strip(),
    )
    (root / "papers" / "BookA" / "index.md").write_text(
        "\n".join(
            [
                "# Theorem & Lemma Index",
                "",
                "| ID | Name | Section | Section Title | Lean file | Status | Time |",
                "|----|------|---------|---------------|-----------|--------|------|",
                "| Theorem 1.1 | A theorem | 1.1 | Intro | proofs/BookA/Theorem11.lean | pending | 1m |",
            ]
        ),
        encoding="utf-8",
    )

    generate_docs(root=root, selected_books=None, out_dir=out_dir, repo_url="")

    manifest = json.loads((out_dir / "site_manifest.json").read_text(encoding="utf-8"))
    assert manifest["book_count"] == 1
    assert (root / "site_docs" / "index.md").exists()
    assert (root / "site_docs" / "books.md").exists()
    assert (root / "site_docs" / "progress.md").exists()
    assert (root / "site_docs" / "contributing.md").exists()
    assert (root / "site_docs" / "generated" / "books" / "BookA" / "index.md").exists()
    assert (root / "site_docs" / "generated" / "books" / "BookA" / "chapters" / "chapter-1.md").exists()
    assert (root / "site_docs" / "generated" / "books" / "BookA" / "results" / "theorem-1-1.md").exists()

    theorem_page = (
        root / "site_docs" / "generated" / "books" / "BookA" / "results" / "theorem-1-1.md"
    ).read_text(encoding="utf-8")
    assert "## Lean Formalization" in theorem_page
    assert "theorem_1_1" in theorem_page
    assert "Roadmap context" in theorem_page
    assert "$$" not in theorem_page
    assert "\\[" in theorem_page
    assert "\\label{" not in theorem_page


def test_parse_selected_books_accepts_legacy_filter() -> None:
    assert parse_selected_books("") is None
    assert parse_selected_books("BookA") == ["BookA"]
    assert parse_selected_books("BookA, BookB") == ["BookA", "BookB"]


def test_generator_reflects_repo_status_and_roadmaps() -> None:
    root = Path(__file__).resolve().parents[1]
    manifest = build_site_manifest(root=root, selected_books=["Bubeck_convex_optimization"], repo_url="")

    assert manifest["book_count"] == 1
    book = manifest["books"][0]
    assert book["book_title"] == "Bubeck Convex Optimization"
    assert book["chapters"][0]["roadmap"]["goal"]

    theorem_3_3 = next(item for item in book["results"] if item["id"] == "Theorem 3.3")
    lemma_2_2 = next(item for item in book["results"] if item["id"] == "Lemma 2.2")
    assert theorem_3_3["computed_status"] == "proved"
    assert "theorem_3_3" in theorem_3_3["lean_snippet"]
    assert lemma_2_2["computed_status"] == "partial"


def test_mkdocs_build_smoke() -> None:
    if shutil.which("mkdocs") is None:
        pytest.skip("mkdocs is not installed in the local environment")

    root = Path(__file__).resolve().parents[1]
    generator = root / "scripts" / "generate_bubeck_docs.py"
    subprocess.run(
        [sys.executable, str(generator), "--out", "site_docs/generated"],
        check=True,
        cwd=root,
        capture_output=True,
        text=True,
    )
    subprocess.run(
        ["mkdocs", "build"],
        check=True,
        cwd=root,
        capture_output=True,
        text=True,
    )
