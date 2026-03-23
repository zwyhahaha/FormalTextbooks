---
chapter: 1
chapter_title: Introduction
goal: Lock down the foundational convex-analysis results so later optimization chapters can reuse standard wrappers instead of restating basic geometry.
priority: high
milestones:
  - title: Formalize the Chapter 1 convex-analysis core results
    status: done
  - title: Finish the supporting hyperplane wrapper and keep statements aligned with the book
    status: in-progress
  - title: Document theorem-to-library mappings for reusable imports
    status: planned
known_blockers:
  - Statement alignment between the book's notation and Mathlib or Optlib wrappers still needs cleanup.
suggested_proof_order:
  - Proposition 1.6
  - Proposition 1.7
  - Proposition 1.5
  - Theorem 1.3
  - Theorem 1.2
dependencies:
  - Reuse Mathlib separation theorems and Optlib subgradient lemmas before introducing bespoke wrappers.
---

Chapter 1 is the bridge between the source text and the reusable Lean vocabulary for the rest of the project. The main objective is to make every later chapter point back to stable convexity and optimality interfaces instead of repeating foundational setup.
