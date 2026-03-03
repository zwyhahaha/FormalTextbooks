Look up a theorem by ID, generate a structured informal proof via WebSearch,
then formalize it with lean4:autoprove. Use this for theorems whose proofs
are missing from the book (cited without proof).

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

### 3. WebSearch for informal proof

Run the following queries in sequence, stopping early if a high-quality
proof is found (e.g., an existing Lean/Mathlib formalization):

1. `"<theorem_name> proof"` — direct search for classical proof
2. `"<theorem_name> convex geometry proof sketch"` — broaden if sparse
3. `"<theorem_name> Lean 4 Mathlib formalization"` — check if already done
4. `"<key mathematical ingredient> Mathlib"` — verify supporting lemmas
5. `"<theorem_name> lecture notes"` — fallback for pedagogical write-ups

**Source priority** (highest → lowest):
1. Existing Lean 4 / Mathlib formalizations → use directly, skip to Step 6
2. Wikipedia
3. arXiv lecture notes / survey papers
4. Math StackExchange

If no useful sources are found after all 5 queries, proceed with Claude's
own mathematical knowledge and flag the result as CLAUDE-GENERATED.

### 4. Synthesize and save informal proof

Determine the output path:
```
INFORMAL_DIR="proofs/<book>/informal"
INFORMAL_FILE="$INFORMAL_DIR/<TheoremName>_informal.md"
```
(Use the `book` and `theorem_id` values from Step 1 to derive the filename,
e.g. `Lemma22_informal.md` for theorem_id `Lemma 2.2`.)

Write the file using this template — fill every field from the sources found:

```markdown
# Informal Proof: <theorem_name>

## Sources
- [Source title](url)

## Theorem Statement
<Full statement in plain English + math notation>

## Proof Steps

### Step N: <Title>

**English:** <Full sentence explanation of what this step does and why.>

**Math:** <The key equation or inequality being established, with symbols.>

**Lean/Mathlib hint:** <Candidate lemma names or search terms for lean_leansearch>

**Sorry prediction:** yes/no — yes if this step needs `sorry` due to missing Mathlib lemma

## Mathlib Gaps
- <Lemma description>: not found in Mathlib 4.x (search confirmed)

## Status
PROOF FOUND | CLAUDE-GENERATED (unverified) | PROOF NOT FOUND — manual input needed
```

If no proof could be generated (Status = PROOF NOT FOUND):
- Save the minimal file with the Status line only
- Skip Steps 5–7
- Jump to Step 8 with status = `failed`

### 5. Read example proof

Read the file at `example_proof_file` from the lookup JSON for style reference:
- Which Optlib and Mathlib modules are imported
- How the `variable` block is structured
- How `open` statements are used
- Overall theorem structure

### 6. Construct autoprove prompt

Build the following prompt (fill `<...>` from lookup JSON and the informal proof):

```
Formalize <theorem_id> (<theorem_name>) from:
    <section_file>

The statement is:
<theorem_statement>

Informal proof (from <INFORMAL_FILE>):
<paste full contents of _informal.md here>

Steps:
1. Work through the informal proof steps in order. For each step:
   a. Translate the Math field into a Lean sub-goal or intermediate lemma.
   b. Use the Lean/Mathlib hint to search with lean_leanfinder / lean_leansearch.
   c. If Sorry prediction = yes, place `sorry` with a comment:
      -- TODO: needs <hint> — not yet in Mathlib
      and continue to the next step.
2. Search for relevant lemmas in this order:
   a. Previously proved theorems in proofs/<book>/ — list the directory,
      read relevant files, note theorem names and signatures.
      Import with: import proofs.<book>.<FileName>
   b. Optlib (.lake/packages/optlib/Optlib/) — key modules:
      Optlib/Convex/Subgradient.lean, ConvexFunction.lean
   c. Mathlib — search with lean_leanfinder / lean_leansearch
3. See <example_proof_file> for expected style.
4. Create/update <lean_file> implementing the proof.
5. Run /lean4:checkpoint when the proof compiles (even with sorrys).
6. Do NOT update index.md or logs/proofs.log — prove-missing handles that.
```

### 7. Invoke autoprove

Use the Skill tool to invoke `lean4:autoprove` with the prompt from Step 6.

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

**If status = `failed` (proof not found or autoprove failed):**
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
