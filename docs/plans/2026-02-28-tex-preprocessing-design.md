# Design: TeX Source Preprocessing Pipeline

**Date:** 2026-02-28
**Source:** `textbook/Bubeck15-arXiv-1405.4980v2/`
**Output:** `papers/Bubeck_convex_optimization/`

## Motivation

The existing `preprocess_textbook.py` converts PDF → markdown via pdfminer or marker_single,
producing OCR-degraded output with broken math. The TeX source is available and gives:
- Clean theorem environments (`\begin{theorem}[Name]\label{...}`)
- Valid LaTeX math (no OCR errors)
- Section structure via `\section{}` / `\subsection{}`
- Stable theorem labels via `\label{}`

## Output Structure

```
papers/Bubeck_convex_optimization/
  index.md
  sections/
    01_01_<slug>.md
    01_02_<slug>.md
    ...
    02_03_<slug>.md          # §2.3 intro text (before first \subsection)
    02_03_01_<slug>.md       # §2.3.1
    02_03_02_<slug>.md       # §2.3.2
    ...
```

### YAML Front-matter (per section file)

```yaml
---
book: Bubeck_convex_optimization
chapter: 2
chapter_title: Convex optimization in finite dimension
section: 1
section_title: The center of gravity method
subsection: null           # null for \section files; int for \subsection files
subsection_title: null
section_id: '2.1'
tex_label: sec:gravity     # from \label{} in source TeX, if present
theorems:
  - {id: 'Theorem 2.1', label: 'Center of gravity', tex_label: 'thm:cog'}
lean_files:
  - {id: 'Theorem 2.1', path: proofs/Bubeck_convex_optimization/Theorem21.lean, status: pending}
---
```

Status values for `lean_files`: `pending`, `partial`, `proved`. Re-runs preserve existing status.

### index.md

Same format as `papers/Bubeck15/index.md`:

```markdown
# Theorem & Lemma Index

| ID | Section | Subsection Title | Lean file | Status |
|----|---------|------------------|-----------|--------|
| Theorem 2.1 | 2.1 | The center of gravity method | proofs/... | pending |
```

## Pipeline

**Script:** `scripts/preprocess_tex.py`

### Steps

1. **Load macros** — parse `Commands.tex`, build substitution map
   (`\R` → `\mathbb{R}`, `\cX` → `\mathcal{X}`, `\E` → `\mathbb{E}`, etc.)

2. **Split TeX** — for each chapter file, regex-parse `\section{}` and `\subsection{}`
   to produce chunks with: chapter number, section number, optional subsection number,
   title, TeX label (from `\label{}`), and raw TeX body text

3. **Detect theorems (on raw TeX)** — regex on each chunk for:
   `\begin{theorem}[Name]\label{...}`, `\begin{lemma}`, `\begin{proposition}`,
   `\begin{corollary}`, `\begin{definition}` — extract name, number (inferred from
   chapter.section counter), and TeX label

4. **Convert to markdown (pandoc)** — write a minimal `.tex` fragment per chunk:
   ```latex
   \documentclass{article}
   \usepackage{amsmath,amssymb}
   \input{Commands}
   \begin{document}
   <chunk body>
   \end{document}
   ```
   Run: `pandoc --from latex --to markdown-raw_tex --mathjax`
   Fall back to raw TeX body if pandoc is not available.

5. **Write section files** — YAML front-matter + pandoc markdown body

6. **Regenerate index.md** — scan all section files, collect `lean_files` entries,
   write master table (same logic as `preprocess_textbook.py:write_index()`)

7. **Log to `logs/pipeline.log`** — JSON Lines entries for start/done events

### CLI

```bash
python3 scripts/preprocess_tex.py textbook/Bubeck15-arXiv-1405.4980v2/
# Optional flags:
#   --chapter 1       process only chapter 1
#   --no-pandoc       skip pandoc, keep raw TeX in body
```

### Chapter → File Mapping

| TeX file | Chapter | Chapter title |
|----------|---------|---------------|
| `intro2.tex` | 1 | Introduction |
| `finitedim2.tex` | 2 | Convex optimization in finite dimension |
| `dimfree2.tex` | 3 | Dimension-free convex optimization |
| `mirror2.tex` | 4 | Almost dimension-free convex optimization in non-Euclidean spaces |
| `beyond2.tex` | 5 | Beyond the black-box model |
| `rand2.tex` | 6 | Convex optimization and randomness |

## Key Design Decisions

- **Math format:** Pandoc-rendered markdown — macros expanded, math as `$...$` / `$$...$$`
- **Split depth:** Both `\section{}` and `\subsection{}` — more granular, each file covers one concept
- **Theorem detection:** On raw TeX (before pandoc), using `\begin{theorem}` regex — reliable
- **Status preservation:** Re-runs preserve existing `lean_files` status (same as `preprocess_textbook.py`)
- **Pandoc fallback:** If pandoc unavailable, write raw TeX body (still useful for agents)

## Integration with Existing Workflow

The output is drop-in compatible with the existing proving workflow (Workflow C in CLAUDE.md):

```
"Prove Theorem 2.1 from papers/Bubeck_convex_optimization/sections/02_01_center_of_gravity_method.md"
  → /lean4:autoprove or /lean4:prove
  → /lean4:checkpoint
  → update lean_files status
```
