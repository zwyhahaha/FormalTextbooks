# Definition 1.4

[Bubeck Convex Optimization](../index.md) / [Chapter 1](../chapters/chapter-1.md) / [Section 1.2](../sections/section-1-2-basic-properties-of-convexity.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-proved">Proved</span>

**Roadmap context:** <span class="roadmap-pill roadmap-high">High</span> Lock down the foundational convex-analysis results so later optimization chapters can reuse standard wrappers instead of restating basic geometry.

## Informal Statement

**Definition** (Subgradients)

Let $\mathcal{X} \subset \R^n$, and $f : \mathcal{X} \rightarrow \R$. Then $g \in \R^n$ is a subgradient of $f$ at $x \in \mathcal{X}$ if for any $y \in \mathcal{X}$ one has

\[
f(x) - f(y) \leq g^{\top} (x - y) .
\]

The set of subgradients of $f$ at $x$ is denoted $\partial f (x)$.

To put it differently, for any $x \in \cX$ and $g \in \partial f(x)$, $f$ is above the linear function $y \mapsto f(x) + g^{\top} (y-x)$. The next result shows (essentially) that a convex functions always admit subgradients.

## Lean Formalization

Symbol: `definition_1_4_subgradient`

```lean
import Optlib.Convex.Subgradient

set_option linter.unusedSectionVars false

/-!
# Definition 1.4 — Subgradients

Source: papers/Bubeck_convex_optimization/sections/01_02_basic_properties_of_convexity.md

The book defines: given 𝒳 ⊆ ℝⁿ and f : 𝒳 → ℝ, a vector g ∈ ℝⁿ is a **subgradient**
of f at x ∈ 𝒳 if for every y ∈ 𝒳,

  f(x) − f(y) ≤ gᵀ(x − y)

Equivalently, f lies above the affine minorant y ↦ f(x) + gᵀ(y − x).

The set of all subgradients of f at x is denoted ∂f(x).

## Relationship to Optlib

Optlib's `HasSubgradientWithinAt f g s x` states exactly:
  ∀ y ∈ s, f y ≥ f x + ⟪g, y − x⟫

This is equivalent to the book's condition (negating both sides and noting
⟪g, x−y⟫ = −⟪g, y−x⟫).  The set `SubderivWithinAt f 𝒳 x` is ∂f(x).
-/

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]

local notation "⟪" x ", " y "⟫" => @inner ℝ _ _ x y

/-- **Definition 1.4** (Bubeck §1.2): g is a subgradient of f at x within 𝒳
(i.e. g ∈ ∂f(x)) iff for all y ∈ 𝒳, f(x) − f(y) ≤ ⟪g, x−y⟫.

This is equivalent to Optlib's `HasSubgradientWithinAt f g 𝒳 x`. -/
theorem definition_1_4_subgradient {f : E → ℝ} {g x : E} {𝒳 : Set E} :
    HasSubgradientWithinAt f g 𝒳 x ↔
    ∀ y ∈ 𝒳, f x - f y ≤ ⟪g, x - y⟫ := by
  unfold HasSubgradientWithinAt
  constructor
  · intro h y hy
    have hge := h y hy
    have hinner : ⟪g, x - y⟫ = -⟪g, y - x⟫ := by
      rw [← neg_sub, inner_neg_right]
    linarith
  · intro h y hy
    have hle := h y hy
    have hinner : ⟪g, x - y⟫ = -⟪g, y - x⟫ := by
      rw [← neg_sub, inner_neg_right]
    linarith

/-- The subdifferential ∂f(x) within 𝒳 is `SubderivWithinAt f 𝒳 x`. -/
theorem definition_1_4_subdifferential {f : E → ℝ} {x : E} {𝒳 : Set E} :
    SubderivWithinAt f 𝒳 x =
    {g : E | ∀ y ∈ 𝒳, f x - f y ≤ ⟪g, x - y⟫} := by
  ext g
  simp only [SubderivWithinAt, Set.mem_setOf_eq]
  exact definition_1_4_subgradient
```

## Metadata

| Field | Value |
|-------|-------|
| Display name | Subgradients |
| Proof file status | `present` |
| Tracker status | `proved` |
| Computed status | `proved` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Definition14.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Definition14.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/01_02_basic_properties_of_convexity.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/01_02_basic_properties_of_convexity.md) |

## Dependencies

- Reuse Mathlib separation theorems and Optlib subgradient lemmas before introducing bespoke wrappers.

## Chapter Blockers

- Statement alignment between the book's notation and Mathlib or Optlib wrappers still needs cleanup.

## Nearby Results

- Previous: [Definition 1.1](./definition-1-1.md)
- Next: [Proposition 1.5](./proposition-1-5.md)
