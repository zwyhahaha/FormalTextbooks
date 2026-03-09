Look up a theorem by ID, write a complete informal proof from Claude's own
mathematical knowledge (WebSearch used only for verification), then formalize
it with lean4:prove. Use this for theorems whose proofs are missing from the
book (cited without proof).

> **Run autonomously.** Do not ask the user for confirmations, approvals,
> or plan reviews at any step. Proceed directly through all steps without pausing.

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

Parse the JSON output. If exit code is non-zero, stop and show the error.
Note the values: `book`, `theorem_id`, `theorem_name`, `section_file`,
`lean_file`, `example_proof_file`.

### 2. Build

Run:
```bash
lake exe cache get && lake build
```

If this fails, stop and report the build error.

### 3. Write the complete informal proof from scratch

Using the theorem statement from the section file, write a **complete mathematical proof**
from Claude's own knowledge. This is the primary proof authoring step — do NOT search the
web first.

Requirements for the proof:

**Completeness:** Every logical step must be spelled out. No "by standard argument",
"clearly", "it follows that", or "one can show". Write out every algebraic manipulation,
every inequality, every case split, every substitution.

**Self-contained:** Define every symbol used. If a proof invokes a named theorem
(Cauchy-Schwarz, Sherman-Morrison, AM-GM, etc.), state the form of that theorem being
used, with the specific instantiation for this proof.

**Structured:** Divide the proof into numbered steps. Each step proves exactly one claim.
Each step references only previously established claims or stated hypotheses.

**Level of detail:** Aim for the level of a graduate textbook proof, e.g. Rockafellar's
"Convex Analysis" or Boyd & Vandenberghe — not a research paper (too terse) and not a
first-year course (too verbose). Every step should be verifiable by a reader with a
standard analysis/linear algebra background.

**Do not use:** vague language like "similarly", "analogously", "by symmetry" — write
out the argument each time.

Save the proof as the "Claude-authored draft" section in the informal proof file
(Step 4 template below). Mark it `## Source: Claude (primary)`.

### 3b. WebSearch for cross-checking and supplementing

After writing the Claude-authored draft, run targeted searches to:
1. Verify the proof strategy matches the literature
2. Find if a Lean/Mathlib formalization already exists (skip to Step 6 if yes)
3. Identify any step where the Claude-authored proof might have an error

Run these queries (adjust theorem name):
1. `"<theorem_name> proof"` — look for alternative proofs or corrections
2. `"<theorem_name> Lean 4 Mathlib"` — check for existing formalization
3. `"<key lemma in proof> Mathlib"` — verify supporting lemmas exist

**Source priority for corrections only** (highest → lowest):
1. Existing Lean 4 / Mathlib formalizations → use directly, skip to Step 6
2. Textbook proofs (e.g. arXiv papers, lecture notes) → note discrepancies with Claude draft
3. Wikipedia → use only to check definitions, not proof strategy

If WebSearch reveals the Claude-authored proof has an error or gap, correct it in the draft.
If WebSearch confirms the proof is correct, add source citations under `## Sources`.
If no useful sources found, proceed with Claude-authored proof only — mark status `CLAUDE-AUTHORED`.

### 3c. Resolve all Mathlib gaps before proceeding

Scan every step in the informal proof for `Genuine Mathlib gap? yes`. For each such step,
you MUST write a sub-proof before moving on. Do NOT proceed to Step 4 until all gaps are resolved.

**Resolution process (per gap):**

1. Classify complexity:
   - **Short** (≤3 sub-steps): write the sub-proof inline under the parent step
     using the `### Sub-proof: <lemma name>` template below.
   - **Complex** (>3 sub-steps): create a separate file
     `proofs/<book>/informal/<LemmaName>_informal.md` and apply the full
     prove-missing workflow recursively to it.

2. After writing the sub-proof, check its steps for further gaps.
   Recurse until all leaves are one of:
   - A confirmed Mathlib lemma (found via lean_leansearch or lean_loogle)
   - An elementary lemma closeable by `norm_num`, `ring`, `linarith`, `omega`, `simp`, or `decide`
   - A genuine axiom (existence of Lebesgue measure, Fubini as primitive, etc.)
     — label these `-- AXIOM:` not `-- GAP:`

3. There is no depth limit. Recurse as deep as needed.

**Inline sub-proof template** (append under the parent Step N block):

~~~markdown
### Sub-proof: <missing lemma name>

**Statement:** <exact mathematical statement — a complete logical sentence>

**Proof:**

#### Sub-step 1: <title>
**Claim:** <precise mathematical statement>
**Proof of claim:** <complete argument — no "clearly" or "by standard argument">
**Lean tactic sketch:**
```lean
-- goal: <paste goal state>
<tactics>
```
**Remaining gaps:** none | [add another Sub-proof block below]

#### Sub-step 2: ...
~~~

**Gate:** You may NOT proceed to Step 4 until:
- Every `Genuine Mathlib gap? yes` has a completed sub-proof or a separate `_informal.md`
- No sub-proof leaf is unresolved (no open `Remaining gaps:` without a Sub-proof)

### 4. Save informal proof

Determine the output path:
```
INFORMAL_DIR="proofs/<book>/informal"
INFORMAL_FILE="$INFORMAL_DIR/<TheoremName>_informal.md"
```
(Use the `book` and `theorem_id` values from Step 1 to derive the filename,
e.g. `Lemma22_informal.md` for theorem_id `Lemma 2.2`.)

Write the file using this template — fill every field from the proof written in Step 3:

```markdown
# Informal Proof: <theorem_name>

## Source: Claude (primary)
This proof was written by Claude from mathematical knowledge.
WebSearch was used for cross-checking only (see Sources below).

## Sources
- [Source title](url)  ← from Step 3b, for verification only

## Theorem Statement
<Full formal statement: hypotheses, conclusion, all quantifiers.
Include types of all variables. Do not omit edge conditions.>

## Proof

<The complete proof written in Step 3. This is the FULL text of the proof,
not a list of steps — write it as flowing mathematical prose with equations,
divided into numbered steps only where the logical structure requires it.>

### Step N: <Title of this proof segment>

**Claim:** <The precise mathematical statement being proved in this step.
Must be a complete logical sentence — not just a label.>

**Proof of claim:** <Complete self-contained argument. Write every algebraic
manipulation, every inequality application, every case split. Do not write
"by standard argument" or "clearly". Every step must follow from what came before
or from a named theorem/hypothesis.>

**Named theorems used:** <List each external result invoked: name, statement
(the exact form used here, not the general form), reference if known.>

**Lean lemma search** (run lean_leansearch + lean_loogle in Step 5.5):
- Candidate 1: `<lemma name>` — proves `<what>`
- Candidate 2: `<lemma name>` — proves `<what>`
- Candidate 3: `<lemma name>` — proves `<what>`

**Lean tactic sketch:**
```lean
-- goal: <paste goal state here>
<write the tactic block: intro/apply/have/rw/simp/ring/linarith/omega/exact>
-- use `_` only for sub-goals that require a separate named lemma not yet found
```

**Genuine Mathlib gap?** yes/no
<If yes: do NOT write sorry here. You must complete Step 3c for this step before
proceeding. Write the sub-proof inline below using the Sub-proof template, or flag
it for a separate _informal.md file if >3 sub-steps. Only after the sub-proof is
written should you confirm this as a gap — and even then, sorry is a last resort
after 2+ recursive levels of failure.>

---

## Mathlib Gaps

Gaps listed here must each have a completed Sub-proof block (from Step 3c) or a separate `_informal.md`.
For each gap: name it, state what theorem is missing, show search evidence, and link to the sub-proof.

- **Gap: <name>**
  - Missing theorem: <what it says mathematically>
  - lean_leansearch("<query 1>") → <result>
  - lean_loogle("<pattern>") → <result>
  - Sub-proof: [inline below] | [see `proofs/<book>/informal/<LemmaName>_informal.md`]

## Status
CLAUDE-AUTHORED COMPLETE — all steps proved, gaps confirmed with search
CLAUDE-AUTHORED PARTIAL — some genuine Mathlib gaps remain, all documented
NOT FOUND — Claude could not construct a proof; manual input needed
```

If no proof could be generated (Status = NOT FOUND):
- Save the minimal file with the Status line only
- Skip Steps 5–7
- Jump to Step 8 with status = `failed`

### 5. Read example proof

Read the file at `example_proof_file` from the lookup JSON for style reference:
- Which Optlib and Mathlib modules are imported
- How the `variable` block is structured
- How `open` statements are used
- Overall theorem structure

### 5.5. Per-step tactic search

For **each step** in the informal proof `_informal.md`, perform:

1. **Run lean_leansearch** with the step's key mathematical claim.
   Record the top-3 results (name + type signature).

2. **Run lean_loogle** with the type pattern of the key lemma needed.
   Record the top-3 results.

3. **Run lean_leanfinder** with a description of what the step proves.
   Record the top-2 results.

4. Collect results into a "Per-step lemma map":
   ```
   Step N: <title>
     leansearch: [lemma1, lemma2, lemma3]
     loogle: [lemma4, lemma5]
     leanfinder: [lemma6, lemma7]
     best_candidate: <lemma name> — reason: <why this is the best match>
   ```

5. For steps where NO candidate is found after all 3 searches: mark as
   `CONFIRMED GAP: <search queries run>`.

This lemma map is passed to prove in Step 6.

### 6. Construct autoprove prompt

Build the following prompt (fill `<...>` from lookup JSON and the informal proof):

```
Formalize <theorem_id> (<theorem_name>) from:
    <section_file>

## Theorem statement
<theorem_statement>

## Informal proof (source: <INFORMAL_FILE>)
<paste full contents of _informal.md here>

## Per-step lemma map (from Step 5.5)
<paste the full per-step lemma map here>

## Instructions

Work through each step of the informal proof. For each step:

### A. Try the lemma candidates first
Use the best_candidate from the lemma map. Test with lean_multi_attempt:
  - Try `exact <candidate>` or `apply <candidate>`
  - Try `simp only [<candidate>]`
  - Try `rw [<candidate>]`
Record which tactic, if any, closes the goal.

### B. If candidates fail, search further
Run lean_leanfinder with the current goal state (copy from lean_goal).
Run lean_leansearch with the mathematical claim in plain English.
Run lean_loogle with the type pattern of the needed lemma.
Try lean_multi_attempt with 3-5 new candidates.

### C. Build incrementally with `have`
Break complex goals into sub-goals using `have h : <sub-claim> := by ...`.
A tactic block that proves 3 out of 4 sub-goals is better than one sorry.

### D. sorry is permitted ONLY under all three conditions

A sorry is acceptable ONLY if ALL of the following hold:
  1. The step's sub-proof (written in Step 3c) has been recursed 2+ levels deep AND
     lean_leansearch + lean_loogle both returned no results at each level, AND
  2. The claim is either:
     (a) Elementary — it would close with `norm_num`, `ring`, `linarith`, or `omega`
         once the right syntactic form is found, OR
     (b) A genuine axiom (Lebesgue measure existence, Fubini as primitive, etc.)
  3. You label it `-- AXIOM: <what it asserts>` (for axioms) or leave no `-- GAP:` comment
     at all (for elementary bookkeeping that will close with a tactic search).

**Explicitly forbidden:**
- `-- GAP:` comments unless 2+ recursive sub-proof levels have been written and failed
- The pattern: "not in Mathlib → sorry" without a completed sub-proof in Step 3c
- Marking a step as CONFIRMED GAP without first attempting to prove it from scratch

### E. Never sorry structural steps
Steps that are pure Lean bookkeeping (intro, apply, simp with existing lemmas,
ring, omega, linarith, field_simp, norm_num) must NOT use sorry. Always attempt them.

## Style
- See <example_proof_file> for import and variable block style
- Use targeted imports (not `import Mathlib`)
- A sorry for an axiom must have `-- AXIOM: <what it asserts>`; never use `-- GAP:` without 2+ recursive sub-proof levels
- Run `lake env lean <file>` to verify before declaring done
```

### 7. Invoke prove (interactive)

Use the Skill tool to invoke `lean4:prove` with the prompt from Step 6.

Rationale: `lean4:autoprove` is optimized for speed and accepts sorry quickly.
For theorems with missing proofs, `lean4:prove` works cycle-by-cycle with explicit
checkpoints at each tactic, ensuring every provable sub-goal is attempted.

If `lean4:prove` exceeds 20 cycles without completing, switch to `lean4:autoprove`
with the SAME prompt (not the original one — include the lemma map).

### 8. Post-proof

**If status = `proved` (no sorrys):**
```bash
ELAPSED=$(python3 -c "import time; e=int(time.time()-$PROVE_START); print(f'{e//60}m {e%60}s')")
python3 scripts/update_theorem_status.py "$ARGUMENTS" proved --time "$ELAPSED"
```

**If status = `partial` (sorrys remain for Mathlib gaps):**
```bash
python3 scripts/update_theorem_status.py "$ARGUMENTS" partial
```

**If status = `failed` (proof not found or prove failed):**
```bash
python3 scripts/update_theorem_status.py "$ARGUMENTS" failed
```

Append an entry to `logs/proofs.log`:
```python
import json, datetime
entry = {
  "ts": datetime.datetime.now().isoformat(timespec="seconds"),
  "event": "proof_session",
  "source": "<section_file>",
  "theorem": "<theorem_id>",
  "lean_file": "<lean_file>",
  "informal_proof_file": "<INFORMAL_FILE>",
  "status": "<proved|partial|failed>",
  "notes": "<brief description: sources used, Mathlib gaps found>"
}
with open("logs/proofs.log", "a") as f:
    f.write(json.dumps(entry) + "\n")
```

### 9. Report

Summarise:
- Theorem proved/attempted
- Informal proof file created (path + status)
- Lean file created/updated
- Updated status in index.md
- Mathlib gaps identified (if any)
- Any notable lemmas or techniques used
