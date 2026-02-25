"""PDF preprocessing pipeline: convert PDF to markdown and split into sections."""
import datetime
import json
import re
import shutil
import subprocess
import sys
from pathlib import Path

LOG_FILE = Path("logs/pipeline.log")


def _log(event: str, data: dict) -> None:
    """Append a JSON-Lines entry to logs/pipeline.log."""
    LOG_FILE.parent.mkdir(parents=True, exist_ok=True)
    entry = {"ts": datetime.datetime.now().isoformat(timespec="seconds"), "event": event, **data}
    with LOG_FILE.open("a", encoding="utf-8") as f:
        f.write(json.dumps(entry) + "\n")


MARKER_SINGLE_FULL_PATH = (
    "/Library/Frameworks/Python.framework/Versions/3.12/bin/marker_single"
)


def split_sections(markdown: str) -> list[dict]:
    """Split markdown at top-level '#' headers.

    Each returned dict has:
      - number  (int, 1-based)
      - title   (str)
      - content (str, includes the header line)

    Returns [] for empty string or string with no '#' headers.
    """
    if not markdown:
        return []

    # Split on lines that start with exactly one '#' (top-level header)
    # We use a regex that captures the header line so we can reconstruct content.
    pattern = re.compile(r'^(# .+)$', re.MULTILINE)

    # Find all header positions and titles
    headers = list(pattern.finditer(markdown))
    if not headers:
        return []

    sections = []
    for idx, match in enumerate(headers):
        title = match.group(1)[2:]  # strip '# ' prefix
        start = match.start()
        end = headers[idx + 1].start() if idx + 1 < len(headers) else len(markdown)
        content = markdown[start:end]
        sections.append({
            "number": idx + 1,
            "title": title,
            "content": content,
        })

    return sections


def title_to_slug(title: str) -> str:
    """Lowercase, replace non-alphanumeric with '_', strip edges, truncate to 50."""
    slug = re.sub(r'[^a-z0-9]+', '_', title.lower())
    slug = slug.strip('_')
    return slug[:50]


def convert_pdf_to_markdown(pdf_path: Path, output_dir: Path) -> Path:
    """Convert a PDF file to markdown using the marker CLI.

    Tries in order:
      1. Full path to marker_single
      2. marker_single on PATH
      3. marker CLI

    Returns the path to the generated .md file.
    Raises RuntimeError if all approaches fail.
    """
    output_dir.mkdir(parents=True, exist_ok=True)

    candidates = [
        [MARKER_SINGLE_FULL_PATH, str(pdf_path), "--output_dir", str(output_dir)],
        ["marker_single", str(pdf_path), "--output_dir", str(output_dir)],
        ["marker", str(pdf_path), "--output_dir", str(output_dir)],
    ]

    last_error = None
    for cmd in candidates:
        try:
            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
            )
            if result.returncode == 0:
                # marker_single writes output to a subdirectory named after the PDF
                stem = pdf_path.stem
                # Search for the produced .md file
                md_files = list(output_dir.rglob(f"{stem}.md"))
                if not md_files:
                    # Fallback: any .md file produced
                    md_files = list(output_dir.rglob("*.md"))
                if md_files:
                    return md_files[0]
            last_error = result.stderr or f"Command exited with code {result.returncode}"
        except FileNotFoundError as exc:
            last_error = str(exc)
            continue

    raise RuntimeError(
        f"All PDF-to-markdown conversion approaches failed. Last error: {last_error}"
    )


def write_section_files(
    sections: list[dict], paper_dir: Path, paper_name: str
) -> list[Path]:
    """Write each section to paper_dir/sections/NN_<slug>.md with YAML front-matter.

    Returns list of written Paths.
    """
    sections_dir = paper_dir / "sections"
    sections_dir.mkdir(parents=True, exist_ok=True)

    written: list[Path] = []
    for section in sections:
        slug = title_to_slug(section["title"])
        filename = f"{section['number']:02d}_{slug}.md"
        out_path = sections_dir / filename

        front_matter = (
            "---\n"
            f"paper: {json.dumps(paper_name)}\n"
            f"section: {section['number']}\n"
            f"title: {json.dumps(section['title'])}\n"
            "---\n"
            "\n"
        )
        out_path.write_text(front_matter + section["content"], encoding="utf-8")
        written.append(out_path)

    return written


def preprocess(pdf_path: Path) -> None:
    """Main entrypoint: validate PDF, convert, split, and write section files."""
    pdf_path = Path(pdf_path)
    if not pdf_path.exists():
        raise FileNotFoundError(f"PDF not found: {pdf_path}")

    paper_name = pdf_path.stem
    paper_dir = Path("papers") / paper_name
    paper_dir.mkdir(parents=True, exist_ok=True)

    _log("preprocess_start", {"pdf": str(pdf_path), "paper": paper_name})

    print(f"[preprocess] Converting {pdf_path} to markdown …")
    tmp_output = paper_dir / "_marker_tmp"
    md_path = convert_pdf_to_markdown(pdf_path, tmp_output)

    full_md_dest = paper_dir / "full.md"
    shutil.copy2(md_path, full_md_dest)
    print(f"[preprocess] Full markdown saved to {full_md_dest}")

    markdown = full_md_dest.read_text(encoding="utf-8")
    sections = split_sections(markdown)
    print(f"[preprocess] Found {len(sections)} section(s)")

    written = write_section_files(sections, paper_dir, paper_name)
    for p in written:
        print(f"[preprocess]   wrote {p}")

    _log("preprocess_done", {
        "paper": paper_name,
        "sections_count": len(sections),
        "section_titles": [s["title"] for s in sections],
        "output_dir": str(paper_dir / "sections"),
    })
    print("[preprocess] Done.")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 preprocess.py <path/to/paper.pdf>")
        sys.exit(1)
    preprocess(Path(sys.argv[1]))
