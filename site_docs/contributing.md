# Contributing and Status Rules

The docs site is generated from repository content under `papers/`, `proofs/`, and `docs/roadmaps/`.

## Updating the site locally

```bash
python3 scripts/generate_bubeck_docs.py --out site_docs/generated
mkdocs build
```

## Roadmap authoring

- Add `docs/roadmaps/<book>/book.yml` for book metadata.
- Add `docs/roadmaps/<book>/chapter-<n>.md` with YAML front matter and roadmap notes.
- Required chapter roadmap keys: `chapter`, `goal`, `priority`, `milestones`, `known_blockers`, `suggested_proof_order`.

## Status precedence

- `proved`: Lean file exists and contains no `sorry`.
- `partial`: Lean file exists and still contains at least one `sorry`.
- `failed`: Lean file is missing and the tracker explicitly marks the result as failed.
- `pending`: default state for everything else.

## Source-of-truth conventions

- Section ordering and theorem statements come from `papers/<book>/sections/*.md`.
- Lean file paths come from section front matter and the theorem index.
- Roadmap intent comes from `docs/roadmaps/<book>/chapter-*.md`.
