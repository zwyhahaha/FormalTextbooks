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
| `lean-lsp-mcp` (`lean_goal`) | Check current proof state at cursor |
| `lean-lsp-mcp` (`lean_diagnostic_messages`) | See all errors/warnings in a file |
| `lean_loogle` | Search by type signature (e.g. `Real.sqrt → ...`) |
| `lean_leansearch` | Natural language search ("gradient Lipschitz") |
| `lean_leanfinder` | Semantic lemma search for a proof goal |
| `lean_multi_attempt` | Try multiple tactics, pick the first that works |

## Key Libraries
- **Optlib**: convex functions, subgradients, L-smooth functions, gradient descent convergence,
  proximal operators, KKT conditions, ADMM — see `.lake/packages/optlib/Optlib/` for module structure
- **Mathlib**: analysis, topology, linear algebra foundations

## File Conventions
- One theorem per `.lean` file in `proofs/<paper-title>/`
- Name files after the theorem (e.g., `GradientDescentConvergence.lean`)
- Always import `Mathlib` and `Optlib` at top

## Common Pitfalls
- lean-lsp-mcp will timeout if `lake build` hasn't run — always build first
- optlib uses Lean 4.13.0 syntax; don't upgrade lean-toolchain without checking optlib compat
- `lake exe cache get` must run after `lake update` to avoid recompiling mathlib from scratch
- marker_single CLI may not be on PATH; the preprocessing script handles this automatically
