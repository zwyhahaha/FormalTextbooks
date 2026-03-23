# Lemma 2.5

[Bubeck Convex Optimization](../index.md) / [Chapter 2](../chapters/chapter-2.md) / [Section 2.3.4](../sections/section-2-3-4-constraints-and-the-volumetric-barrier.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-partial">Partial</span>

**Roadmap context:** <span class="roadmap-pill roadmap-critical">Critical</span> Stabilize the finite-dimensional geometry chapter by isolating the deepest geometric gaps and sequencing the provable matrix lemmas around them.

## Informal Statement

**Lemma**

One has for any $i \in [m+1]$,

\[
\frac{\tilde{\sigma}_{m+1}(x)}{1 - \tilde{\sigma}_{m+1}(x)} \geq \sigma_i(x) \geq \tilde{\sigma}_i(x) \geq (1-\sigma_{m+1}(x)) \sigma_i(x) .
\]

## Lean Formalization

Symbol: `lemma_2_5_leverage_score_comparison`

```lean
import Mathlib.LinearAlgebra.Matrix.PosDef
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse

set_option linter.unusedSectionVars false

/-!
# Lemma 2.5 — Leverage Score Inequality Under Constraint Addition (Bubeck §2.3.4)

Source: papers/Bubeck_convex_optimization/sections/02_03_04_constraints_and_the_volumetric_barrier.md

**Context:** Vaidya's cutting-plane method. The logarithmic barrier of the polytope
{x : Ax > b} has Hessian H = ∇²F(x) = ∑ᵢ aᵢaᵢᵀ/(aᵢᵀx-bᵢ)² (positive definite).
Leverage score of constraint i:  σᵢ = H⁻¹[aᵢ,aᵢ] / (aᵢᵀx-bᵢ)²,  where  H⁻¹[u,v] = uᵀH⁻¹v.

Adding constraint (c,β) gives H̃ = H + ccᵀ/s² (s = cᵀx-β > 0), with scores σ̃ᵢ via H̃⁻¹.

**Statement (informal):** For any i ∈ [m+1]:
  σ̃_{m+1} / (1 - σ̃_{m+1})  ≥  σᵢ  ≥  σ̃ᵢ  ≥  (1 - σ_{m+1}) · σᵢ

**Proof sketch (Sherman-Morrison + PSD inequalities):**

Let A = H⁻¹, u = c/s.  By Sherman-Morrison (applied to H + uu'·s²):
  H̃⁻¹ = A - AuuᵀA / (1 + A[u,u])            ... (SM)

**σᵢ ≥ σ̃ᵢ:** SM subtracts a PSD rank-1 term → H̃⁻¹ ≼ H⁻¹ → σ̃ᵢ ≤ σᵢ.

**σ̃ᵢ ≥ (1-σ_{m+1})σᵢ:** PSD inequality: A - AuuᵀA/(1+A[u,u]) ≽ (1-A[u,u])A.
  With A[u,u] = H⁻¹[c,c]/s² = σ_{m+1}: H̃⁻¹ ≽ (1-σ_{m+1}) H⁻¹.
  Proof: need (1+α)α A ≽ Auu'A, i.e. for any v: (1+α)α(vᵀAv)(uᵀAu) ≥ (vᵀAu)².
  By Cauchy-Schwarz for A: (vᵀAu)² ≤ (vᵀAv)(uᵀAu), so (1+α)α A[u,u] ≥ α² + α > (vᵀAu)²/A[v,v]. ✓

**σ̃_{m+1}/(1-σ̃_{m+1}) ≥ σᵢ:** Apply reverse SM: H⁻¹ = H̃⁻¹ + H̃⁻¹cc'H̃⁻¹/(s²-H̃⁻¹[c,c]).
  PSD inequality: B + Bvv'B/(1+B[v,v]) ≼ (1/(1-B[v,v]))B with B = H̃⁻¹, v = c/s:
  H⁻¹ ≼ (1/(1-σ̃_{m+1})) H̃⁻¹ → σᵢ ≤ (1/(1-σ̃_{m+1})) σ̃_{m+1}. ✓

**Key Mathlib lemmas available:**
- `Matrix.add_mul_mul_inv_eq_sub` — Woodbury/Sherman-Morrison identity
- `Matrix.PosDef`, `Matrix.PosSemidef` — PSD matrix types
- `LinearMap.BilinForm.apply_sq_le_of_symm` — Cauchy-Schwarz for bilinear forms

**Status:** Accepted as `sorry`. The proof is purely algebraic, requiring careful
bookkeeping of PSD matrix inequalities derived from Sherman-Morrison.
-/

open Matrix

variable {n : ℕ}

/-! ## Auxiliary PSD inequality for rank-1 updates -/

/-- If A is a PSD bilinear form on ℝⁿ and u is any vector with A[u,u] < 1, then
  A - AuuᵀA/(1 + A[u,u])  ≽  (1 - A[u,u]) · A
i.e., `(A[u,u] · A - AuuᵀA / (1+A[u,u])).PosSemidef`.

**Proof:** For any vector v, need
  (1 + A[u,u]) · A[u,u] · A[v,v]  ≥  (vᵀAu)²
This follows from (vᵀAu)² ≤ A[v,v]·A[u,u] (Cauchy-Schwarz for PSD bilinear form A)
and (1 + A[u,u]) · A[u,u] · A[v,v] ≥ A[u,u] · A[v,v] ≥ (vᵀAu)². -/
lemma posSemidef_rankOne_PSD_lower_bound
    {A : Matrix (Fin n) (Fin n) ℝ} (hA : A.PosSemidef)
    (u : Fin n → ℝ) :
    let α := dotProduct u (A.mulVec u)
    ((1 - α) • A - (A - (1 / (1 + α)) • (A * vecMulVec u u * A))).PosSemidef := by
  sorry

/-! ## Main Lemma -/

/-- **Lemma 2.5** (Bubeck §2.3.4): Leverage score ordering under constraint addition.

**Abstract formulation:** Let H : Matrix (Fin n) (Fin n) ℝ be positive definite,
c : Fin n → ℝ a new constraint direction, s > 0 its slack. Define:
  H̃ := H + (s⁻¹)² • vecMulVec c c    (augmented Hessian, positive definite)
  σ   := dotProduct a (H.inv *ᵥ a) / t²      (old leverage score for test (a,t))
  σ̃   := dotProduct a (H̃.inv *ᵥ a) / t²     (new leverage score for test (a,t))
  σ_c := dotProduct c (H.inv *ᵥ c) / s²      (old leverage score for new constraint)
  σ̃_c := dotProduct c (H̃.inv *ᵥ c) / s²     (new leverage score for new constraint)

Then: σ̃_c / (1 - σ̃_c)  ≥  σ  ≥  σ̃  ≥  (1 - σ_c) · σ. -/
theorem lemma_2_5_leverage_score_comparison
    {H : Matrix (Fin n) (Fin n) ℝ}
```

## Metadata

| Field | Value |
|-------|-------|
| Display name | Lemma 2.5 |
| Proof file status | `present` |
| Tracker status | `partial` |
| Computed status | `partial` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Lemma25.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Lemma25.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/02_03_04_constraints_and_the_volumetric_barrier.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/02_03_04_constraints_and_the_volumetric_barrier.md) |

## Dependencies

- Chapter 2 depends on finite-dimensional measure lemmas and matrix identities not needed in Chapter 1.

## Chapter Blockers

- Brunn-Minkowski slicing and cone-optimality arguments are still outside the current Mathlib surface area.
- Several chapter theorems depend on measure-theoretic and matrix-analytic lemmas that are not yet factored into reusable modules.

## Nearby Results

- Previous: [Theorem 2.4](./theorem-2-4.md)
- Next: [Lemma 2.8](./lemma-2-8.md)
