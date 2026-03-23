---
chapter: 2
chapter_title: Convex optimization in finite dimension
goal: Stabilize the finite-dimensional geometry chapter by isolating the deepest geometric gaps and sequencing the provable matrix lemmas around them.
priority: critical
milestones:
  - title: Separate the Grünbaum-style geometric gap from the arithmetic and cone lemmas
    status: in-progress
  - title: Formalize the ellipsoid and volumetric-barrier helper lemmas with explicit matrix dependencies
    status: planned
  - title: Recover theorem-level convergence results once the geometric bridge is available
    status: blocked
known_blockers:
  - Brunn-Minkowski slicing and cone-optimality arguments are still outside the current Mathlib surface area.
  - Several chapter theorems depend on measure-theoretic and matrix-analytic lemmas that are not yet factored into reusable modules.
suggested_proof_order:
  - Lemma 2.2
  - Theorem 2.1
  - Lemma 2.3
  - Theorem 2.4
  - Lemma 2.5
  - Lemma 2.8
  - Theorem 2.7
dependencies:
  - Chapter 2 depends on finite-dimensional measure lemmas and matrix identities not needed in Chapter 1.
---

This chapter is the first major proof-engineering bottleneck. The site should surface that distinction clearly: some files are already useful technical infrastructure, while the chapter-level convergence theorems remain gated on deeper geometric machinery.
