---
chapter: 4
chapter_title: Almost dimension-free convex optimization in non-Euclidean spaces
goal: Introduce mirror-descent-era abstractions only after the Chapter 3 first-order patterns are stable and reusable.
priority: medium
milestones:
  - title: Define the mirror-map and mirror-descent API surface clearly
    status: planned
  - title: Formalize the first mirror-map lemma as a reusable primitive
    status: planned
  - title: Stage lazy mirror descent and mirror prox on top of shared notation
    status: planned
known_blockers:
  - The project still needs a stable abstraction boundary for mirror maps and Bregman-style arguments.
suggested_proof_order:
  - Lemma 4.1
  - Theorem 4.2
  - Theorem 4.3
  - Theorem 4.4
dependencies:
  - Chapter 4 should reuse notation and convergence templates that are established in Chapter 3.
---

This chapter should read on the site like a queued roadmap rather than an active blocker: the main value is to show what comes next after the Euclidean first-order core is complete.
