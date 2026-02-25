# Formalization Pipeline Design

**Date**: 2026-02-25
**Project**: Formal Verification Prover
**Goal**: Automatically formalize optimization theorems from papers/lecture notes into verified Lean 4 proofs using Claude Code.

---

## 1. Architecture Overview

**Approach**: Two-phase scripted pipeline running entirely inside Claude Code sessions.

- **Phase 1** (preprocessing): Python script converts PDF → Markdown → per-section files. Run once per paper.
- **Phase 2** (proving): Claude Code session reads a section file, writes a `.lean` file, and proves it using lean4-skills + lean-lsp-mcp.

---

## 2. Project Structure

```
prover/
├── CLAUDE.md                      # Claude Code workflow instructions
├── lean-toolchain                 # leanprover/lean4:v4.13.0
├── lakefile.lean                  # requires optlib + mathlib4
├── Prover/
│   └── Basic.lean                 # base imports (Optlib, Mathlib)
├── papers/
│   └── <paper-title>/
│       ├── original.pdf
│       ├── full.md                # marker output (full paper)
│       └── sections/
│           ├── 01_introduction.md
│           ├── 02_preliminaries.md
│           └── ...
├── proofs/
│   └── <paper-title>/
│       └── TheoremName.lean       # verified Lean 4 proof output
├── scripts/
│   └── preprocess.py              # Phase 1 preprocessing script
└── docs/
    └── plans/
        └── 2026-02-25-formalization-pipeline-design.md
```

---

## 3. Environment Setup

| Component | Version / Source | Purpose |
|-----------|-----------------|---------|
| Lean 4 | v4.13.0 (via elan, pinned in `lean-toolchain`) | Required by optlib |
| Lake | bundled with Lean 4.13.0 | Build system |
| optlib | `github.com/optsuite/optlib` | Optimization theorems library |
| mathlib4 | via optlib's transitive dependency | Foundational math |
| marker-pdf | `pip install marker-pdf` | ML-based PDF → Markdown |
| lean-lsp-mcp | `uvx lean-lsp-mcp` (project-scoped MCP) | Live Lean LSP interaction |
| lean4-skills plugin | already installed | `/lean4:autoprove`, `/lean4:prove`, etc. |

### Setup Commands (one-time)

```bash
# 1. Pin Lean version (elan auto-switches per project)
echo "leanprover/lean4:v4.13.0" > lean-toolchain

# 2. Fetch mathlib + optlib build cache
lake exe cache get

# 3. Install PDF preprocessor
pip install marker-pdf

# 4. Register Lean MCP server (project-scoped)
claude mcp add lean-lsp -s project uvx lean-lsp-mcp

# 5. Build project (required before lean-lsp-mcp can query goal states)
lake build
```

---

## 4. Phase 1: Preprocessing Pipeline

**Script**: `scripts/preprocess.py`

**Input**: `papers/<title>/original.pdf`
**Outputs**:
- `papers/<title>/full.md` — full marker output
- `papers/<title>/sections/NN_<section-title>.md` — one file per section

**Steps**:
1. Run `marker` on the PDF to produce LaTeX-preserving Markdown (handles equations, tables)
2. Parse markdown headers (`#`, `##`) to identify section boundaries
3. Write each section to a numbered file with YAML front-matter

**Section file format**:
```markdown
---
paper: gradient_descent
section: 3
title: Convergence Analysis
---

## 3. Convergence Analysis

Let $f$ be $L$-smooth and convex...

**Theorem 3.1** (Convergence rate): ...

**Proof**: ...
```

**Usage**:
```bash
python scripts/preprocess.py papers/gradient_descent/original.pdf
```

---

## 5. Phase 2: Proving Session Workflow

### Task A — Informal proof → Lean 4 formalization

```
User pastes informal proof text into Claude Code
  ↓
Claude identifies: theorem statement, hypotheses, proof strategy
  ↓
Claude creates proofs/<title>/TheoremName.lean
  (imports Mathlib + Optlib, theorem statement, sorry placeholders)
  ↓
/lean4:autoprove fills sorries using lean-lsp-mcp + search tools
  ↓
/lean4:checkpoint verifies: lake build passes, no axiom violations
```

### Task B — PDF section → Lean 4 formalization

```
User: "formalize Theorem 3.1 from papers/gradient_descent/sections/03_convergence.md"
  ↓
Claude reads section file → extracts theorem + informal proof
  ↓
Same flow as Task A from here
```

### Tool Roles During Proving

| Tool | Role |
|------|------|
| `lean-lsp-mcp` | Live goal state, diagnostics, code actions, "try this" suggestions |
| `lean_loogle` | Search mathlib/optlib by type signature |
| `lean_leansearch` | Natural language search ("Lipschitz continuous gradient") |
| `lean_leanfinder` | Semantic lemma discovery for a proof goal |
| `/lean4:prove` | Guided interactive cycles (human stays in loop) |
| `/lean4:autoprove` | Autonomous cycles (walk away) |
| `/lean4:checkpoint` | Safe commit: build passes + axiom check |

---

## 6. CLAUDE.md Content

```markdown
# Formal Verification Prover

## Project Purpose
Formalize optimization theorems from papers into verified Lean 4 proofs
using optlib + mathlib4.

## Lean Setup
- Toolchain: v4.13.0 (pinned in lean-toolchain, matches optlib)
- Dependencies: optlib, mathlib4 (via Lake)
- Always run `lake exe cache get` before first build
- Run `lake build` before using lean-lsp-mcp tools

## Phase 1: Preprocessing
python scripts/preprocess.py <pdf-path>
Outputs section files to papers/<title>/sections/

## Phase 2: Proving Workflow
1. Read the relevant section file from papers/<title>/sections/
2. Extract theorem statement + hypotheses
3. Create proofs/<title>/TheoremName.lean
4. Use /lean4:autoprove for autonomous proof search
5. Use /lean4:checkpoint to verify + commit

## Proof File Convention
- One theorem per .lean file
- Imports: Mathlib, Optlib at minimum
- File names match theorem names (e.g., GradientDescentConvergence.lean)

## Key Libraries
- Optlib: convex analysis, gradient descent, proximal methods, KKT conditions
- Mathlib: analysis, topology, linear algebra foundations

## MCP Tools Available
- lean-lsp-mcp: live goal states, diagnostics (requires lake build first)
- lean_loogle / lean_leansearch / lean_leanfinder: lemma search
```

---

## 7. Minimal Demo Tasks

### Demo 1: Informal proof → formal proof
- Input: pasted informal proof of gradient descent convergence (from paper or written by user)
- Output: `proofs/demo/GradientDescentConvergence.lean` — verified

### Demo 2: PDF → section → formal proof
- Input: a PDF lecture note on convex optimization
- Run: `python scripts/preprocess.py papers/lecture/original.pdf`
- Pick: `papers/lecture/sections/03_convergence.md`
- Output: verified `.lean` proof for one theorem in that section

---

## 8. Key Constraints & Risks

| Risk | Mitigation |
|------|-----------|
| optlib requires Lean 4.13.0 (older than system 4.28.0) | Pin via `lean-toolchain`; elan handles version switching per project |
| marker-pdf may struggle with complex multi-column layouts | Acceptable for demo; can fallback to manual markdown for edge cases |
| lean-lsp-mcp needs `lake build` first | Document in CLAUDE.md; add to setup steps |
| optlib may not cover all theorems in a given paper | Use mathlib fallback; note gaps in proof comments |
| Long lake build times (mathlib) | `lake exe cache get` fetches prebuilt artifacts |
