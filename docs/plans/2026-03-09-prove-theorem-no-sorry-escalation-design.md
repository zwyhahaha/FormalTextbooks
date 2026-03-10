# Design: prove-theorem zero-sorry escalation pipeline

**Date:** 2026-03-09
**Status:** Approved

## Problem

`prove-theorem` delegates to `lean4:autoprove` once and accepts whatever sorrys remain.
The expected result is a zero-sorry proof. When autoprove can't close a goal, there is
no escalation — the theorem lands as `partial` without further effort.

## Goal

Add a 3-tier escalation pipeline so that `prove-theorem` exhausts every available
strategy before accepting a sorry.

---

## Architecture

```
Step 5   → Tier 1: lean4:autoprove (existing)
               ↓ if any sorry remains
Step 5a  → Tier 2: quick search pass + second autoprove cycle (new)
               ↓ if any sorry remains
Step 5b  → Tier 3: prove-missing proof construction (new)
               ↓ always
Step 6   → post-proof bookkeeping (existing, unchanged)
```

The `proved` / `partial` / `failed` status determination in Step 6 happens after
whichever tier last ran. `prove-theorem` owns all post-proof work in every path.

---

## Tier 2: Quick search pass + second autoprove cycle (Step 5a)

**Trigger:** any sorry remains after Tier 1.

### 5a-i. Extract sorry goals
For each `sorry` in the lean file, run `lean_goal` at that line to capture the goal state.

### 5a-ii. Per-sorry search
For each sorry goal:
1. `lean_leansearch` — natural language query derived from the goal
2. `lean_loogle` — type pattern from the goal
3. `lean_leanfinder` — semantic description of what the step proves
4. `grep -r "<key term>" .lake/packages/optlib/Optlib/ --include="*.lean" -l`
5. List `proofs/<book>/`, read files with relevant names — collect importable theorem names + signatures

### 5a-iii. Build candidate map
```
Sorry N: <goal state>
  leansearch: [lemma1, lemma2]
  loogle: [lemma3]
  leanfinder: [lemma4]
  optlib: [module/file if found]
  best_candidate: <name> — reason: <why>
```

### 5a-iv. Second autoprove cycle
Invoke `lean4:autoprove` again with the original prompt **plus** the candidate map
appended. Autoprove now has concrete lemma names to try rather than searching from scratch.

---

## Tier 3: prove-missing proof construction (Step 5b)

**Trigger:** any sorry remains after Tier 2.

Execute the following inline (no separate skill invocation):

### 5b-i. Write informal proof (prove-missing Step 3)
Complete mathematical proof from Claude's knowledge. Every step spelled out —
no "clearly", no "by standard argument". Numbered steps.

### 5b-ii. WebSearch cross-check (prove-missing Step 3b)
8 targeted queries: theorem name, Lean 4 Mathlib, key lemma, GitHub, mathlib4,
optlib (madvorak), Zulip, ReasBook. Correct the informal proof if errors found.

### 5b-iii. Resolve all Mathlib gaps (prove-missing Step 3c)
For every step marked `Genuine Mathlib gap? yes`, write a sub-proof before proceeding.
Recurse until all leaves are confirmed Mathlib lemmas or elementary tactics.
No open gaps permitted before moving on.

### 5b-iv. Save informal proof file (prove-missing Step 4)
Write to `proofs/<book>/informal/<TheoremName>_informal.md` using the standard template.

### 5b-v. Per-step tactic search (prove-missing Step 5.5)
Run `lean_leansearch` + `lean_loogle` + `lean_leanfinder` for each step.
Build the full lemma map.

### 5b-vi. Invoke lean4:prove (not autoprove)
Use the Skill tool with the full informal proof + lemma map. `lean4:prove` works
cycle-by-cycle, ensuring every provable sub-goal is attempted before any sorry.

### Hand back to Step 6
`prove-theorem` resumes post-proof bookkeeping regardless of Tier 3 outcome.

---

## Changes to prove-theorem.md

- Steps 0–5 and 6–7: unchanged
- Insert Step 5a (Tier 2) and Step 5b (Tier 3) between existing Steps 5 and 6
- The prompt constructed in Step 4 gains a note: "sorry is only acceptable after
  the full escalation pipeline (Tiers 1–3) has run without resolving the goal"

## Non-changes

- `prove-missing.md`: unchanged — it remains the standalone command for theorems
  with no book proof
- Post-proof bookkeeping (status update, log entry, elapsed time): unchanged,
  always owned by `prove-theorem`
- `lean4:autoprove` and `lean4:prove` subskills: unchanged
