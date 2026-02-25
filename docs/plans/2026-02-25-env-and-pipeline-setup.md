# Formalization Pipeline — Environment & Setup Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Set up the full two-phase formalization pipeline: Lean 4 project with optlib, lean-lsp-mcp MCP server, marker-pdf preprocessing script, CLAUDE.md, and verify the env with two minimal demo proofs.

**Architecture:** Two-phase pipeline in Claude Code. Phase 1: Python script converts PDF → Markdown → per-section files. Phase 2: Claude Code proving session reads a section file, writes a `.lean` proof file, and uses lean4-skills + lean-lsp-mcp to fill proofs.

**Tech Stack:** Lean 4.13.0 (pinned via elan), Lake, optlib, mathlib4, marker-pdf (Python), lean-lsp-mcp (uvx), lean4-skills plugin, pytest

---

## Task 1: Initialize git repo + .gitignore + directory scaffold

**Files:**
- Create: `.gitignore`
- Create: `papers/.gitkeep`
- Create: `proofs/.gitkeep`
- Create: `scripts/.gitkeep`

**Step 1: Initialize git**

```bash
cd "/Users/apple/Documents/formal verification/prover"
git init
```
Expected: `Initialized empty Git repository in .../prover/.git/`

**Step 2: Create .gitignore**

Create `.gitignore`:
```
# Lean build artifacts
.lake/
*.olean
*.ilean
*.c
*.o

# Python
__pycache__/
*.pyc
.venv/
*.egg-info/

# macOS
.DS_Store

# Papers (PDFs can be large)
papers/*/original.pdf
```

**Step 3: Create directory placeholders**

```bash
mkdir -p papers proofs scripts tests
touch papers/.gitkeep proofs/.gitkeep
```

**Step 4: Commit scaffold**

```bash
git add .gitignore papers/.gitkeep proofs/.gitkeep
git commit -m "chore: init repo with directory scaffold"
```
Expected: `[main (root-commit) xxxxxxx] chore: init repo with directory scaffold`

---

## Task 2: Lean project setup (lean-toolchain + lakefile + Basic.lean)

**Files:**
- Create: `lean-toolchain`
- Create: `lakefile.lean`
- Create: `Prover/Basic.lean`

**Why v4.13.0?** optlib (github.com/optsuite/optlib) pins to `leanprover/lean4:v4.13.0`. elan automatically switches to the correct version per-project when `lean-toolchain` is present — your system 4.28.0 is unaffected.

**Step 1: Create lean-toolchain**

Create `lean-toolchain`:
```
leanprover/lean4:v4.13.0
```

Verify elan will use it:
```bash
lean --version
```
Expected output contains `4.13.0` (elan auto-switches).

If elan doesn't have v4.13.0 yet, it will auto-download on first `lake build`. This may take a few minutes.

**Step 2: Create lakefile.lean**

Create `lakefile.lean`:
```lean
import Lake
open Lake DSL

package «prover» where
  leanOptions := #[
    ⟨`pp.unicode.fun, true⟩
  ]

require optlib from git "https://github.com/optsuite/optlib" @ "master"

@[default_target]
lean_lib «Prover» where
```

**Step 3: Create Prover/Basic.lean**

```bash
mkdir -p Prover
```

Create `Prover/Basic.lean`:
```lean
-- Base imports for the formalization project
import Mathlib
import Optlib
```

**Step 4: Fetch build cache (IMPORTANT — do this before `lake build` or it will compile mathlib from scratch, taking hours)**

```bash
lake exe cache get
```
Expected: Downloads pre-built `.olean` files for mathlib. Output shows download progress. This may take 5–15 minutes depending on bandwidth.

If `lake exe cache get` fails with "unknown executable", run `lake update` first:
```bash
lake update
lake exe cache get
```

**Step 5: Commit Lean setup**

```bash
git add lean-toolchain lakefile.lean Prover/Basic.lean
git commit -m "chore: add Lean 4.13.0 project with optlib + mathlib"
```

---

## Task 3: Verify Lean build compiles

**Step 1: Build the project**

```bash
lake build
```
Expected: Completes without errors. First run may still take a few minutes even with cache.

If you see `error: unknown package 'optlib'`, run `lake update` then retry.

**Step 2: Smoke-test lean-toolchain version**

```bash
lean --version
```
Expected: `Lean (version 4.13.0, ...)`

**Step 3: Commit if any lock files were generated**

```bash
git add lake-manifest.json 2>/dev/null; git commit -m "chore: add lake manifest" 2>/dev/null || echo "nothing new"
```

---

## Task 4: Configure lean-lsp-mcp MCP server

lean-lsp-mcp provides live Lean LSP interaction (goal states, diagnostics, code actions) via the Model Context Protocol. It's separate from the lean4-skills plugin tools.

**Files:**
- Modified: `.claude/settings.json` (auto-updated by `claude mcp add`)

**Step 1: Add lean-lsp-mcp as project-scoped MCP server**

Run from the project root (where `lakefile.lean` is):
```bash
claude mcp add lean-lsp -s project uvx lean-lsp-mcp
```
Expected: `Added MCP server lean-lsp to project scope`

The `-s project` flag scopes this MCP server to this project only. `uvx` runs it without a separate install step.

**Step 2: Verify registration**

```bash
claude mcp list
```
Expected: Shows `lean-lsp` in the list with scope `project`.

**Note:** lean-lsp-mcp requires `lake build` to have run first before it can query goal states. Always build before starting a proving session.

**Step 3: Commit MCP config**

```bash
git add .claude/
git commit -m "chore: add lean-lsp-mcp project-scoped MCP server"
```

---

## Task 5: Install marker-pdf + verify

marker-pdf uses ML models (surya) for math-aware PDF-to-Markdown conversion. It preserves LaTeX expressions like `$\nabla f(x)$`.

**Step 1: Install marker-pdf**

```bash
pip3 install marker-pdf
```

This installs ~1–2 GB of ML dependencies (torch, surya-ocr, etc.) on first install. Expected to take 5–10 minutes.

Verify:
```bash
marker_single --help 2>/dev/null || python3 -c "import marker; print('marker ok')"
```

**Step 2: Test marker on a small PDF (optional smoke test)**

If you have any PDF handy:
```bash
marker_single /path/to/any.pdf --output_dir /tmp/marker_test
ls /tmp/marker_test/
```
Expected: A `.md` file in the output dir.

---

## Task 6: Write tests for section splitter

We test the section-splitting logic independently from marker (using a synthetic markdown string).

**Files:**
- Create: `tests/test_preprocess.py`

**Step 1: Write the failing tests**

Create `tests/test_preprocess.py`:
```python
"""Tests for the preprocessing pipeline section splitter."""
import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'scripts'))

from preprocess import split_sections


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
Let $f: \mathbb{R}^n \to \mathbb{R}$ be convex.
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
```

**Step 2: Run tests — confirm they fail**

```bash
cd "/Users/apple/Documents/formal verification/prover"
python3 -m pytest tests/test_preprocess.py -v
```
Expected: `ImportError` or `ModuleNotFoundError: No module named 'preprocess'`

---

## Task 7: Write scripts/preprocess.py

**Files:**
- Create: `scripts/preprocess.py`

**Step 1: Write the script**

Create `scripts/preprocess.py`:
```python
#!/usr/bin/env python3
"""
Phase 1 preprocessing: PDF → Markdown → per-section files.

Usage:
    python scripts/preprocess.py papers/<title>/original.pdf

Output:
    papers/<title>/full.md          — full marker output
    papers/<title>/sections/        — one .md file per section
"""

import re
import sys
import subprocess
from pathlib import Path


def split_sections(markdown: str) -> list[dict]:
    """Split markdown into sections at top-level (#) headers.

    Returns list of dicts with keys: title, number, content.
    """
    if not markdown.strip():
        return []

    # Match top-level headers (single #)
    header_pattern = re.compile(r'^# (.+)$', re.MULTILINE)
    matches = list(header_pattern.finditer(markdown))

    if not matches:
        return []

    sections = []
    for i, match in enumerate(matches):
        title = match.group(1).strip()
        start = match.start()
        end = matches[i + 1].start() if i + 1 < len(matches) else len(markdown)
        content = markdown[start:end].strip()
        sections.append({
            'number': i + 1,
            'title': title,
            'content': content,
        })

    return sections


def title_to_slug(title: str) -> str:
    """Convert section title to a filesystem-safe slug."""
    slug = title.lower()
    slug = re.sub(r'[^a-z0-9]+', '_', slug)
    slug = slug.strip('_')
    return slug[:50]  # truncate to reasonable length


def convert_pdf_to_markdown(pdf_path: Path, output_dir: Path) -> Path:
    """Run marker on the PDF and return path to the output markdown file."""
    output_dir.mkdir(parents=True, exist_ok=True)

    # Try marker_single CLI (marker-pdf package)
    try:
        result = subprocess.run(
            ['marker_single', str(pdf_path), '--output_dir', str(output_dir)],
            capture_output=True, text=True, check=True
        )
        # marker outputs a file named <pdf_stem>/<pdf_stem>.md
        md_candidates = list(output_dir.glob('**/*.md'))
        if md_candidates:
            return md_candidates[0]
    except (subprocess.CalledProcessError, FileNotFoundError):
        pass

    # Fallback: try marker CLI (newer versions)
    try:
        result = subprocess.run(
            ['marker', str(pdf_path), str(output_dir)],
            capture_output=True, text=True, check=True
        )
        md_candidates = list(output_dir.glob('**/*.md'))
        if md_candidates:
            return md_candidates[0]
    except (subprocess.CalledProcessError, FileNotFoundError):
        pass

    raise RuntimeError(
        "Could not run marker. Install with: pip install marker-pdf\n"
        "Then verify with: marker_single --help"
    )


def write_section_files(sections: list[dict], paper_dir: Path, paper_name: str) -> list[Path]:
    """Write each section to a numbered markdown file with YAML front-matter."""
    sections_dir = paper_dir / 'sections'
    sections_dir.mkdir(parents=True, exist_ok=True)

    written = []
    for section in sections:
        slug = title_to_slug(section['title'])
        filename = f"{section['number']:02d}_{slug}.md"
        filepath = sections_dir / filename

        front_matter = (
            f"---\n"
            f"paper: {paper_name}\n"
            f"section: {section['number']}\n"
            f"title: {section['title']}\n"
            f"---\n\n"
        )

        filepath.write_text(front_matter + section['content'])
        written.append(filepath)
        print(f"  Wrote: {filepath.relative_to(paper_dir.parent.parent)}")

    return written


def preprocess(pdf_path: Path) -> None:
    """Full preprocessing pipeline: PDF → Markdown → section files."""
    if not pdf_path.exists():
        raise FileNotFoundError(f"PDF not found: {pdf_path}")

    paper_name = pdf_path.parent.name
    paper_dir = pdf_path.parent
    tmp_marker_dir = paper_dir / '_marker_tmp'

    print(f"[1/3] Converting PDF with marker: {pdf_path.name}")
    md_path = convert_pdf_to_markdown(pdf_path, tmp_marker_dir)

    print(f"[2/3] Reading markdown output: {md_path}")
    full_md = md_path.read_text()

    # Copy full markdown to paper dir
    full_md_path = paper_dir / 'full.md'
    full_md_path.write_text(full_md)
    print(f"      Saved full markdown: {full_md_path.relative_to(paper_dir.parent.parent)}")

    print(f"[3/3] Splitting into sections")
    sections = split_sections(full_md)
    if not sections:
        print("  WARNING: No top-level sections found. Check full.md manually.")
        return

    print(f"      Found {len(sections)} section(s)")
    write_section_files(sections, paper_dir, paper_name)
    print(f"\nDone! Section files are in: {paper_dir / 'sections'}")


if __name__ == '__main__':
    if len(sys.argv) != 2:
        print("Usage: python scripts/preprocess.py <path-to-pdf>")
        print("Example: python scripts/preprocess.py papers/gradient_descent/original.pdf")
        sys.exit(1)

    preprocess(Path(sys.argv[1]))
```

**Step 2: Run tests — confirm they pass**

```bash
python3 -m pytest tests/test_preprocess.py -v
```
Expected:
```
PASSED tests/test_preprocess.py::test_splits_by_top_level_header
PASSED tests/test_preprocess.py::test_section_content_preserved
PASSED tests/test_preprocess.py::test_section_numbers
PASSED tests/test_preprocess.py::test_empty_input
PASSED tests/test_preprocess.py::test_no_headers
PASSED tests/test_preprocess.py::test_metadata_frontmatter
```

**Step 3: Commit**

```bash
git add scripts/preprocess.py tests/test_preprocess.py
git commit -m "feat: add PDF preprocessing script with section splitter"
```

---

## Task 8: Write CLAUDE.md

**Files:**
- Create: `CLAUDE.md`

**Step 1: Create CLAUDE.md**

Create `CLAUDE.md`:
```markdown
# Formal Verification Prover

## Project Purpose
Formalize optimization theorems from papers/lecture notes into verified Lean 4 proofs
using optlib + mathlib4.

## Lean Setup
- Toolchain: v4.13.0 (pinned in `lean-toolchain`, required by optlib)
- Dependencies: optlib (optimization library), mathlib4 (via optlib's dependency)
- Before first use: `lake exe cache get` then `lake build`
- Always `lake build` before starting a proving session (lean-lsp-mcp needs it)

## Phase 1: Preprocessing a Paper (run once per PDF)
```bash
python scripts/preprocess.py papers/<title>/original.pdf
```
Outputs:
- `papers/<title>/full.md` — full paper as markdown
- `papers/<title>/sections/NN_<section>.md` — one file per section

## Phase 2: Proving Workflow

### Starting a proof session
1. Read the target section file: `papers/<title>/sections/NN_<section>.md`
2. Identify the theorem to formalize (statement + hypotheses)
3. Create `proofs/<title>/TheoremName.lean` with imports + theorem + `sorry` placeholder
4. Run `/lean4:autoprove` for autonomous proof search, or `/lean4:prove` to stay interactive
5. Run `/lean4:checkpoint` when done to verify build + axioms + commit

### Proof file template
```lean
import Mathlib
import Optlib

-- [Theorem name from paper]
-- Informal statement: [paste from section file]
theorem TheoremName (hyp1 : ...) (hyp2 : ...) : conclusion := by
  sorry
```

### MCP tools available during proving
| Tool | When to use |
|------|-------------|
| `lean-lsp-mcp` (lean_goal) | Check current proof state at cursor |
| `lean-lsp-mcp` (lean_diagnostic_messages) | See all errors/warnings in a file |
| `lean_loogle` | Search by type signature (e.g. `Real.sqrt → ...`) |
| `lean_leansearch` | Natural language search ("gradient Lipschitz") |
| `lean_leanfinder` | Semantic lemma search for a proof goal |
| `lean_multi_attempt` | Try multiple tactics, pick the first that works |

## Key Libraries
- **Optlib**: convex functions, subgradients, L-smooth functions, gradient descent convergence,
  proximal operators, KKT conditions, ADMM — see `Optlib/` for module structure
- **Mathlib**: analysis, topology, linear algebra foundations

## File Conventions
- One theorem per `.lean` file in `proofs/<paper-title>/`
- Name files after the theorem (e.g., `GradientDescentConvergence.lean`)
- Always import `Mathlib` and `Optlib` at top

## Common Pitfalls
- lean-lsp-mcp will timeout if `lake build` hasn't run — always build first
- optlib uses Lean 4.13.0 syntax; don't upgrade lean-toolchain without checking optlib compat
- `lake exe cache get` must run after `lake update` to avoid recompiling mathlib from scratch
```

**Step 2: Commit**

```bash
git add CLAUDE.md
git commit -m "docs: add CLAUDE.md with proving workflow instructions"
```

---

## Task 9: Demo Task A — informal proof → Lean 4 skeleton

Verify the end-to-end proving workflow with a simple theorem from optlib's domain.

**Files:**
- Create: `proofs/demo/GradientDescentConvergence.lean`

**Step 1: Create the proofs/demo directory**

```bash
mkdir -p proofs/demo
```

**Step 2: Create a sorry-filled theorem file**

Create `proofs/demo/GradientDescentConvergence.lean`:
```lean
import Mathlib
import Optlib

/-!
# Gradient Descent Convergence (Demo)

Informal statement: If f is convex and L-smooth, gradient descent with
step size α = 1/L satisfies f(x_k) - f(x*) ≤ ‖x_0 - x*‖² / (2α k).

This file demonstrates the Phase 2 proving workflow.
-/

-- TODO: Replace with the actual theorem from optlib or prove from scratch.
-- Start with a simpler lemma to verify the env works.

example (a b : ℝ) (ha : 0 < a) (hb : 0 < b) : 0 < a + b := by
  sorry
```

**Step 3: Verify lake build still works**

```bash
lake build
```
Expected: Builds without errors (sorry is allowed).

**Step 4: Try to fill the sorry interactively**

In Claude Code, run:
```
/lean4:prove
```
Claude will try to fill the `sorry` in the example. For `0 < a + b` given `0 < a` and `0 < b`, the proof is `linarith` or `positivity`. This verifies the lean4-skills autoprove cycle works.

Expected result: The `sorry` is replaced with a working tactic proof and `lake build` passes.

**Step 5: Commit**

```bash
git add proofs/demo/GradientDescentConvergence.lean
git commit -m "feat: add demo proof skeleton for gradient descent convergence"
```

---

## Task 10: Demo Task B — create sample paper directory + run preprocessor

Verify the Phase 1 pipeline works end-to-end.

**Files:**
- Create: `papers/demo_lecture/` (with a small test PDF or synthetic markdown)

**Step 1: Create a synthetic test (avoids needing a real PDF for CI)**

Create `papers/demo_lecture/full.md` manually (simulates marker output):
```markdown
# Introduction

This lecture covers convex optimization fundamentals.

# Gradient Descent

Let $f: \mathbb{R}^n \to \mathbb{R}$ be convex and $L$-smooth.

**Theorem 2.1** (Convergence): With step size $\alpha = 1/L$, gradient descent satisfies:
$$f(x_k) - f^* \leq \frac{\|x_0 - x^*\|^2}{2\alpha k}$$

**Proof**: By $L$-smoothness, we have $f(x_{k+1}) \leq f(x_k) - \frac{1}{2L}\|\nabla f(x_k)\|^2$...

# Proximal Methods

The proximal operator of $g$ is defined as...
```

**Step 2: Run the section splitter on this synthetic markdown**

```python
# Quick test in Python REPL
import sys; sys.path.insert(0, 'scripts')
from preprocess import split_sections, write_section_files
from pathlib import Path

full_md = Path('papers/demo_lecture/full.md').read_text()
sections = split_sections(full_md)
print(f"Found {len(sections)} sections: {[s['title'] for s in sections]}")
write_section_files(sections, Path('papers/demo_lecture'), 'demo_lecture')
```

Expected:
```
Found 3 sections: ['Introduction', 'Gradient Descent', 'Proximal Methods']
  Wrote: papers/demo_lecture/sections/01_introduction.md
  Wrote: papers/demo_lecture/sections/02_gradient_descent.md
  Wrote: papers/demo_lecture/sections/03_proximal_methods.md
```

**Step 3: Verify section file content**

```bash
cat "papers/demo_lecture/sections/02_gradient_descent.md"
```
Expected: YAML front-matter + section content with LaTeX preserved.

**Step 4: Commit**

```bash
git add papers/demo_lecture/
git commit -m "feat: add demo lecture paper with synthetic section split"
```

---

## Task 11: Final verification

**Step 1: Run all tests**

```bash
python3 -m pytest tests/ -v
```
Expected: All 6 tests pass.

**Step 2: Verify Lean build**

```bash
lean --version   # should show 4.13.0
lake build       # should succeed
```

**Step 3: Verify MCP server**

```bash
claude mcp list
```
Expected: `lean-lsp` listed with project scope.

**Step 4: Final commit**

```bash
git status  # confirm nothing untracked
git log --oneline  # review commit history
```

Expected commit history:
```
feat: add demo lecture paper with synthetic section split
feat: add demo proof skeleton for gradient descent convergence
docs: add CLAUDE.md with proving workflow instructions
feat: add PDF preprocessing script with section splitter
chore: add lean-lsp-mcp project-scoped MCP server
chore: add Lean 4.13.0 project with optlib + mathlib
chore: init repo with directory scaffold
```

---

## Known Constraints

| Issue | Resolution |
|-------|-----------|
| optlib requires Lean 4.13.0 | Pinned via `lean-toolchain`; elan handles per-project switching |
| mathlib build takes hours | Use `lake exe cache get` — downloads prebuilt artifacts |
| marker-pdf install is large (~2 GB) | One-time cost; installs ML models for math-aware OCR |
| lean-lsp-mcp needs `lake build` first | Documented in CLAUDE.md; always build before proving session |
| Real PDF may have multi-column layout | marker handles it reasonably; manual cleanup for edge cases |
