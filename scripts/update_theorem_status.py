#!/usr/bin/env python3
"""
update_theorem_status.py — set a theorem's status in index.md and section YAML.

Usage:
    python3 scripts/update_theorem_status.py "Proposition 1.6" proved
    python3 scripts/update_theorem_status.py "Theorem 2.1" partial --book Bubeck_convex_optimization
"""

import argparse
import re
import sys
from pathlib import Path

# Reuse lookup logic from sibling script
sys.path.insert(0, str(Path(__file__).parent))
from lookup_theorem import find_project_root, parse_index_rows, find_section_file


VALID_STATUSES = ("proved", "partial", "failed", "pending")


def update_index_md(index_path: Path, theorem_id: str, new_status: str) -> bool:
    """
    Replace the status cell in the matching row of index.md.
    Returns True if a change was made.
    """
    content = index_path.read_text(encoding="utf-8")
    lines = content.splitlines(keepends=True)
    target_id_lower = theorem_id.strip().lower()
    changed = False

    for i, line in enumerate(lines):
        if not line.startswith("|"):
            continue
        parts = [p.strip() for p in line.strip("|").split("|")]
        if len(parts) < 6:
            continue
        if parts[0].strip().lower() != target_id_lower:
            continue
        # Found the row — replace the last non-empty cell (status)
        # Rebuild line with updated status
        # Status is in parts[5]; reconstruct carefully
        old_status = parts[5]
        if old_status == new_status:
            return False  # already correct, idempotent
        new_line = line.replace(f"| {old_status} |", f"| {new_status} |", 1)
        if new_line == line:
            # Try without spaces
            new_line = re.sub(
                r"\|\s*" + re.escape(old_status) + r"\s*\|",
                f"| {new_status} |",
                line,
                count=1,
            )
        lines[i] = new_line
        changed = True
        break

    if changed:
        index_path.write_text("".join(lines), encoding="utf-8")
    return changed


def update_section_yaml(section_file: Path, theorem_id: str, new_status: str) -> bool:
    """
    Update lean_files[i].status in section YAML front-matter where id matches theorem_id.
    Rewrites the file preserving the body. Returns True if changed.
    """
    content = section_file.read_text(encoding="utf-8")
    if not content.startswith("---"):
        return False
    end = content.find("\n---\n", 4)
    if end == -1:
        return False

    yaml_block = content[4:end]
    body = content[end + 5 :]  # everything after closing ---

    target_id_lower = theorem_id.strip().lower()

    # Find the lean_files block and update the matching entry
    # We parse/edit line-by-line to avoid needing PyYAML round-trip (which can mangle formatting)
    yaml_lines = yaml_block.splitlines(keepends=True)
    changed = False
    in_lean_files = False
    current_id = None

    for i, line in enumerate(yaml_lines):
        stripped = line.strip()
        if stripped == "lean_files:":
            in_lean_files = True
            continue
        if in_lean_files:
            # Detect end of lean_files block (non-indented key or empty)
            if stripped and not stripped.startswith("-") and not stripped.startswith("id:") \
                    and not stripped.startswith("path:") and not stripped.startswith("status:") \
                    and not line.startswith(" ") and not line.startswith("\t"):
                in_lean_files = False
                current_id = None
                continue
            # Parse id line
            id_match = re.match(r"\s*-?\s*id:\s*['\"]?(.+?)['\"]?\s*$", line)
            if id_match:
                current_id = id_match.group(1).strip()
                continue
            # Parse status line
            status_match = re.match(r"(\s+)(status:\s*)(\S+)\s*$", line)
            if status_match and current_id is not None:
                if current_id.lower() == target_id_lower:
                    old_status = status_match.group(3)
                    if old_status != new_status:
                        yaml_lines[i] = f"{status_match.group(1)}{status_match.group(2)}{new_status}\n"
                        changed = True

    if not changed:
        return False

    new_yaml = "".join(yaml_lines)
    # yaml_block does not include the \n immediately before the closing ---
    new_content = "---\n" + new_yaml + "\n---\n" + body
    section_file.write_text(new_content, encoding="utf-8")
    return True


def ensure_time_column(index_path: Path) -> None:
    """Add a Time column to index.md if it is not already present. Idempotent."""
    content = index_path.read_text(encoding="utf-8")
    lines = content.splitlines(keepends=True)

    # Find header, separator, and data rows
    header_idx = None
    sep_idx = None
    for i, line in enumerate(lines):
        if not line.startswith("|"):
            continue
        if header_idx is None:
            header_idx = i
        elif sep_idx is None:
            sep_idx = i
            break

    if header_idx is None or sep_idx is None:
        return  # no table found

    header_line = lines[header_idx]
    # Check if Time column already present
    if "| Time |" in header_line or "| Time" in header_line:
        return  # already has the column

    def append_col(line: str, value: str) -> str:
        stripped = line.rstrip("\n")
        if stripped.endswith("|"):
            return stripped + f" {value} |\n"
        return stripped + f" | {value} |\n"

    lines[header_idx] = append_col(header_line, "Time")
    lines[sep_idx] = append_col(lines[sep_idx], "------")

    for i in range(sep_idx + 1, len(lines)):
        if lines[i].startswith("|"):
            lines[i] = append_col(lines[i], "—")

    index_path.write_text("".join(lines), encoding="utf-8")


def update_index_time(index_path: Path, theorem_id: str, time_str: str) -> bool:
    """Replace the Time cell (column index 6, 0-based) for the matching row."""
    content = index_path.read_text(encoding="utf-8")
    lines = content.splitlines(keepends=True)
    target_id_lower = theorem_id.strip().lower()
    changed = False

    for i, line in enumerate(lines):
        if not line.startswith("|"):
            continue
        parts = [p.strip() for p in line.strip("|").split("|")]
        if len(parts) < 7:
            continue
        if parts[0].strip().lower() != target_id_lower:
            continue
        old_time = parts[6]
        new_line = line.replace(f"| {old_time} |", f"| {time_str} |", 1)
        if new_line == line:
            new_line = re.sub(
                r"\|\s*" + re.escape(old_time) + r"\s*\|",
                f"| {time_str} |",
                line,
                count=1,
            )
        lines[i] = new_line
        changed = True
        break

    if changed:
        index_path.write_text("".join(lines), encoding="utf-8")
    return changed


def main():
    parser = argparse.ArgumentParser(
        description="Update theorem status in index.md and section YAML."
    )
    parser.add_argument("theorem_id", help='Theorem ID, e.g. "Proposition 1.6"')
    parser.add_argument(
        "status",
        choices=VALID_STATUSES,
        help="New status value",
    )
    parser.add_argument(
        "--book",
        default=None,
        help="Filter by book name",
    )
    parser.add_argument(
        "--time",
        default=None,
        help='Elapsed proof time, e.g. "3m 12s" (written to Time column, proved only)',
    )
    args = parser.parse_args()

    root = find_project_root()
    papers_dir = root / "papers"

    # Find matching row
    if args.book:
        index_files = [papers_dir / args.book / "index.md"]
    else:
        index_files = list(papers_dir.glob("*/index.md"))

    target_id_lower = args.theorem_id.strip().lower()
    matched_row = None

    for idx_file in index_files:
        if not idx_file.exists():
            continue
        rows = parse_index_rows(idx_file)
        for row in rows:
            if row["theorem_id"].strip().lower() == target_id_lower:
                matched_row = row
                matched_index = idx_file
                break
        if matched_row:
            break

    if matched_row is None:
        print(f"Error: Theorem '{args.theorem_id}' not found in any index.md", file=sys.stderr)
        sys.exit(1)

    book = matched_row["book"]
    section_id = matched_row["section_id"]

    # Ensure Time column exists
    ensure_time_column(matched_index)

    # Update index.md
    index_changed = update_index_md(matched_index, args.theorem_id, args.status)

    # Find and update section file
    section_file = find_section_file(papers_dir, book, section_id, args.theorem_id)
    section_changed = False
    if section_file:
        section_changed = update_section_yaml(section_file, args.theorem_id, args.status)

    # Update Time column if --time provided
    time_changed = False
    if args.time:
        time_changed = update_index_time(matched_index, args.theorem_id, args.time)

    if index_changed or section_changed or time_changed:
        parts = []
        if index_changed or time_changed:
            parts.append(f"{book}/index.md")
        if section_changed and section_file:
            parts.append(str(section_file.relative_to(root)))
        print(f"Updated {' and '.join(parts)}")
    else:
        print(f"No changes needed — '{args.theorem_id}' already has status '{args.status}'")


if __name__ == "__main__":
    main()
