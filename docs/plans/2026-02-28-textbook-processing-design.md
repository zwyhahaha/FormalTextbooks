# Textbook Processing Pipeline Design

**Date:** 2026-02-28
**Status:** Approved

---

## Goal

Convert `textbook/Bubeck15.pdf` (and future textbooks) into subsection-level markdown files
optimised for a progressive formalization workflow: one subsection at a time, with theorem
tracking and pointers to Lean proof files.

---

## Output File Structure

```
papers/Bubeck15/
  full.md                               ← raw marker_single output
  index.md                              ← master theorem/lemma tracker (regenerated each run)
  sections/
    01_01_some_convex_optimization_problems.md
    01_02_basic_properties_of_convexity.md
    01_03_why_convexity.md
    01_04_black_box_model.md
    01_05_structured_optimization.md
    01_06_overview_of_results_and_disclaimer.md
    02_01_center_of_gravity_method.md
    ...
```

Filename convention: `{chapter:02d}_{subsection:02d}_{slug}.md`

---

## Per-Subsection File Format

Each file contains YAML front-matter followed by the raw markdown content:

```yaml
---
book: "Bubeck15"
chapter: 1
chapter_title: "Introduction"
subsection: 1
subsection_title: "Some convex optimization problems in machine learning"
section_id: "1.1"
theorems:
  - {id: "Proposition 1.1", label: "Projection onto convex set"}
  - {id: "Lemma 1.2",       label: ""}
lean_files:
  - {id: "Proposition 1.1", path: "proofs/Bubeck15/Proposition11.lean", status: "pending"}
---

## 1.1 Some convex optimization problems in machine learning

...content...
```

`lean_files` entries start as `status: pending`. Re-runs preserve existing status values
(so proof progress is not reset when the script is re-run).

---

## Master Index Format (`index.md`)

Regenerated on every run by reading all section files:

```markdown
# Bubeck15 — Theorem & Lemma Index

| ID              | Section | Subsection Title                      | Lean file                          | Status  |
|-----------------|---------|---------------------------------------|------------------------------------|---------|
| Proposition 1.1 | 1.1     | Some convex optimization problems     | proofs/Bubeck15/Proposition11.lean | pending |
| Lemma 3.3       | 3.2     | Gradient descent for smooth functions | proofs/Bubeck15/Lemma33.lean       | proved  |
```

---

## Script: `scripts/preprocess_textbook.py`

### Approach

Approach A: `marker_single` for PDF→markdown, regex for theorem detection.
Consistent with existing `scripts/preprocess.py`. Does not modify that file.

### Stages

1. **`convert_pdf_to_markdown(pdf_path, out_dir)`**
   Calls `marker_single` (same fallback chain as `preprocess.py`). Returns path to `full.md`.

2. **`split_subsections(markdown)`**
   Splits on `## X.Y …` headers using regex `r'^## (\d+)\.(\d+)\s+(.+)$'`.
   Also captures the enclosing `#` chapter header for `chapter_title`.
   Returns list of dicts: `{chapter, chapter_title, subsection, subsection_title, section_id, content}`.

3. **`detect_theorems(content)`**
   Regex scan for:
   `(Theorem|Lemma|Proposition|Corollary|Definition)\s+(\d+\.\d+)`
   Returns list of `{id, label}` dicts (label empty if no inline description found).

4. **`write_section_files(subsections, paper_dir)`**
   For each subsection, writes `sections/{ch:02d}_{sub:02d}_{slug}.md`.
   If the file already exists, reads existing `lean_files` status and merges
   (preserves status, adds new theorems with `pending`).

5. **`write_index(paper_dir)`**
   Reads all section files, collects all `lean_files` entries, writes `index.md`.

6. **Logging**
   Appends JSON-Lines entries to `logs/pipeline.log`:
   - `preprocess_textbook_start`
   - `preprocess_textbook_done` (with section count, theorem count)

### CLI

```bash
# Full book
python3 scripts/preprocess_textbook.py textbook/Bubeck15.pdf

# Single chapter (unit test)
python3 scripts/preprocess_textbook.py textbook/Bubeck15.pdf --chapter 1
```

---

## Integration with Existing Workflow

- `scripts/preprocess.py` — unchanged (used for papers/lecture notes)
- `scripts/preprocess_textbook.py` — new (used for textbooks)
- `logs/pipeline.log` — shared log file, same format
- `CLAUDE.md` — update Workflow B to mention textbook pipeline

---

## Unit Test

Run `--chapter 1` on `Bubeck15.pdf`. Expected output:
- 6 section files under `papers/Bubeck15/sections/01_*.md`
- `papers/Bubeck15/index.md` with all theorems from Chapter 1
- Log entry in `logs/pipeline.log`
