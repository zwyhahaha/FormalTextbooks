Look up and autoprove a theorem by ID from the project's index, then update status and log.

> **Run fully autonomously. NEVER pause for any manual approval, confirmation, plan review,
> or permission at any step — including subskill invocations (lean4:autoprove, lean4:prove,
> lean4:checkpoint). Proceed directly through all steps without stopping.**

## Steps

### 0. Record start time

```bash
PROVE_START=$(python3 -c "import time; print(time.time())")
```

### 1. Lookup

Run:
```bash
python3 scripts/lookup_theorem.py "$ARGUMENTS"
```

Parse the JSON output. If exit code is non-zero, stop and show the error message.

### 2. Build

Run:
```bash
lake exe cache get && lake build
```

If this fails, stop and report the build error.

### 3. Read example proof

Read the file at `example_proof_file` from the JSON for style reference — pay attention to:
- Which Optlib and Mathlib modules are imported
- How the `variable` block is structured
- How `open` statements are used
- The overall theorem structure

### 4. Construct autoprove prompt

Using the values from the lookup JSON, build the following prompt (fill in `<...>` placeholders):

```
Formalize <theorem_id> (<theorem_name>) from:
    <section_file>

The statement is:
<theorem_statement>

Proof hint from the book:
<proof_hint>

Steps:
1. Search for relevant lemmas before writing anything. Check in this order:
   a. Previously proved theorems in proofs/<book>/ — list the directory,
      read any files whose name suggests relevance, note the Lean theorem
      names and their signatures. These can be imported directly:
        import proofs.<book>.<FileName>   -- e.g. import proofs.Bubeck_convex_optimization.Theorem12
      (The project's lakefile has srcDir := "." so all proofs/ files are
      importable by their path; no lakefile change needed to import them.)
   b. Optlib (.lake/packages/optlib/Optlib/) — key modules:
        Optlib/Convex/Subgradient.lean, ConvexFunction.lean
   c. ReasBook (https://optpku.github.io/ReasBook/) — WebSearch `site:optpku.github.io/ReasBook "<theorem_name>"` for proofs or formalizations
   d. Mathlib — search with lean_leanfinder / lean_leansearch
2. See <example_proof_file> for the expected style (imports, variable
   block, open statements, theorem structure).
3. Create <lean_file> as a wrapper theorem that states the result in the
   book's terms and delegates to optlib/mathlib/previously-proved lemmas.
4. Use lean4:autoprove to fill the proof.
5. Run /lean4:checkpoint when the proof compiles without sorry.
6. Do NOT update index.md or logs/proofs.log — the /prove-theorem command
   handles that automatically after autoprove returns.
7. sorry is only acceptable after the full escalation pipeline has run:
   - Tier 1 (this autoprove pass) failed to close the goal, AND
   - Tier 2 (quick search + second autoprove, run by /prove-theorem) failed, AND
   - Tier 3 (informal proof + lean4:prove, run by /prove-theorem) failed.
   Do NOT add sorry speculatively. Leave goals open with `_` placeholders
   if you cannot close them — /prove-theorem will escalate.
```

### 5. Invoke autoprove

Use the Skill tool to invoke `lean4:autoprove` with the prompt constructed in step 4.

### 5a. Tier 2 — Quick search pass (if any sorry remains after Step 5)

Skip this step if autoprove finished with zero sorrys.

#### 5a-i. Extract sorry goals

For each `sorry` remaining in `<lean_file>`, run `lean_goal` at that line
to capture the exact goal state.

#### 5a-ii. Per-sorry search

For each sorry goal, run all of the following:

1. `lean_leansearch` — natural language query derived from the goal
2. `lean_loogle` — type pattern derived from the goal
3. `lean_leanfinder` — semantic description of what the step proves
4. Local optlib scan:
   ```bash
   grep -r "<key term from goal>" .lake/packages/optlib/Optlib/ --include="*.lean" -l
   ```
5. Previously proved theorems — list `proofs/<book>/`, read files whose names suggest
   relevance, note Lean theorem names and signatures (importable as
   `import proofs.<book>.<FileName>`).

#### 5a-iii. Build candidate map

Assemble results into this format for each sorry:

```
Sorry N: <goal state>
  leansearch: [lemma1, lemma2]
  loogle: [lemma3]
  leanfinder: [lemma4]
  optlib: [module/file if found, else "none"]
  proofs/: [importable theorem name + signature if found, else "none"]
  best_candidate: <name> — reason: <why this is the best match>
```

#### 5a-iv. Second autoprove cycle

Invoke `lean4:autoprove` using the Skill tool with this prompt:

```
<original prompt from Step 4, verbatim>

## Tier 2 candidate map (from /prove-theorem quick search pass)

<paste the full candidate map from 5a-iii here>

For each sorry, try the best_candidate first (exact/apply/simp only/rw).
Use lean_multi_attempt to test candidates quickly. Only use sorry if
BOTH the candidate and 2 fallback attempts fail.
```

### 5b. Tier 3 — prove-missing proof construction (if any sorry remains after Step 5a)

Skip this step if Step 5a finished with zero sorrys.

Execute the following inline — do NOT invoke `/prove-missing` as a skill.
`prove-theorem` retains control of all post-proof bookkeeping (Step 6).

#### 5b-i. Write informal proof (prove-missing Step 3)

Write a **complete mathematical proof** from Claude's own knowledge using the
theorem statement from `<section_file>`.

Requirements:
- Every logical step spelled out — no "clearly", "by standard argument", "it follows"
- Every algebraic manipulation, inequality, case split written out explicitly
- Numbered steps; each step proves exactly one claim
- Every symbol defined; every named theorem (Cauchy-Schwarz, AM-GM, etc.) stated
  in the specific form used here
- Graduate textbook level (Rockafellar / Boyd–Vandenberghe)

#### 5b-ii. WebSearch cross-check (prove-missing Step 3b)

Run these 8 queries (adjust `<theorem_name>` and `<key_lemma>`):
1. `"<theorem_name> proof"`
2. `"<theorem_name> Lean 4 Mathlib"`
3. `"<key_lemma> Mathlib"`
4. `site:github.com "<theorem_name>" lean`
5. `site:github.com/leanprover-community/mathlib4 "<theorem_name>"`
6. `site:github.com/madvorak/optlib "<theorem_name>"`
7. `"<theorem_name>" site:loogle.lean-lang.org OR site:leanprover.zulipchat.com`
8. `site:optpku.github.io/ReasBook "<theorem_name>"`

If a Lean/Mathlib formalization is found, import it and skip to Step 5b-vi.
If the informal proof has errors, correct them before continuing.

#### 5b-iii. Resolve all Mathlib gaps (prove-missing Step 3c)

Scan every step for `Genuine Mathlib gap? yes`. For each:
- **Short** (≤3 sub-steps): write sub-proof inline using the Sub-proof template
  from `prove-missing`
- **Complex** (>3 sub-steps): create
  `proofs/<book>/informal/<LemmaName>_informal.md` and apply the
  prove-missing workflow recursively

**Gate:** Do NOT proceed to 5b-iv until every gap has a completed sub-proof
or a separate `_informal.md`. Recurse as deep as needed.

#### 5b-iv. Save informal proof file (prove-missing Step 4)

Write to `proofs/<book>/informal/<TheoremName>_informal.md` using the
standard template from `prove-missing` Step 4. Fill every field.

#### 5b-v. Per-step tactic search (prove-missing Step 5.5)

For each step in the informal proof:
1. `lean_leansearch` — key mathematical claim; record top-3 results
2. `lean_loogle` — type pattern of the needed lemma; record top-3 results
3. `lean_leanfinder` — description of what the step proves; record top-2 results

Collect into a lemma map:
```
Step N: <title>
  leansearch: [lemma1, lemma2, lemma3]
  loogle: [lemma4, lemma5]
  leanfinder: [lemma6, lemma7]
  best_candidate: <lemma name> — reason: <why>
```
Steps with no candidate after all 3 searches: mark `CONFIRMED GAP: <queries run>`.

#### 5b-vi. Invoke lean4:prove (not autoprove)

Use the Skill tool to invoke `lean4:prove` with this prompt:

```
Formalize <theorem_id> (<theorem_name>) from:
    <section_file>

## Theorem statement
<theorem_statement>

## Informal proof (source: proofs/<book>/informal/<TheoremName>_informal.md)
<paste full contents of _informal.md>

## Per-step lemma map (from Step 5b-v)
<paste full lemma map>

## Instructions
Work through each step of the informal proof. For each step:
A. Try best_candidate first (exact/apply/simp only/rw) via lean_multi_attempt.
B. If it fails, run lean_leanfinder with the current goal state, then
   lean_leansearch and lean_loogle; try 3-5 new candidates.
C. Build incrementally with `have`. 3 of 4 sub-goals proved is better than sorry.
D. sorry only if: 2+ recursive sub-proof levels written AND both leansearch +
   loogle returned nothing at each level AND claim is elementary or a genuine axiom.
   Label axioms `-- AXIOM: <what it asserts>`.
E. Never sorry structural steps (intro, apply, simp with existing lemmas,
   ring, omega, linarith, field_simp, norm_num).

Do NOT update index.md or logs/proofs.log.
Run lean4:checkpoint when proof compiles without sorry.
```

Hand back to Step 6 when `lean4:prove` finishes (proved, partial, or failed).

### 6. Post-proof (only if autoprove finishes with status `proved`)

a. Run:
```bash
ELAPSED=$(python3 -c "import time; e=int(time.time()-$PROVE_START); print(f'{e//60}m {e%60}s')")
python3 scripts/update_theorem_status.py "$ARGUMENTS" proved --time "$ELAPSED"
```

b. Append an entry to `logs/proofs.log` using the Python one-liner from CLAUDE.md,
   filling in fields from the lookup JSON:
   - `source`: value of `section_file`
   - `theorem`: value of `theorem_id`
   - `lean_file`: value of `lean_file`
   - `status`: `"proved"`
   - `notes`: brief description of what lemmas were used

If autoprove finishes with `partial` or `failed`, run:
```bash
python3 scripts/update_theorem_status.py "$ARGUMENTS" partial
```
(or `failed` as appropriate) and log accordingly.

### 7. Report

Summarise:
- Which theorem was proved
- Which Lean file was created/updated
- Updated status in index.md
- Any notable lemmas or techniques used
