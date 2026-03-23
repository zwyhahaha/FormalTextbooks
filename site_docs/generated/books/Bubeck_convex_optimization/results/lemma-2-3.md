# Lemma 2.3

[Bubeck Convex Optimization](../index.md) / [Chapter 2](../chapters/chapter-2.md) / [Section 2.2](../sections/section-2-2-the-ellipsoid-method.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-partial">Partial</span>

**Roadmap context:** <span class="roadmap-pill roadmap-critical">Critical</span> Stabilize the finite-dimensional geometry chapter by isolating the deepest geometric gaps and sequencing the provable matrix lemmas around them.

## Informal Statement

**Lemma**

Let $\mathcal{E}_0 = \{x \in \R^n : (x - c_0)^{\top} H_0^{-1} (x-c_0) \leq 1 \}$. For any $w \in \R^n$, $w \neq 0$, there exists an ellipsoid $\mathcal{E}$ such that

\mathcal{E} \supset \{x \in \mathcal{E}_0 : w^{\top} (x-c_0) \leq 0\} , \label{eq:ellipsoidlemma1}

and 

\mathrm{vol}(\mathcal{E}) \leq \exp \left(- \frac{1}{2 n} \right) \mathrm{vol}(\mathcal{E}_0) . \label{eq:ellipsoidlemma2}

Furthermore for $n \geq 2$ one can take $\cE = \{x \in \R^n : (x - c)^{\top} H^{-1} (x-c) \leq 1 \}$ where

& c = c_0 - \frac{1}{n+1} \frac{H_0 w}{\sqrt{w^{\top} H_0 w}} , \label{eq:ellipsoidlemma3}\\
& H = \frac{n^2}{n^2-1} \left(H_0 - \frac{2}{n+1} \frac{H_0 w w^{\top} H_0}{w^{\top} H_0 w} \right) . \label{eq:ellipsoidlemma4}

## Lean Formalization

Symbol: `lemma_2_3_ellipsoid_geometric`

```lean
/-- **Lemma 2.3** (Bubeck §2.2, lem:geomellipsoid):
Ellipsoid Method Geometric Lemma.

For n ≥ 2 and any positive definite H₀ and nonzero w, the ellipsoid defined by the
explicit center c and shape matrix H (given by newCenter/newMatrix) satisfies:
- Containment: E ⊇ {x ∈ E₀ : wᵀ(x-c₀) ≤ 0}
- Volume reduction: vol(E) ≤ exp(-1/(2n)) · vol(E₀)

Status: containment and volume bound reduced to sorry'd auxiliary lemmas.
-/
theorem lemma_2_3_ellipsoid_geometric {n : ℕ}
    (c₀ : Fin n → ℝ) (H₀ : Matrix (Fin n) (Fin n) ℝ) (hH₀ : H₀.PosDef)
    (w : Fin n → ℝ) (hw : w ≠ 0) (hn : 2 ≤ n) :
    let E₀ := Ellipsoid c₀ H₀
    let E  := Ellipsoid (newCenter c₀ H₀ w) (newMatrix H₀ w)
    -- (1) Containment of the half-ellipsoid
    (∀ x ∈ E₀, dotProduct w (x - c₀) ≤ 0 → x ∈ E) ∧
    -- (2) Volume reduction: vol(E) ≤ exp(-1/(2n)) · vol(E₀)
    (∃ r : ℝ, 0 ≤ r ∧ r ≤ Real.exp (-(1 / (2 * (n : ℝ)))) ∧
      MeasureTheory.volume E ≤
        ENNReal.ofReal r * MeasureTheory.volume E₀) := by
  constructor
  · -- Part 1: containment (deferred to half_ellipsoid_contained)
    intro x hx_ell hx_half
    exact half_ellipsoid_contained hH₀ hw hn hx_ell hx_half
  · -- Part 2: volume bound (deferred to auxiliary lemmas)
    -- The volume ratio equals √(det H / det H₀) where det H / det H₀ is given by
    -- det_newMatrix_ratio, and √(that) ≤ exp(-1/(2n)) by det_ratio_vol_bound.
    -- Full measure-theoretic connection requires `addHaar_image_linearMap`.
    refine ⟨Real.exp (-(1 / (2 * (n : ℝ)))),
            Real.exp_nonneg _, le_refl _, ?_⟩
    sorry
    -- TODO: use addHaar_image_linearMap and the det ratio to compute vol(E)/vol(E₀)
    --       then apply det_ratio_vol_bound
```

## Metadata

| Field | Value |
|-------|-------|
| Display name | Lemma 2.3 |
| Proof file status | `present` |
| Tracker status | `pending` |
| Computed status | `partial` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Lemma23.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Lemma23.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/02_02_the_ellipsoid_method.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/02_02_the_ellipsoid_method.md) |

## Dependencies

- Chapter 2 depends on finite-dimensional measure lemmas and matrix identities not needed in Chapter 1.

## Chapter Blockers

- Brunn-Minkowski slicing and cone-optimality arguments are still outside the current Mathlib surface area.
- Several chapter theorems depend on measure-theoretic and matrix-analytic lemmas that are not yet factored into reusable modules.

## Nearby Results

- Previous: [Theorem 2.1](./theorem-2-1.md)
- Next: [Theorem 2.4](./theorem-2-4.md)
