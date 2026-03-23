#!/usr/bin/env python3
"""
lookup_theorem.py — find theorem context from project index files.

Usage:
    python3 scripts/lookup_theorem.py "Proposition 1.6"
    python3 scripts/lookup_theorem.py "Theorem 2.1" --book Bubeck_convex_optimization
"""

import argparse
import json
import os
import re
import sys
from pathlib import Path


def find_project_root() -> Path:
    """Walk up from script location to find the project root (contains lakefile.lean)."""
    here = Path(__file__).resolve().parent
    for candidate in [here.parent, here]:
        if (candidate / "lakefile.lean").exists() or (candidate / "papers").exists():
            return candidate
    return here.parent


def parse_index_rows(index_path: Path):
    """
    Parse index.md table rows.
    Returns list of dicts with keys: theorem_id, theorem_name, section_id,
    section_title, lean_file, status, book.
    """
    rows = []
    book = index_path.parent.name
    with open(index_path, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line.startswith("|"):
                continue
            parts = [p.strip() for p in line.strip("|").split("|")]
            if len(parts) < 6:
                continue
            if parts[0] in ("ID", "----", "---"):
                continue
            if parts[0].startswith("-"):
                continue
            rows.append(
                {
                    "theorem_id": parts[0],
                    "theorem_name": parts[1],
                    "section_id": parts[2],
                    "section_title": parts[3],
                    "lean_file": parts[4],
                    "status": parts[5],
                    "book": book,
                }
            )
    return rows


def find_section_file(papers_dir: Path, book: str, section_id: str, theorem_id: str) -> Path | None:
    """Find section file whose YAML front-matter section_id matches, or whose theorems list contains theorem_id."""
    sections_dir = papers_dir / book / "sections"
    if not sections_dir.exists():
        return None
    for section_file in sorted(sections_dir.glob("*.md")):
        content = section_file.read_text(encoding="utf-8")
        if not content.startswith("---"):
            continue
        end = content.find("\n---\n", 4)
        if end == -1:
            continue
        yaml_block = content[4:end]
        # Check section_id match
        sid_match = re.search(r"section_id:\s*['\"]?([^'\"\n]+)['\"]?", yaml_block)
        if sid_match and sid_match.group(1).strip() == section_id.strip():
            return section_file
        # Check theorems list contains the theorem_id
        if re.search(
            r"id:\s*['\"]?" + re.escape(theorem_id) + r"['\"]?",
            yaml_block,
        ):
            return section_file
    return None


def extract_theorem_statement(content: str, theorem_id: str) -> tuple[str, str]:
    """
    Extract (theorem_statement, proof_hint) from section body.

    Looks for a **Proposition** / **Theorem** / **Lemma** / **Corollary** /
    **Definition** heading near the theorem label, then grabs text until
    the *Proof.* line (exclusive).  Returns empty strings if not found.
    """
    # Strip YAML front-matter
    if content.startswith("---"):
        end = content.find("\n---\n", 4)
        if end != -1:
            content = content[end + 5 :]

    # Determine type keyword from ID (e.g. "Proposition 1.6" → "Proposition")
    id_type = theorem_id.split()[0] if theorem_id else ""

    # Split into blocks separated by blank lines
    # Find **Proposition** / **Theorem** / etc. headings
    heading_pattern = re.compile(
        r"\*\*(Proposition|Theorem|Lemma|Corollary|Definition)\*\*",
        re.IGNORECASE,
    )

    # Find all heading positions
    headings = list(heading_pattern.finditer(content))
    if not headings:
        return "", ""

    # Try to find the right heading by matching the type word if we know it
    target_heading = None
    if id_type:
        type_lower = id_type.lower()
        for h in headings:
            if h.group(1).lower() == type_lower:
                # Check if the theorem_id number appears nearby (within 300 chars)
                id_number = theorem_id.split()[-1] if len(theorem_id.split()) > 1 else ""
                window = content[h.start() : h.start() + 300]
                if id_number and id_number in window:
                    target_heading = h
                    break
        if target_heading is None:
            # Fallback: pick first matching type
            for h in headings:
                if h.group(1).lower() == type_lower:
                    target_heading = h
                    break
    if target_heading is None:
        target_heading = headings[0]

    # Extract from heading to *Proof.* or next heading
    start = target_heading.start()
    proof_match = re.search(r"\*Proof\.\*", content[start:])
    if proof_match:
        statement_end = start + proof_match.start()
        statement = content[start:statement_end].strip()
        # Extract proof hint: first paragraph after *Proof.*
        after_proof = content[start + proof_match.end() :]
        hint_lines = []
        for line in after_proof.splitlines():
            stripped = line.strip()
            if not stripped:
                if hint_lines:
                    break
                continue
            # Stop at next heading or next **Proof**
            if stripped.startswith("**") or stripped.startswith("#"):
                break
            hint_lines.append(stripped)
        proof_hint = " ".join(hint_lines)
    else:
        # No proof marker — take until next heading or end
        next_heading_pos = None
        for h in headings:
            if h.start() > start:
                next_heading_pos = h.start()
                break
        if next_heading_pos:
            statement = content[start:next_heading_pos].strip()
        else:
            statement = content[start:].strip()
        proof_hint = ""

    return statement, proof_hint


def find_example_proof(papers_dir: Path, root: Path, book: str, rows: list) -> str:
    """
    Find an example proved lean file in the same book.
    Prefer most recently modified. Fallback to any .lean in proofs/<book>/.
    """
    proved = [r for r in rows if r["status"] == "proved" and r["book"] == book]
    candidates = []
    for r in proved:
        lf = root / r["lean_file"]
        if lf.exists():
            candidates.append((lf.stat().st_mtime, str(r["lean_file"])))
    if candidates:
        candidates.sort(reverse=True)
        return candidates[0][1]
    # Fallback: any .lean in proofs/<book>/
    proofs_dir = root / "proofs" / book
    if proofs_dir.exists():
        leans = list(proofs_dir.glob("*.lean"))
        if leans:
            leans.sort(key=lambda p: p.stat().st_mtime, reverse=True)
            return str(leans[0].relative_to(root))
    return ""


def lookup(theorem_id: str, book_filter: str | None = None) -> dict:
    root = find_project_root()
    papers_dir = root / "papers"

    # Find all index.md files
    if book_filter:
        index_files = [papers_dir / book_filter / "index.md"]
    else:
        index_files = list(papers_dir.glob("*/index.md"))

    if not index_files:
        raise FileNotFoundError(f"No index.md files found under {papers_dir}")

    # Search all index files
    target_id_lower = theorem_id.strip().lower()
    matched_row = None
    all_rows_by_book: dict[str, list] = {}

    for idx_file in index_files:
        if not idx_file.exists():
            continue
        rows = parse_index_rows(idx_file)
        book = idx_file.parent.name
        all_rows_by_book[book] = rows
        for row in rows:
            if row["theorem_id"].strip().lower() == target_id_lower:
                matched_row = row
                break
        if matched_row:
            break

    if matched_row is None:
        raise KeyError(f"Theorem '{theorem_id}' not found in any index.md")

    book = matched_row["book"]
    section_id = matched_row["section_id"]

    # Load all rows for the book (may already be loaded)
    if book not in all_rows_by_book:
        idx_file = papers_dir / book / "index.md"
        all_rows_by_book[book] = parse_index_rows(idx_file) if idx_file.exists() else []

    # Find section file
    section_file = find_section_file(papers_dir, book, section_id, theorem_id)

    # Extract statement + hint
    theorem_statement = ""
    proof_hint = ""
    section_title_from_yaml = matched_row["section_title"]

    if section_file:
        content = section_file.read_text(encoding="utf-8")
        # Try to get section_title from YAML
        if content.startswith("---"):
            end = content.find("\n---\n", 4)
            if end != -1:
                yaml_block = content[4:end]
                st_match = re.search(r"section_title:\s*(.+)", yaml_block)
                if st_match:
                    section_title_from_yaml = st_match.group(1).strip()
        theorem_statement, proof_hint = extract_theorem_statement(content, theorem_id)

    # Find example proof
    example_proof = find_example_proof(papers_dir, root, book, all_rows_by_book[book])

    return {
        "theorem_id": matched_row["theorem_id"],
        "theorem_name": matched_row["theorem_name"],
        "book": book,
        "section_id": section_id,
        "section_title": section_title_from_yaml,
        "section_file": str(section_file.relative_to(root)) if section_file else "",
        "lean_file": matched_row["lean_file"],
        "theorem_statement": theorem_statement,
        "proof_hint": proof_hint,
        "example_proof_file": example_proof,
        "status": matched_row["status"],
    }


def main():
    parser = argparse.ArgumentParser(
        description="Look up a theorem by ID and emit JSON context for autoprove."
    )
    parser.add_argument("theorem_id", help='Theorem ID, e.g. "Proposition 1.6"')
    parser.add_argument(
        "--book",
        default=None,
        help="Filter by book name (e.g. Bubeck_convex_optimization)",
    )
    args = parser.parse_args()

    try:
        result = lookup(args.theorem_id, args.book)
        print(json.dumps(result, indent=2, ensure_ascii=False))
    except (FileNotFoundError, KeyError) as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
