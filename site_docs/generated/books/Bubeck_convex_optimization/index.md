# Bubeck Convex Optimization

Formalization roadmap, theorem browser, and Lean proof inventory for Sebastien Bubeck's convex optimization text.

<div class="chip-row"><a class="chip-link active" href="../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

## Snapshot

<div class="metric-grid">
<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">14</span></div>
<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">4</span></div>
<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">43</span></div>
<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">61</span></div>
</div>

## [Browse Lean Source Inventory](source/chapter-1.md)

## Chapter Roadmaps

### [Chapter 1 — Introduction](chapters/chapter-1.md)

<span class="roadmap-pill roadmap-high">High</span> Lock down the foundational convex-analysis results so later optimization chapters can reuse standard wrappers instead of restating basic geometry.

- Results: 7
- Completed: 6 proved, 0 partial
- Open work: 1 pending, 0 failed

### [Chapter 2 — Convex optimization in finite dimension](chapters/chapter-2.md)

<span class="roadmap-pill roadmap-critical">Critical</span> Stabilize the finite-dimensional geometry chapter by isolating the deepest geometric gaps and sequencing the provable matrix lemmas around them.

- Results: 8
- Completed: 0 proved, 4 partial
- Open work: 4 pending, 0 failed

### [Chapter 3 — Dimension-free convex optimization](chapters/chapter-3.md)

<span class="roadmap-pill roadmap-high">High</span> Build a coherent first-order methods track that starts with gradient and subgradient methods, then expands toward strong convexity and acceleration.

- Results: 19
- Completed: 8 proved, 0 partial
- Open work: 11 pending, 0 failed

### [Chapter 4 — Almost dimension-free convex optimization in non-Euclidean spaces](chapters/chapter-4.md)

<span class="roadmap-pill roadmap-medium">Medium</span> Introduce mirror-descent-era abstractions only after the Chapter 3 first-order patterns are stable and reusable.

- Results: 4
- Completed: 0 proved, 0 partial
- Open work: 4 pending, 0 failed

### [Chapter 5 — Beyond the black-box model](chapters/chapter-5.md)

<span class="roadmap-pill roadmap-medium">Medium</span> Organize the chapter into reusable subtracks for proximal methods, saddle-point methods, and interior-point methods.

- Results: 9
- Completed: 0 proved, 0 partial
- Open work: 9 pending, 0 failed

### [Chapter 6 — Convex optimization and randomness](chapters/chapter-6.md)

<span class="roadmap-pill roadmap-low">Low</span> Queue the randomness chapter behind the deterministic optimization core while keeping its theorem inventory visible and searchable.

- Results: 14
- Completed: 0 proved, 0 partial
- Open work: 14 pending, 0 failed

## Lean Files

| Lean file | Chapter | Results | Status |
|-----------|---------|---------|--------|
| [proofs/Bubeck_convex_optimization/Definition11.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Definition11.lean) | 1 | Definition 1.1 | <span class="status-badge status-proved">Proved</span> |
| [proofs/Bubeck_convex_optimization/Definition14.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Definition14.lean) | 1 | Definition 1.4 | <span class="status-badge status-proved">Proved</span> |
| [proofs/Bubeck_convex_optimization/Proposition15.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Proposition15.lean) | 1 | Proposition 1.5 | <span class="status-badge status-proved">Proved</span> |
| [proofs/Bubeck_convex_optimization/Theorem12.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem12.lean) | 1 | Theorem 1.2 | <span class="status-badge status-proved">Proved</span> |
| [proofs/Bubeck_convex_optimization/Theorem13.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem13.lean) | 1 | Theorem 1.3 | <span class="status-badge status-pending">Pending</span> |
| [proofs/Bubeck_convex_optimization/Proposition16.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Proposition16.lean) | 1 | Proposition 1.6 | <span class="status-badge status-proved">Proved</span> |
| [proofs/Bubeck_convex_optimization/Proposition17.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Proposition17.lean) | 1 | Proposition 1.7 | <span class="status-badge status-proved">Proved</span> |
| [proofs/Bubeck_convex_optimization/Lemma22.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Lemma22.lean) | 2 | Lemma 2.2 | <span class="status-badge status-partial">Partial</span> |
| [proofs/Bubeck_convex_optimization/Theorem21.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem21.lean) | 2 | Theorem 2.1 | <span class="status-badge status-partial">Partial</span> |
| [proofs/Bubeck_convex_optimization/Lemma23.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Lemma23.lean) | 2 | Lemma 2.3 | <span class="status-badge status-partial">Partial</span> |
| [proofs/Bubeck_convex_optimization/Theorem24.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem24.lean) | 2 | Theorem 2.4 | <span class="status-badge status-pending">Pending</span> |
| [proofs/Bubeck_convex_optimization/Lemma25.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Lemma25.lean) | 2 | Lemma 2.5 | <span class="status-badge status-partial">Partial</span> |
