# Formal Verification Prover

## Project Purpose
Formalize optimization theorems from papers/lecture notes into verified Lean 4 proofs
using optlib + mathlib4.

---

## Quick Start

### Workflow A — Informal proof → Lean 4
```
User: "Formalize the proof in sample-informal-proof.md"
  → Claude reads the file
  → Creates proofs/<title>/TheoremName.lean with sorry placeholders
  → Run /lean4:autoprove to fill proofs
  → Run /lean4:checkpoint to commit verified result
  → Append entry to logs/proofs.log
```

### Workflow B — PDF → Sections → Prove a theorem
```bash
# Step 1: drop the PDF in place
cp my_paper.pdf papers/my_paper/original.pdf

# Step 2: preprocess (converts + splits into sections)
python scripts/preprocess.py papers/my_paper/original.pdf
# → writes papers/my_paper/full.md
# → writes papers/my_paper/sections/01_intro.md, 02_convergence.md, ...
# → appends entry to logs/pipeline.log

# Step 3: inspect sections
ls papers/my_paper/sections/
cat papers/my_paper/sections/02_convergence.md

# Step 4: in Claude Code, ask:
# "Prove Theorem 2.1 from papers/my_paper/sections/02_convergence.md"
#   → Claude reads the section, creates proofs/my_paper/Theorem21.lean
#   → Run /lean4:autoprove or /lean4:prove
#   → Run /lean4:checkpoint
#   → Append entry to logs/proofs.log
```

### Demo (already preprocessed — no PDF needed)
```
# The demo_lecture paper is already split. Try:
"Prove Theorem 2.1 from papers/demo_lecture/sections/02_gradient_descent.md"
```

---

### Workflow C — Textbook → Subsections → Prove a theorem

Use `scripts/preprocess_textbook.py` for textbooks (subsection-level splitting with theorem
detection and a master index). Unlike Workflow B, each output file covers one subsection
(e.g. §1.1, §1.2) rather than one chapter.

```bash
# Step 1: fast unit test — process only Chapter 1 (instant, pdfminer quality)
python3 scripts/preprocess_textbook.py textbook/Bubeck15.pdf --chapter 1 --fast

# Step 2: inspect output
ls papers/Bubeck15/sections/          # one file per subsection
cat papers/Bubeck15/index.md          # master theorem tracker

# Step 3: full book, high quality (uses marker_single — takes 15-30 min)
# Delete papers/Bubeck15/full.md first if you want to reconvert
python3 scripts/preprocess_textbook.py textbook/Bubeck15.pdf

# Step 4: formalize a theorem from a subsection
# "Prove Proposition 1.1 from papers/Bubeck15/sections/01_02_basic_properties_of_convexity.md"
#   → /lean4:autoprove or /lean4:prove
#   → /lean4:checkpoint
#   → update lean_files status in section file + rerun script to refresh index.md
```

#### Output structure (`papers/Bubeck15/`)
```
full.md                   ← full converted markdown (cached; delete to reconvert)
index.md                  ← master theorem/lemma tracker (regenerated each run)
sections/
  01_01_<slug>.md         ← YAML front-matter + subsection content
  01_02_<slug>.md
  ...
```

#### Per-section YAML front-matter
```yaml
---
book: Bubeck15
chapter: 1
chapter_title: Introduction
subsection: 2
subsection_title: Basic properties of convexity
section_id: '1.2'
theorems:
  - {id: 'Proposition 1.1', label: Projection onto convex set}
lean_files:
  - {id: 'Proposition 1.1', path: proofs/Bubeck15/Proposition11.lean, status: pending}
---
```
Status values for `lean_files`: `pending`, `partial`, `proved`. Re-running the script
**preserves existing status values** — it only adds new theorems as `pending`.

#### Conversion modes
| Flag | Tool | Time | Quality |
|------|------|------|---------|
| `--fast` | pdfminer | ~5 s | Plain text, no LaTeX rendering; `chapter_title` may be empty |
| _(default)_ | marker_single | 15–30 min | Full ML layout + LaTeX rendering |

The converted `full.md` is cached — re-runs reuse it. Delete it to force reconversion.

---

## Lean Setup
- Toolchain: v4.13.0 (pinned in `lean-toolchain`, required by optlib)
- Dependencies: optlib (optimization library), mathlib4 (via optlib's dependency)
- Before first use: `lake exe cache get` then `lake build`
- Always `lake build` before starting a proving session (lean-lsp-mcp needs it)

---

## Logging

### Pipeline log — `logs/pipeline.log`
Auto-written by `scripts/preprocess.py` in JSON Lines format:
```json
{"ts": "2026-02-25T10:00:00", "event": "preprocess_start", "pdf": "papers/x/original.pdf", "paper": "x"}
{"ts": "2026-02-25T10:05:00", "event": "preprocess_done", "paper": "x", "sections_count": 4, "section_titles": ["Intro", ...], "output_dir": "papers/x/sections"}
```

### Proof log — `logs/proofs.log`
**Claude must append an entry here after every proof session.** Format (one JSON object per line):
```json
{"ts": "2026-02-25T10:30:00", "event": "proof_session", "source": "papers/x/sections/02_convergence.md", "theorem": "TheoremName", "lean_file": "proofs/x/TheoremName.lean", "status": "proved", "notes": "used optlib gradient_method"}
```
Status values: `"proved"` (no sorry, lake build passes), `"partial"` (some sorry remain), `"failed"`.

**To write a proof log entry**, run this at the end of each session:
```bash
python3 -c "
import json, datetime
entry = {
  'ts': datetime.datetime.now().isoformat(timespec='seconds'),
  'event': 'proof_session',
  'source': 'papers/<title>/sections/<file>.md',
  'theorem': '<TheoremName>',
  'lean_file': 'proofs/<title>/<TheoremName>.lean',
  'status': 'proved',  # or partial / failed
  'notes': '<brief note>'
}
with open('logs/proofs.log', 'a') as f:
    f.write(json.dumps(entry) + '\n')
print('Logged.')
"
```

---

## Proving Workflow Detail

### Starting a proof session
1. Read the target section file: `papers/<title>/sections/NN_<section>.md`
2. Identify the theorem to formalize (statement + hypotheses)
3. **Check optlib first**: `ls .lake/packages/optlib/Optlib/` — the theorem may already exist
4. Create `proofs/<title>/TheoremName.lean` with imports + theorem + `sorry` placeholder
5. Run `/lean4:autoprove` for autonomous proof search, or `/lean4:prove` to stay interactive
6. Run `/lean4:checkpoint` when done to verify build + axioms + commit
7. Append entry to `logs/proofs.log`

### Proof file template
```lean
import Mathlib
import Optlib

-- [Theorem name from paper]
-- Source: papers/<title>/sections/NN_<section>.md
-- Informal statement: [paste from section file]
theorem TheoremName (hyp1 : ...) (hyp2 : ...) : conclusion := by
  sorry
```

### MCP tools available during proving
| Tool | When to use |
|------|-------------|
| `lean-lsp-mcp` (`lean_goal`) | Check current proof state at cursor |
| `lean-lsp-mcp` (`lean_diagnostic_messages`) | See all errors/warnings in a file |
| `lean_loogle` | Search by type signature (e.g. `Real.sqrt → ...`) |
| `lean_leansearch` | Natural language search ("gradient Lipschitz") |
| `lean_leanfinder` | Semantic lemma search for a proof goal |
| `lean_multi_attempt` | Try multiple tactics, pick the first that works |

---

## Key Libraries
- **Optlib**: convex functions, subgradients, L-smooth functions, gradient descent convergence,
  proximal operators, KKT conditions, ADMM
  → browse: `.lake/packages/optlib/Optlib/`
  → key modules: `Algorithm/GD/`, `Function/Convex.lean`, `Function/Lsmooth.lean`
- **Mathlib**: analysis, topology, linear algebra foundations

## File Conventions
- One theorem per `.lean` file in `proofs/<paper-title>/`
- Name files after the theorem (e.g., `GradientDescentConvergence.lean`)
- Always import `Mathlib` and `Optlib` (or specific submodules) at top

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/preprocess.py` | Papers/lecture notes → chapter-level sections (Workflow B) |
| `scripts/preprocess_textbook.py` | Textbooks → subsection-level sections with theorem index (Workflow C) |

Both scripts append JSON Lines entries to `logs/pipeline.log`.

---

## Common Pitfalls
- lean-lsp-mcp will timeout if `lake build` hasn't run — always build first
- optlib uses Lean 4.13.0 syntax; don't upgrade lean-toolchain without checking optlib compat
- `lake exe cache get` must run after `lake update` to avoid recompiling mathlib from scratch
- marker_single CLI may not be on PATH; the preprocessing script handles this automatically
- marker_single takes 15–30 min on a full textbook; use `--fast` for quick iteration
- Check optlib before proving — many optimization theorems are already formalized there
- After `lake build`, reload Lean files in editor and wait for LSP to finish loading mathlib (~5 min)
