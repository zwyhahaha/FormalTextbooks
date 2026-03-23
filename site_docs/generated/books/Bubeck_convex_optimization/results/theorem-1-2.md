# Theorem 1.2

[Bubeck Convex Optimization](../index.md) / [Chapter 1](../chapters/chapter-1.md) / [Section 1.2](../sections/section-1-2-basic-properties-of-convexity.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-proved">Proved</span>

**Roadmap context:** <span class="roadmap-pill roadmap-high">High</span> Lock down the foundational convex-analysis results so later optimization chapters can reuse standard wrappers instead of restating basic geometry.

## Informal Statement

**Theorem** (Separation Theorem)

Let $\mathcal{X} \subset \R^n$ be a closed convex set, and $x_0 \in \R^n \setminus \mathcal{X}$. Then, there exists $w \in \R^n$ and $t \in \R$ such that

\[
w^{\top} x_0 < t, \; \text{and} \; \forall x \in \mathcal{X}, w^{\top} x \geq t.
\]

Note that if $\mathcal{X}$ is not closed then one can only guarantee that $w^{\top} x_0 \leq w^{\top} x, \forall x \in \mathcal{X}$ (and $w \neq 0$). This immediately implies the Supporting Hyperplane Theorem ($\partial \cX$ denotes the boundary of $\cX$, that is the closure without the interior):

## Lean Formalization

Symbol: `theorem_1_2_separation`

```lean
import Mathlib.Analysis.NormedSpace.HahnBanach.Separation

set_option linter.unusedSectionVars false

/-!
# Theorem 1.2 — Separation Theorem

Source: papers/Bubeck_convex_optimization/sections/01_02_basic_properties_of_convexity.md

Informal statement: Let 𝒳 ⊆ ℝⁿ be a closed convex set, and x₀ ∈ ℝⁿ \ 𝒳. Then there
exist w ∈ ℝⁿ and t ∈ ℝ such that
    wᵀx₀ < t  and  ∀ x ∈ 𝒳, wᵀx ≥ t.

## Relationship to Mathlib

Mathlib's `geometric_hahn_banach_point_closed` gives exactly this, with the "vector w"
playing the role of a separating continuous linear functional f : E →L[ℝ] ℝ.
(In finite dimensions E = ℝⁿ, every such functional is of the form ⟪w, ·⟫ via Riesz.)
-/

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- **Theorem 1.2** (Bubeck §1.2): Separation Theorem.
Let 𝒳 ⊆ E be a closed convex set and x₀ ∉ 𝒳. Then there exists a continuous linear
functional f : E →L[ℝ] ℝ and a threshold t ∈ ℝ such that f(x₀) < t and ∀ x ∈ 𝒳, t ≤ f(x).

In the book's terms (E = ℝⁿ): there exist w ∈ ℝⁿ and t ∈ ℝ such that wᵀx₀ < t
and ∀ x ∈ 𝒳, wᵀx ≥ t. -/
theorem theorem_1_2_separation {𝒳 : Set E} {x₀ : E}
    (hX : Convex ℝ 𝒳) (hXc : IsClosed 𝒳) (hx₀ : x₀ ∉ 𝒳) :
    ∃ (f : E →L[ℝ] ℝ) (t : ℝ), f x₀ < t ∧ ∀ x ∈ 𝒳, t ≤ f x := by
  obtain ⟨f, u, hlt, hge⟩ := geometric_hahn_banach_point_closed hX hXc hx₀
  exact ⟨f, u, hlt, fun x hx => le_of_lt (hge x hx)⟩
```

## Metadata

| Field | Value |
|-------|-------|
| Display name | Separation Theorem |
| Proof file status | `present` |
| Tracker status | `proved` |
| Computed status | `proved` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Theorem12.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem12.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/01_02_basic_properties_of_convexity.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/01_02_basic_properties_of_convexity.md) |

## Dependencies

- Reuse Mathlib separation theorems and Optlib subgradient lemmas before introducing bespoke wrappers.

## Chapter Blockers

- Statement alignment between the book's notation and Mathlib or Optlib wrappers still needs cleanup.

## Nearby Results

- Previous: [Proposition 1.5](./proposition-1-5.md)
- Next: [Theorem 1.3](./theorem-1-3.md)
