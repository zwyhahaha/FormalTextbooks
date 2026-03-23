---
chapter: 3
chapter_title: Dimension-free convex optimization
goal: Build a coherent first-order methods track that starts with gradient and subgradient methods, then expands toward strong convexity and acceleration.
priority: high
milestones:
  - title: Keep the gradient-descent wrappers and helper lemmas compiling cleanly
    status: done
  - title: Fill the missing strong-convexity and accelerated-method statements in dependency order
    status: in-progress
  - title: Expose the chapter as the main entry point for code-first browsing on the site
    status: planned
known_blockers:
  - Several later theorems depend on stronger reusable templates for accelerated arguments.
suggested_proof_order:
  - Lemma 3.1
  - Theorem 3.2
  - Theorem 3.3
  - Lemma 3.4
  - Lemma 3.5
  - Theorem 3.8
  - Theorem 3.9
  - Theorem 3.10
  - Theorem 3.18
dependencies:
  - Reuse Optlib gradient-descent interfaces wherever the book statement is only a wrapper around a stronger library theorem.
---

Chapter 3 is the most natural “code browser” chapter because it already contains several complete Lean files that map cleanly to textbook statements. The site should highlight this chapter as the quickest way to inspect the project’s formalization style.
