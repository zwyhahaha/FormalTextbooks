#!/usr/bin/env python3
"""Generate MkDocs content for the formalization portal."""

from __future__ import annotations

import argparse
import json
import re
import shutil
from pathlib import Path
from typing import Any

import yaml

FRONT_MATTER_CLOSE = "\n---\n"
RESULT_HEADING_RE = re.compile(
    r"(?m)^\*\*(Theorem|Lemma|Proposition|Corollary|Definition|Remark)\b.*?\*\*"
)
SORRY_RE = re.compile(r"\bsorry\b")
DECL_RE = re.compile(r"^(theorem|lemma|def|abbrev|instance|structure|class)\s+([A-Za-z0-9_'.]+)")
LABEL_LINE_RE = re.compile(r"(?m)^[ \t]*\\label\{[^}]+\}\s*$")
DISPLAY_MATH_RE = re.compile(r"\$\$(.+?)\$\$", re.DOTALL)

STATUS_DISPLAY = {
    "proved": "Proved",
    "partial": "Partial",
    "pending": "Pending",
    "failed": "Failed",
}
STATUS_ORDER = ("proved", "partial", "pending", "failed")
ROADMAP_PRIORITY_ORDER = {"critical": 0, "high": 1, "medium": 2, "low": 3, "exploratory": 4}
PRIMARY_BOOK_SLUG = "Bubeck_convex_optimization"


def slugify(text: str) -> str:
    """Convert text to a stable ASCII slug."""
    slug = re.sub(r"[^a-z0-9]+", "-", text.lower()).strip("-")
    return slug or "item"


def humanize_slug(text: str) -> str:
    """Convert a repo slug into a readable label."""
    return re.sub(r"[_-]+", " ", text).strip().title()


def sort_key_for_section_id(section_id: str) -> tuple[int, ...]:
    """Sort `1.2.3` numerically instead of lexicographically."""
    return tuple(int(part) for part in re.findall(r"\d+", section_id))


def split_front_matter(text: str) -> tuple[dict[str, Any], str]:
    """Return parsed YAML front matter and the remaining markdown body."""
    if not text.startswith("---\n"):
        raise ValueError("Section file is missing YAML front matter")
    end = text.find(FRONT_MATTER_CLOSE, 4)
    if end == -1:
        raise ValueError("Section file has unterminated YAML front matter")
    front_matter = yaml.safe_load(text[4:end]) or {}
    body = text[end + len(FRONT_MATTER_CLOSE) :]
    return front_matter, body


def parse_index_rows(index_path: Path) -> list[dict[str, str]]:
    """Parse theorem index rows with flexible table shapes."""
    if not index_path.exists():
        return []

    rows: list[dict[str, str]] = []
    for line in index_path.read_text(encoding="utf-8").splitlines():
        if not line.startswith("|"):
            continue
        parts = [part.strip() for part in line.strip("|").split("|")]
        if not parts or parts[0] in {"ID", "----", "---"} or parts[0].startswith("-"):
            continue

        row: dict[str, str]
        if len(parts) >= 7:
            row = {
                "theorem_id": parts[0],
                "theorem_name": parts[1],
                "section_id": parts[2],
                "section_title": parts[3],
                "lean_file": parts[4],
                "status": parts[5],
                "time": parts[6] or "—",
            }
        elif len(parts) == 6:
            row = {
                "theorem_id": parts[0],
                "theorem_name": parts[1],
                "section_id": parts[2],
                "section_title": parts[3],
                "lean_file": parts[4],
                "status": parts[5],
                "time": "—",
            }
        elif len(parts) == 5:
            row = {
                "theorem_id": parts[0],
                "theorem_name": "",
                "section_id": parts[1],
                "section_title": parts[2],
                "lean_file": parts[3],
                "status": parts[4],
                "time": "—",
            }
        else:
            continue
        rows.append(row)
    return rows


def find_tracker_row(
    rows: list[dict[str, str]], theorem_id: str, section_id: str
) -> dict[str, str]:
    """Find the index row for a result, preferring exact section matches."""
    exact_match = next(
        (
            row
            for row in rows
            if row.get("theorem_id") == theorem_id and row.get("section_id") == section_id
        ),
        None,
    )
    if exact_match is not None:
        return exact_match

    return next((row for row in rows if row.get("theorem_id") == theorem_id), {})


def extract_intro_and_blocks(body: str) -> tuple[str, list[dict[str, str]]]:
    """Split section markdown into intro text and theorem/lemma/etc blocks."""
    matches = list(RESULT_HEADING_RE.finditer(body))
    if not matches:
        return normalize_markdown_math(body), []

    intro = body[: matches[0].start()].strip()
    blocks: list[dict[str, str]] = []
    for index, match in enumerate(matches):
        block_start = match.start()
        block_end = matches[index + 1].start() if index + 1 < len(matches) else len(body)
        raw_block = body[block_start:block_end].strip()
        proof_index = raw_block.find("*Proof.*")
        statement = raw_block[:proof_index].strip() if proof_index != -1 else raw_block.strip()
        blocks.append(
            {
                "kind": match.group(1),
                "raw_block": normalize_markdown_math(raw_block),
                "statement": normalize_markdown_math(statement),
            }
        )
    return normalize_markdown_math(intro), blocks


def compute_status(lean_path: Path, tracker_status: str) -> tuple[str, bool]:
    """Compute display status from the Lean file and tracker metadata."""
    if lean_path.exists():
        has_sorry = bool(SORRY_RE.search(lean_path.read_text(encoding="utf-8")))
        return ("partial" if has_sorry else "proved"), True
    if tracker_status == "failed":
        return "failed", False
    return "pending", False


def normalize_markdown_math(text: str) -> str:
    """Clean raw source markdown so display math survives Markdown parsing."""
    stripped = text.strip()
    if not stripped:
        return stripped

    normalized = LABEL_LINE_RE.sub("", text)
    normalized = DISPLAY_MATH_RE.sub(
        lambda match: "\n\\[\n" + match.group(1).strip() + "\n\\]\n",
        normalized,
    )
    normalized = re.sub(r"\n{3,}", "\n\n", normalized)
    return normalized.strip()


def make_repo_link(repo_url: str, rel_path: str) -> str:
    """Build a GitHub-compatible blob link when a repo url is available."""
    if not repo_url:
        return ""
    return f"{repo_url.rstrip('/')}/blob/main/{rel_path}"


def badge(status: str) -> str:
    """Render a styled HTML badge for a proof status."""
    return (
        f'<span class="status-badge status-{status}">'
        f"{STATUS_DISPLAY.get(status, status.title())}</span>"
    )


def roadmap_badge(status: str) -> str:
    """Render a styled roadmap badge."""
    css = slugify(status or "planned")
    label = (status or "planned").replace("-", " ").title()
    return f'<span class="roadmap-pill roadmap-{css}">{label}</span>'


def count_statuses(results: list[dict[str, Any]]) -> dict[str, int]:
    """Count results by display status."""
    counts = {status: 0 for status in STATUS_ORDER}
    for result in results:
        counts[result["computed_status"]] += 1
    counts["total"] = sum(counts[status] for status in STATUS_ORDER)
    return counts


def normalize_milestones(milestones: list[Any]) -> list[dict[str, str]]:
    """Normalize roadmap milestones."""
    normalized: list[dict[str, str]] = []
    for milestone in milestones or []:
        if isinstance(milestone, str):
            normalized.append({"title": milestone, "status": "planned"})
            continue
        if isinstance(milestone, dict):
            normalized.append(
                {
                    "title": str(milestone.get("title", "")).strip() or "Untitled milestone",
                    "status": str(milestone.get("status", "planned")).strip() or "planned",
                }
            )
    return normalized


def load_book_metadata(root: Path, book_slug: str) -> dict[str, Any]:
    """Load optional per-book metadata used by the site."""
    metadata_path = root / "docs" / "roadmaps" / book_slug / "book.yml"
    metadata = yaml.safe_load(metadata_path.read_text(encoding="utf-8")) if metadata_path.exists() else {}
    return {
        "book_slug": book_slug,
        "book_title": metadata.get("book_title") or humanize_slug(book_slug),
        "book_description": metadata.get("book_description")
        or f"Formalization status, roadmaps, and Lean proofs for {humanize_slug(book_slug)}.",
        "short_name": metadata.get("short_name") or humanize_slug(book_slug),
    }


def load_chapter_roadmaps(root: Path, book_slug: str) -> dict[int, dict[str, Any]]:
    """Load curated roadmap markdown files for a book."""
    roadmap_dir = root / "docs" / "roadmaps" / book_slug
    roadmaps: dict[int, dict[str, Any]] = {}
    if not roadmap_dir.exists():
        return roadmaps

    for roadmap_path in sorted(roadmap_dir.glob("chapter-*.md")):
        front_matter, body = split_front_matter(roadmap_path.read_text(encoding="utf-8"))
        chapter = int(front_matter["chapter"])
        roadmaps[chapter] = {
            "chapter": chapter,
            "chapter_title": front_matter.get("chapter_title", ""),
            "goal": front_matter.get("goal", ""),
            "priority": str(front_matter.get("priority", "medium")),
            "milestones": normalize_milestones(front_matter.get("milestones") or []),
            "known_blockers": [str(item) for item in (front_matter.get("known_blockers") or [])],
            "suggested_proof_order": [
                str(item) for item in (front_matter.get("suggested_proof_order") or [])
            ],
            "dependencies": [str(item) for item in (front_matter.get("dependencies") or [])],
            "body_markdown": body.strip(),
        }
    return roadmaps


def discover_books(root: Path, selected_books: list[str] | None = None) -> list[str]:
    """Find structured books with section front matter and theorem metadata."""
    papers_dir = root / "papers"
    discovered: list[str] = []
    for paper_dir in sorted(path for path in papers_dir.iterdir() if path.is_dir()):
        if selected_books and paper_dir.name not in selected_books:
            continue
        sections_dir = paper_dir / "sections"
        if not sections_dir.exists():
            continue

        has_structured_section = False
        for section_path in sorted(sections_dir.glob("*.md")):
            text = section_path.read_text(encoding="utf-8")
            if not text.startswith("---\n"):
                continue
            try:
                front_matter, _ = split_front_matter(text)
            except ValueError:
                continue
            if front_matter.get("section_id") and front_matter.get("theorems") is not None:
                has_structured_section = True
                break
        if has_structured_section:
            discovered.append(paper_dir.name)

    if selected_books:
        missing = sorted(set(selected_books) - set(discovered))
        if missing:
            raise FileNotFoundError(
                "Requested books are not structured for docs generation: " + ", ".join(missing)
            )
    return discovered


def extract_lean_snippet(lean_path: Path, theorem_id: str) -> tuple[str, str]:
    """Extract a bounded Lean snippet and best-effort symbol name for a theorem page."""
    if not lean_path.exists():
        return "", ""

    lines = lean_path.read_text(encoding="utf-8").splitlines()
    declarations: list[dict[str, Any]] = []
    for index, line in enumerate(lines):
        match = DECL_RE.match(line.strip())
        if match:
            declarations.append({"line": index, "kind": match.group(1), "name": match.group(2)})

    if not declarations:
        return "\n".join(lines[:40]).strip(), ""

    theorem_parts = theorem_id.lower().split()
    theorem_kind = theorem_parts[0] if theorem_parts else ""
    theorem_number = theorem_parts[-1].replace(".", "_") if len(theorem_parts) > 1 else ""

    def score(declaration: dict[str, Any]) -> int:
        name = declaration["name"].lower()
        total = 0
        if theorem_number and theorem_number in name:
            total += 5
        if theorem_kind and theorem_kind in name:
            total += 3
        if name.startswith("theorem_") or name.startswith("lemma_") or name.startswith("definition_"):
            total += 1
        return total

    best = max(declarations, key=score)
    best_index = declarations.index(best)
    if score(best) == 0:
        best = declarations[0]
        best_index = 0

    start_line = best["line"]
    if start_line < 90:
        start_line = 0
    else:
        for line_index in range(best["line"] - 1, max(best["line"] - 25, -1), -1):
            stripped = lines[line_index].lstrip()
            if stripped.startswith("/-!") or stripped.startswith("/--"):
                start_line = line_index
                break
            if DECL_RE.match(stripped):
                break

    end_index = best_index
    if theorem_number:
        while end_index + 1 < len(declarations):
            next_decl = declarations[end_index + 1]
            if theorem_number in next_decl["name"].lower() and next_decl["line"] - declarations[end_index]["line"] <= 50:
                end_index += 1
                continue
            break

    snippet_end = declarations[end_index + 1]["line"] if end_index + 1 < len(declarations) else len(lines)
    snippet_end = min(snippet_end, start_line + 80)
    snippet_lines = lines[start_line:snippet_end]
    snippet = "\n".join(snippet_lines).strip()
    if snippet_end < len(lines) and end_index + 1 < len(declarations):
        snippet = snippet.rstrip() + "\n\n-- snippet truncated --"
    return snippet, best["name"]


def resolve_chapter_title(
    front_matter: dict[str, Any], roadmap: dict[str, Any] | None, chapter_number: int
) -> str:
    """Resolve a readable chapter title with sensible fallbacks."""
    title = front_matter.get("chapter_title") or (roadmap or {}).get("chapter_title") or ""
    if title:
        return str(title).strip()
    section_title = front_matter.get("section_title") or front_matter.get("subsection_title") or ""
    if chapter_number == 1 and section_title.lower().startswith("introduction"):
        return "Introduction"
    return f"Chapter {chapter_number}"


def default_roadmap(chapter: int, chapter_title: str) -> dict[str, Any]:
    """Provide a fallback roadmap when no curated roadmap exists."""
    return {
        "chapter": chapter,
        "chapter_title": chapter_title,
        "goal": f"Establish a first pass roadmap for {chapter_title}.",
        "priority": "exploratory",
        "milestones": [{"title": "Author roadmap milestones for this chapter", "status": "planned"}],
        "known_blockers": [],
        "suggested_proof_order": [],
        "dependencies": [],
        "body_markdown": "",
    }


def build_book_manifest(root: Path, book_slug: str, repo_url: str = "") -> dict[str, Any]:
    """Build a normalized manifest for one structured book."""
    paper_dir = root / "papers" / book_slug
    sections_dir = paper_dir / "sections"
    index_rows = parse_index_rows(paper_dir / "index.md")
    book_meta = load_book_metadata(root, book_slug)
    roadmaps = load_chapter_roadmaps(root, book_slug)

    chapters: dict[int, dict[str, Any]] = {}
    all_results: list[dict[str, Any]] = []
    result_counter = 0

    for section_file in sorted(sections_dir.glob("*.md")):
        front_matter, body = split_front_matter(section_file.read_text(encoding="utf-8"))
        if not front_matter.get("section_id"):
            continue

        intro, blocks = extract_intro_and_blocks(body)
        section_id = str(front_matter["section_id"])
        chapter_number = int(front_matter.get("chapter") or section_id.split(".", maxsplit=1)[0])
        chapter_roadmap = roadmaps.get(chapter_number)
        chapter_title = resolve_chapter_title(front_matter, chapter_roadmap, chapter_number)
        chapter_slug = f"chapter-{chapter_number}"
        section_title = (
            front_matter.get("subsection_title")
            or front_matter.get("section_title")
            or front_matter.get("title")
            or f"Section {section_id}"
        )
        parent_section_title = front_matter.get("section_title") or section_title
        chapter = chapters.setdefault(
            chapter_number,
            {
                "book_slug": book_slug,
                "book_title": book_meta["book_title"],
                "chapter": chapter_number,
                "chapter_slug": chapter_slug,
                "chapter_title": chapter_title,
                "doc_path": f"generated/books/{book_slug}/chapters/{chapter_slug}.md",
                "sections": [],
                "roadmap": chapter_roadmap or default_roadmap(chapter_number, chapter_title),
            },
        )

        theorem_items = front_matter.get("theorems") or []
        lean_items = {item["id"]: item for item in (front_matter.get("lean_files") or [])}
        section_doc_path = (
            f"generated/books/{book_slug}/sections/"
            f"section-{slugify(section_id)}-{slugify(section_title)}.md"
        )
        section_rel_path = section_file.relative_to(root).as_posix()

        results: list[dict[str, Any]] = []
        for index, theorem in enumerate(theorem_items):
            theorem_id = theorem["id"]
            tracker_row = find_tracker_row(index_rows, theorem_id, section_id)
            lean_meta = lean_items.get(theorem_id, {})
            lean_rel_path = lean_meta.get("path") or tracker_row.get("lean_file", "")
            lean_path = root / lean_rel_path if lean_rel_path else root
            tracker_status = lean_meta.get("status") or tracker_row.get("status", "pending")
            computed_status, file_exists = compute_status(lean_path, tracker_status) if lean_rel_path else (
                "pending",
                False,
            )
            block = blocks[index] if index < len(blocks) else None
            display_name = tracker_row.get("theorem_name") or theorem.get("label") or theorem_id
            lean_snippet, lean_symbol_name = extract_lean_snippet(lean_path, theorem_id) if file_exists else ("", "")

            result_counter += 1
            result = {
                "id": theorem_id,
                "kind": theorem_id.split()[0],
                "display_name": display_name,
                "proof_time": tracker_row.get("time", "—") or "—",
                "section_id": section_id,
                "section_title": section_title,
                "parent_section_title": parent_section_title,
                "chapter": chapter_number,
                "chapter_slug": chapter_slug,
                "chapter_title": chapter_title,
                "book_slug": book_slug,
                "book_title": book_meta["book_title"],
                "book_doc_path": f"generated/books/{book_slug}/index.md",
                "tracker_status": tracker_status,
                "computed_status": computed_status,
                "file_exists": file_exists,
                "proof_file_status": "present" if file_exists else "missing",
                "lean_path": lean_rel_path,
                "section_path": section_rel_path,
                "lean_url": make_repo_link(repo_url, lean_rel_path) if lean_rel_path else "",
                "section_url": make_repo_link(repo_url, section_rel_path),
                "statement_markdown": block["statement"] if block else f"**{theorem_id}**",
                "raw_block_markdown": block["raw_block"] if block else "",
                "doc_path": f"generated/books/{book_slug}/results/{slugify(theorem_id)}.md",
                "result_order": result_counter,
                "lean_snippet": lean_snippet,
                "lean_symbol_name": lean_symbol_name,
                "chapter_roadmap": chapter["roadmap"],
                "blockers": list(chapter["roadmap"].get("known_blockers") or []),
                "dependencies": list(chapter["roadmap"].get("dependencies") or []),
            }
            results.append(result)
            all_results.append(result)

        section_entry = {
            "book_slug": book_slug,
            "book_title": book_meta["book_title"],
            "chapter": chapter_number,
            "chapter_slug": chapter_slug,
            "chapter_title": chapter_title,
            "section_id": section_id,
            "section_title": section_title,
            "parent_section_title": parent_section_title,
            "section_path": section_rel_path,
            "section_url": make_repo_link(repo_url, section_rel_path),
            "intro_markdown": intro,
            "doc_path": section_doc_path,
            "results": results,
        }
        section_entry["counts"] = count_statuses(results)
        chapter["sections"].append(section_entry)

    sorted_chapters = sorted(chapters.values(), key=lambda item: item["chapter"])
    for chapter in sorted_chapters:
        chapter["sections"].sort(key=lambda item: sort_key_for_section_id(item["section_id"]))
        chapter_results = [result for section in chapter["sections"] for result in section["results"]]
        chapter["counts"] = count_statuses(chapter_results)
        chapter["source_doc_path"] = f"generated/books/{book_slug}/source/{chapter['chapter_slug']}.md"

    sorted_results = sorted(
        all_results,
        key=lambda item: (item["chapter"], sort_key_for_section_id(item["section_id"]), item["id"]),
    )
    for index, result in enumerate(sorted_results):
        previous_result = sorted_results[index - 1] if index > 0 else None
        next_result = sorted_results[index + 1] if index + 1 < len(sorted_results) else None
        result["prev_result"] = (
            {"id": previous_result["id"], "doc_path": previous_result["doc_path"]}
            if previous_result
            else None
        )
        result["next_result"] = (
            {"id": next_result["id"], "doc_path": next_result["doc_path"]} if next_result else None
        )

    source_files: list[dict[str, Any]] = []
    seen_paths: set[str] = set()
    for result in sorted_results:
        if not result["lean_path"] or result["lean_path"] in seen_paths:
            continue
        seen_paths.add(result["lean_path"])
        related_results = [item for item in sorted_results if item["lean_path"] == result["lean_path"]]
        source_files.append(
            {
                "lean_path": result["lean_path"],
                "lean_url": result["lean_url"],
                "chapter": result["chapter"],
                "chapter_title": result["chapter_title"],
                "result_ids": [item["id"] for item in related_results],
                "status": "proved"
                if all(item["computed_status"] == "proved" for item in related_results)
                else ("partial" if any(item["file_exists"] for item in related_results) else "pending"),
            }
        )

    manifest = {
        "book_slug": book_slug,
        "book_title": book_meta["book_title"],
        "book_description": book_meta["book_description"],
        "book_doc_path": f"generated/books/{book_slug}/index.md",
        "chapter_count": len(sorted_chapters),
        "chapters": sorted_chapters,
        "results": sorted_results,
        "counts": count_statuses(sorted_results),
        "source_files": source_files,
    }
    return manifest


def build_site_manifest(
    root: Path, selected_books: list[str] | None = None, repo_url: str = ""
) -> dict[str, Any]:
    """Build a normalized manifest for all supported books."""
    books = [build_book_manifest(root, book_slug, repo_url=repo_url) for book_slug in discover_books(root, selected_books)]
    all_results = [result for book in books for result in book["results"]]
    all_chapters = [chapter for book in books for chapter in book["chapters"]]

    featured_results = [
        result for result in all_results if result["computed_status"] in {"proved", "partial"}
    ][:10]

    roadmap_chapters = sorted(
        all_chapters,
        key=lambda chapter: (
            ROADMAP_PRIORITY_ORDER.get(chapter["roadmap"].get("priority", "medium"), 99),
            -chapter["counts"]["pending"],
            chapter["book_title"],
            chapter["chapter"],
        ),
    )

    return {
        "book_count": len(books),
        "books": books,
        "results": all_results,
        "counts": count_statuses(all_results),
        "featured_results": featured_results,
        "roadmap_chapters": roadmap_chapters,
    }


def write_text(path: Path, content: str) -> None:
    """Write a UTF-8 text file, creating parent directories first."""
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content.rstrip() + "\n", encoding="utf-8")


def render_metrics(counts: dict[str, int]) -> str:
    """Render high-level status metrics."""
    return "\n".join(
        [
            '<div class="metric-grid">',
            f'<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">{counts["proved"]}</span></div>',
            f'<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">{counts["partial"]}</span></div>',
            f'<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">{counts["pending"]}</span></div>',
            f'<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">{counts["failed"]}</span></div>',
            f'<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">{counts["total"]}</span></div>',
            "</div>",
        ]
    )


def render_book_switcher(
    books: list[dict[str, Any]],
    current_slug: str | None = None,
    book_root: str = "generated/books",
) -> str:
    """Render a compact cross-book navigation strip."""
    links = []
    normalized_root = book_root.rstrip("/")
    for book in books:
        extra_class = " active" if book["book_slug"] == current_slug else ""
        links.append(
            f'<a class="chip-link{extra_class}" href="{normalized_root}/{book["book_slug"]}/index.md">'
            f"{book['book_title']}</a>"
        )
    return '<div class="chip-row">' + "".join(links) + "</div>"


def render_home(manifest: dict[str, Any]) -> str:
    """Render the homepage."""
    primary_book = next(
        (book for book in manifest["books"] if book["book_slug"] == PRIMARY_BOOK_SLUG),
        manifest["books"][0] if manifest["books"] else None,
    )
    if primary_book is None:
        return "# Formalization Project\n\nNo structured formalization content is indexed yet."

    lines = [
        f"# {primary_book['book_title']}",
        "",
        "Formalization progress by chapter.",
        "",
        "## Snapshot",
        "",
        render_metrics(primary_book["counts"]),
        "",
        "## Chapter Progress",
        "",
        "| Chapter | Title | Proved | Partial | Pending | Failed | Total |",
        "|---------|-------|------:|-------:|-------:|------:|------:|",
    ]
    for chapter in primary_book["chapters"]:
        counts = chapter["counts"]
        lines.append(
            f"| [Chapter {chapter['chapter']}]({chapter['doc_path']}) | {chapter['chapter_title']} "
            f"| {counts['proved']} | {counts['partial']} | {counts['pending']} | {counts['failed']} | {counts['total']} |"
        )

    return "\n".join(lines)


def render_books_index(manifest: dict[str, Any]) -> str:
    """Render the book index page."""
    lines = [
        "# Book Library",
        "",
        "Start from a formalization project, then drill into chapter roadmaps, sections, and Lean-backed theorem pages.",
        "",
        render_book_switcher(manifest["books"]),
        "",
        "| Book | Chapters | Proved | Partial | Pending | Total |",
        "|------|---------:|------:|-------:|-------:|------:|",
    ]
    for book in manifest["books"]:
        counts = book["counts"]
        lines.append(
            f"| [{book['book_title']}]({book['book_doc_path']}) | {book['chapter_count']} | "
            f"{counts['proved']} | {counts['partial']} | {counts['pending']} | {counts['total']} |"
        )
    return "\n".join(lines)


def render_progress(manifest: dict[str, Any]) -> str:
    """Render a global cross-book progress dashboard."""
    lines = [
        "# Global Progress",
        "",
        "This dashboard tracks structured formalization projects discovered under `papers/`.",
        "",
        "| Book | Chapter | Title | Proved | Partial | Pending | Failed | Total |",
        "|------|--------:|-------|------:|-------:|-------:|------:|------:|",
    ]
    for book in manifest["books"]:
        for chapter in book["chapters"]:
            counts = chapter["counts"]
            lines.append(
                f"| [{book['book_title']}]({book['book_doc_path']}) | [{chapter['chapter']}]({chapter['doc_path']}) "
                f"| {chapter['chapter_title']} | {counts['proved']} | {counts['partial']} "
                f"| {counts['pending']} | {counts['failed']} | {counts['total']} |"
            )
    return "\n".join(lines)


def render_roadmap(chapter: dict[str, Any]) -> str:
    """Render roadmap details for a chapter page."""
    roadmap = chapter["roadmap"]
    lines = [
        '<div class="roadmap-panel">',
        "## Chapter Roadmap",
        "",
        f"{roadmap_badge(roadmap['priority'])} {roadmap['goal']}",
        "",
    ]
    if roadmap["body_markdown"]:
        lines.extend([roadmap["body_markdown"], ""])
    if roadmap["milestones"]:
        lines.append("### Milestones")
        lines.append("")
        for milestone in roadmap["milestones"]:
            lines.append(f"- {roadmap_badge(milestone['status'])} {milestone['title']}")
        lines.append("")
    if roadmap["suggested_proof_order"]:
        lines.append("### Suggested Proof Order")
        lines.append("")
        for item in roadmap["suggested_proof_order"]:
            lines.append(f"- `{item}`")
        lines.append("")
    if roadmap["known_blockers"]:
        lines.append("### Known Blockers")
        lines.append("")
        for blocker in roadmap["known_blockers"]:
            lines.append(f"- {blocker}")
        lines.append("")
    if roadmap["dependencies"]:
        lines.append("### Dependencies")
        lines.append("")
        for dependency in roadmap["dependencies"]:
            lines.append(f"- {dependency}")
        lines.append("")
    lines.append("</div>")
    return "\n".join(lines)


def render_book_page(book: dict[str, Any], all_books: list[dict[str, Any]]) -> str:
    """Render a book landing page."""
    lines = [
        f"# {book['book_title']}",
        "",
        book["book_description"],
        "",
        render_book_switcher(all_books, current_slug=book["book_slug"], book_root=".."),
        "",
        "## Snapshot",
        "",
        render_metrics(book["counts"]),
        "",
        (
            f"## [Browse Lean Source Inventory](source/{book['chapters'][0]['chapter_slug']}.md)"
            if book["chapters"]
            else "## Lean Source Inventory"
        ),
        "",
        "## Chapter Roadmaps",
        "",
    ]
    for chapter in book["chapters"]:
        roadmap = chapter["roadmap"]
        lines.extend(
            [
                f"### [Chapter {chapter['chapter']} — {chapter['chapter_title']}](chapters/{chapter['chapter_slug']}.md)",
                "",
                f"{roadmap_badge(roadmap['priority'])} {roadmap['goal']}",
                "",
                f"- Results: {chapter['counts']['total']}",
                f"- Completed: {chapter['counts']['proved']} proved, {chapter['counts']['partial']} partial",
                f"- Open work: {chapter['counts']['pending']} pending, {chapter['counts']['failed']} failed",
                "",
            ]
        )
    if book["source_files"]:
        lines.extend(["## Lean Files", "", "| Lean file | Chapter | Results | Status |", "|-----------|---------|---------|--------|"])
        for source_file in book["source_files"][:12]:
            lean_cell = (
                f"[{source_file['lean_path']}]({source_file['lean_url']})"
                if source_file["lean_url"]
                else f"`{source_file['lean_path']}`"
            )
            lines.append(
                f"| {lean_cell} | {source_file['chapter']} | {', '.join(source_file['result_ids'])} "
                f"| {badge(source_file['status'])} |"
            )
    return "\n".join(lines)


def render_filter_controls() -> str:
    """Render status filter controls used on chapter and section pages."""
    return (
        '<div class="filter-row" data-filter-root>'
        '<button class="filter-chip active" data-filter-status="all" type="button">All</button>'
        '<button class="filter-chip" data-filter-status="proved" type="button">Proved</button>'
        '<button class="filter-chip" data-filter-status="partial" type="button">Partial</button>'
        '<button class="filter-chip" data-filter-status="pending" type="button">Pending</button>'
        '<button class="filter-chip" data-filter-status="failed" type="button">Failed</button>'
        "</div>"
    )


def render_chapter_page(chapter: dict[str, Any], all_books: list[dict[str, Any]]) -> str:
    """Render a content-first chapter page."""
    lines = [
        f"# Chapter {chapter['chapter']} — {chapter['chapter_title']}",
        "",
    ]
    for section in chapter["sections"]:
        if not section["results"]:
            continue
        lines.extend(
            [
                f"## Section {section['section_id']} — {section['section_title']}",
                "",
            ]
        )
        for result in section["results"]:
            title = result["id"]
            if result["display_name"] and result["display_name"] != result["id"]:
                title = f"{result['id']} — {result['display_name']}"
            lines.extend(
                [
                    f"### [{title}](../results/{Path(result['doc_path']).name})",
                    "",
                    result["statement_markdown"],
                    "",
                ]
            )
    return "\n".join(lines)


def render_section_page(section: dict[str, Any], all_books: list[dict[str, Any]]) -> str:
    """Render a section page."""
    lines = [
        f"# {section['book_title']} / Section {section['section_id']} — {section['section_title']}",
        "",
        f"[Back to Chapter {section['chapter']}](../chapters/{section['chapter_slug']}.md)",
        "",
        render_book_switcher(all_books, current_slug=section["book_slug"], book_root="../.."),
        "",
        render_metrics(section["counts"]),
        "",
    ]
    if section["intro_markdown"]:
        lines.extend(["## Source Context", "", section["intro_markdown"], ""])
    lines.extend(["## Results", "", render_filter_controls(), "", "| Status | Result | Name | Lean |", "|--------|--------|------|------|"])
    for result in section["results"]:
        lean_cell = (
            f"[Lean]({result['lean_url']})"
            if result["lean_url"]
            else (f"`{result['lean_path']}`" if result["lean_path"] else "—")
        )
        lines.append(
            f'| <span data-status="{result["computed_status"]}">{badge(result["computed_status"])}</span> '
            f'| [{result["id"]}](../results/{Path(result["doc_path"]).name}) | {result["display_name"]} | {lean_cell} |'
        )
    return "\n".join(lines)


def render_result_page(result: dict[str, Any], all_books: list[dict[str, Any]]) -> str:
    """Render an individual theorem/result page."""
    roadmap = result["chapter_roadmap"]
    section_path = (
        f"../sections/section-{slugify(result['section_id'])}-{slugify(result['section_title'])}.md"
    )
    chapter_path = f"../chapters/{result['chapter_slug']}.md"
    lines = [
        f"# {result['id']}",
        "",
        f"[{result['book_title']}](../index.md) / "
        f"[Chapter {result['chapter']}]({chapter_path}) / "
        f"[Section {result['section_id']}]({section_path})",
        "",
        render_book_switcher(all_books, current_slug=result["book_slug"], book_root="../.."),
        "",
        f"**Status:** {badge(result['computed_status'])}",
        "",
        f"**Roadmap context:** {roadmap_badge(roadmap['priority'])} {roadmap['goal']}",
        "",
        "## Informal Statement",
        "",
        result["statement_markdown"],
        "",
    ]

    if result["lean_snippet"]:
        lines.extend(
            [
                "## Lean Formalization",
                "",
                f"Symbol: `{result['lean_symbol_name']}`" if result["lean_symbol_name"] else "Symbol: unavailable",
                "",
                "```lean",
                result["lean_snippet"],
                "```",
                "",
            ]
        )
    else:
        lines.extend(
            [
                "## Lean Formalization",
                "",
                "No Lean snippet is available yet because the proof file does not exist.",
                "",
            ]
        )

    lines.extend(
        [
            "## Metadata",
            "",
            "| Field | Value |",
            "|-------|-------|",
            f"| Display name | {result['display_name']} |",
            f"| Proof file status | `{result['proof_file_status']}` |",
            f"| Tracker status | `{result['tracker_status']}` |",
            f"| Computed status | `{result['computed_status']}` |",
            f"| Proof time | {result['proof_time']} |",
        ]
    )
    if result["lean_url"]:
        lines.append(f"| Lean file | [{result['lean_path']}]({result['lean_url']}) |")
    elif result["lean_path"]:
        lines.append(f"| Lean file | `{result['lean_path']}` |")
    else:
        lines.append("| Lean file | — |")

    if result["section_url"]:
        lines.append(f"| Source section | [{result['section_path']}]({result['section_url']}) |")
    else:
        lines.append(f"| Source section | `{result['section_path']}` |")

    if result["dependencies"]:
        lines.extend(["", "## Dependencies", ""])
        for dependency in result["dependencies"]:
            lines.append(f"- {dependency}")

    if result["blockers"]:
        lines.extend(["", "## Chapter Blockers", ""])
        for blocker in result["blockers"]:
            lines.append(f"- {blocker}")

    lines.extend(["", "## Nearby Results", ""])
    if result["prev_result"]:
        lines.append(
            f"- Previous: [{result['prev_result']['id']}](./{Path(result['prev_result']['doc_path']).name})"
        )
    if result["next_result"]:
        lines.append(
            f"- Next: [{result['next_result']['id']}](./{Path(result['next_result']['doc_path']).name})"
        )
    if not result["prev_result"] and not result["next_result"]:
        lines.append("- This is the only indexed result in its sequence.")
    return "\n".join(lines)


def render_source_page(chapter: dict[str, Any]) -> str:
    """Render a lightweight source inventory page for one chapter."""
    source_rows: list[dict[str, Any]] = []
    seen_paths: set[str] = set()
    for section in chapter["sections"]:
        for result in section["results"]:
            if not result["lean_path"] or result["lean_path"] in seen_paths:
                continue
            seen_paths.add(result["lean_path"])
            source_rows.append(
                {
                    "lean_path": result["lean_path"],
                    "lean_url": result["lean_url"],
                    "result_id": result["id"],
                    "status": result["computed_status"],
                }
            )

    lines = [
        f"# {chapter['book_title']} / {chapter['chapter_title']} Source Inventory",
        "",
        f"[Back to Chapter {chapter['chapter']}](../chapters/{chapter['chapter_slug']}.md)",
        "",
    ]
    if not source_rows:
        lines.append("No Lean files are indexed for this chapter yet.")
        return "\n".join(lines)

    lines.extend(["| Lean file | Result | Status |", "|-----------|--------|--------|"])
    for row in source_rows:
        lean_cell = f"[{row['lean_path']}]({row['lean_url']})" if row["lean_url"] else f"`{row['lean_path']}`"
        lines.append(f"| {lean_cell} | {row['result_id']} | {badge(row['status'])} |")
    return "\n".join(lines)


def render_contributing_page() -> str:
    """Render the hand-authored contribution and status guide."""
    return "\n".join(
        [
            "# Contributing and Status Rules",
            "",
            "The docs site is generated from repository content under `papers/`, `proofs/`, and `docs/roadmaps/`.",
            "",
            "## Updating the site locally",
            "",
            "```bash",
            "python3 scripts/generate_bubeck_docs.py --out site_docs/generated",
            "mkdocs build",
            "```",
            "",
            "## Roadmap authoring",
            "",
            "- Add `docs/roadmaps/<book>/book.yml` for book metadata.",
            "- Add `docs/roadmaps/<book>/chapter-<n>.md` with YAML front matter and roadmap notes.",
            "- Required chapter roadmap keys: `chapter`, `goal`, `priority`, `milestones`, `known_blockers`, `suggested_proof_order`.",
            "",
            "## Status precedence",
            "",
            "- `proved`: Lean file exists and contains no `sorry`.",
            "- `partial`: Lean file exists and still contains at least one `sorry`.",
            "- `failed`: Lean file is missing and the tracker explicitly marks the result as failed.",
            "- `pending`: default state for everything else.",
            "",
            "## Source-of-truth conventions",
            "",
            "- Section ordering and theorem statements come from `papers/<book>/sections/*.md`.",
            "- Lean file paths come from section front matter and the theorem index.",
            "- Roadmap intent comes from `docs/roadmaps/<book>/chapter-*.md`.",
        ]
    )


def write_docs(root: Path, manifest: dict[str, Any], out_dir: Path) -> None:
    """Write generated markdown pages and JSON manifests."""
    if out_dir.exists():
        shutil.rmtree(out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    write_text(root / "site_docs" / "index.md", render_home(manifest))
    write_text(root / "site_docs" / "books.md", render_books_index(manifest))
    write_text(root / "site_docs" / "progress.md", render_progress(manifest))
    write_text(root / "site_docs" / "contributing.md", render_contributing_page())
    write_text(out_dir / "site_manifest.json", json.dumps(manifest, indent=2, ensure_ascii=False))

    for book in manifest["books"]:
        write_text(root / "site_docs" / book["book_doc_path"], render_book_page(book, manifest["books"]))
        write_text(
            out_dir / "manifests" / f"{book['book_slug']}.json",
            json.dumps(book, indent=2, ensure_ascii=False),
        )
        for chapter in book["chapters"]:
            write_text(root / "site_docs" / chapter["doc_path"], render_chapter_page(chapter, manifest["books"]))
            write_text(root / "site_docs" / chapter["source_doc_path"], render_source_page(chapter))
            for section in chapter["sections"]:
                write_text(root / "site_docs" / section["doc_path"], render_section_page(section, manifest["books"]))
                for result in section["results"]:
                    write_text(root / "site_docs" / result["doc_path"], render_result_page(result, manifest["books"]))


def generate_docs(
    root: Path, selected_books: list[str] | None, out_dir: Path, repo_url: str = ""
) -> dict[str, Any]:
    """Build the manifest and write the generated docs files."""
    manifest = build_site_manifest(root=root, selected_books=selected_books, repo_url=repo_url)
    write_docs(root=root, manifest=manifest, out_dir=out_dir)
    return manifest


def parse_selected_books(raw_value: str | None) -> list[str] | None:
    """Parse the legacy `--book` flag as a filter, not a single hardcoded mode."""
    if not raw_value:
        return None
    books = [item.strip() for item in raw_value.split(",") if item.strip()]
    return books or None


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate MkDocs pages for the formalization portal.")
    parser.add_argument(
        "--book",
        default="",
        help="Optional comma-separated book filter under papers/; omitted means generate all structured books.",
    )
    parser.add_argument(
        "--out",
        default="site_docs/generated",
        help="Directory for generated docs artifacts, relative to the repo root.",
    )
    parser.add_argument(
        "--repo-url",
        default="",
        help="Optional repository base URL for source links, e.g. https://github.com/org/repo.",
    )
    args = parser.parse_args()

    root = Path(__file__).resolve().parents[1]
    out_dir = Path(args.out)
    if not out_dir.is_absolute():
        out_dir = root / out_dir

    generate_docs(
        root=root,
        selected_books=parse_selected_books(args.book),
        out_dir=out_dir,
        repo_url=args.repo_url,
    )


if __name__ == "__main__":
    main()
