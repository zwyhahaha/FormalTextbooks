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

### Workflow C — Textbook → Subsections → Prove a theorem

Use `scripts/preprocess_textbook.py` for textbooks (subsection-level splitting with theorem
detection and a master index).

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

### Workflow D — TeX source → Subsections → Prove a theorem

Use `scripts/preprocess_tex.py` when the TeX source is available (higher quality than PDF).

```bash
# Process all chapters
python3 scripts/preprocess_tex.py textbook/Bubeck15-arXiv-1405.4980v2/

# Or just one chapter
python3 scripts/preprocess_tex.py textbook/Bubeck15-arXiv-1405.4980v2/ --chapter 2

# Output: papers/Bubeck_convex_optimization/sections/*.md + index.md
```

Output structure mirrors Workflow C (same YAML front-matter, same index format).
Re-runs preserve existing `lean_files` status.

| Script | Output | Quality |
|--------|--------|---------|
| `preprocess_tex.py` | `papers/Bubeck_convex_optimization/` | Clean TeX (pandoc if available, else light-clean fallback) |

#### Inline definitions in Bubeck15

Many definitions in this book are stated in running prose rather than inside a `\begin{definition}` environment, so they do **not** appear in the `index.md` or the `theorems:` front-matter of section files.

**If a term used in a theorem statement is undefined**, look for it in the body of the same section file before concluding it is missing. Common patterns:
- "We say that $f$ is *L-smooth* if ..." (italicised term followed by condition)
- "A function is called *strongly convex* with parameter $\mu$ if ..."
- A numbered equation that serves as the defining condition

If still not found, check the section file for the preceding section (definitions often appear just before the theorem that uses them).

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
4. Create `proofs/<title>/TheoremName.lean` using the template below
5. Run `/lean4:autoprove` for autonomous proof search, or `/lean4:prove` to stay interactive
6. **Verify with `lake env lean proofs/<title>/TheoremName.lean`** after every edit — authoritative check
7. Run `/lean4:checkpoint` when done to verify build + axioms + commit
8. Append entry to `logs/proofs.log`
9. **Update index**: set the theorem's status to `proved` in `papers/<title>/index.md`
   (change `| pending |` → `| proved |` on the matching row)

> Tip: use `/prove-theorem "<ID>"` to run steps 2–9 automatically.

### Proof file template
```lean
-- IMPORTS: Start with the specific Optlib module needed.
-- Do NOT write `import Mathlib` — it forces the LSP to load the entire library (~10 min).
-- Instead add targeted Mathlib imports only for things optlib doesn't already re-export.
-- Use `import Mathlib` only temporarily during active lemma search, then trim.
set_option linter.unusedSectionVars false  -- suppress false positives from `variable` blocks

import Optlib.Convex.ConvexFunction   -- replace with the relevant Optlib module
-- import Mathlib.Analysis.Calculus.Deriv.Slope  -- add specific Mathlib imports as needed

-- [Theorem name from paper]
-- Source: papers/<title>/sections/NN_<section>.md
-- Informal statement: [paste from section file]
theorem TheoremName (hyp1 : ...) (hyp2 : ...) : conclusion := by
  sorry
```

### Import discipline
| Phase | Imports |
|-------|---------|
| Proof exploration (finding lemmas) | `import Mathlib` temporarily OK |
| Proof complete / being polished | Switch to specific imports |
| After trimming | Verify with `lake env lean` — no errors, no warnings |

To find which specific Mathlib module contains a lemma `Foo.bar`:
```bash
grep -r "theorem Foo.bar\|lemma Foo.bar" .lake/packages/mathlib/Mathlib --include="*.lean" -l
```

### Verification ladder — always use in this order

```bash
# 1. Per-file gate (ALWAYS use this — bypasses .olean cache, elaborates from source):
lake env lean proofs/<title>/TheoremName.lean

# 2. Project gate (after per-file passes — checks the whole build graph):
lake build

# NEVER rely solely on `lake build` to verify a single file.
# lake build skips files whose hash matches the cached .olean,
# so a freshly-edited file can appear to build while still having errors.
```

Also note: the LSP info view lags behind both commands — after editing a file,
always run `lake env lean <file>` rather than trusting the info view to be current.

### Agent rules — enforced for all lean4 agents

These rules apply to every `/lean4:autoprove`, `/lean4:prove`, sorry-filler, and proof-repair invocation:

1. **Verification command**: always run `lake env lean <file>` to confirm a proof compiles.
   Never claim success based on `lake build` alone — it can use stale `.olean` cache.

2. **Imports**: never write `import Mathlib` in the final file.
   Start from the relevant `Optlib.*` module and add specific `Mathlib.*` imports only as needed.
   `import Mathlib` is allowed temporarily during lemma search, but must be trimmed before declaring done.

3. **Module algebra**: never use `ring` for goals involving `•` (scalar multiplication) in a module.
   Use `simp [smul_sub, sub_smul, one_smul]` followed by `abel` instead.

4. **Filter notation**: `𝓝[≠]`, `𝓝[>]`, `𝓝` require `open Topology`.
   Always include `open Topology` when using neighbourhood filters.

5. **`HasGradientAt` vs `HasFDerivAt`**: optlib uses `HasGradientAt`; Mathlib chain-rule lemmas
   (`HasFDerivAt.comp_hasDerivAt`) expect `HasFDerivAt`. Convert with
   `rw [hasGradientAt_iff_hasFDerivAt] at h` and note the point must match syntactically.

6. **`IsMinOn`**: it is filter-based. Unfold with `rw [isMinOn_iff]` before introducing variables.

7. **Warning-free target**: a finished proof file must produce zero output from
   `lake env lean <file>` — no errors AND no warnings.

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
- Import specific Optlib submodules + targeted Mathlib modules (never bare `import Mathlib` in finished files)
- Add `set_option linter.unusedSectionVars false` when using `variable` blocks

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
