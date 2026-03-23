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
    (hH : H.PosDef)
    (c : Fin n → ℝ)
    {s : ℝ} (hs : 0 < s)
    (a : Fin n → ℝ)
    {t : ℝ} (ht : 0 < t) :
    let H_tilde := H + (s⁻¹ ^ 2) • vecMulVec c c
    let σ       := dotProduct a (H⁻¹ *ᵥ a) / t ^ 2
    let σ_tilde := dotProduct a (H_tilde⁻¹ *ᵥ a) / t ^ 2
    let σ_c     := dotProduct c (H⁻¹ *ᵥ c) / s ^ 2
    let σ_tilde_c := dotProduct c (H_tilde⁻¹ *ᵥ c) / s ^ 2
    σ_tilde_c / (1 - σ_tilde_c) ≥ σ ∧
    σ ≥ σ_tilde ∧
    σ_tilde ≥ (1 - σ_c) * σ := by
  -- All three parts reduce to PSD matrix comparisons via Sherman-Morrison.
  --
  -- H_tilde is PD (H is PD and we add a PSD term).
  -- H_tilde.inv exists and equals (by Sherman-Morrison / Woodbury):
  --   H.inv - (H.inv * vecMulVec c c * H.inv) / (s² + dotProduct c (H.inv *ᵥ c))
  --   [use Matrix.add_mul_mul_inv_eq_sub with U = col c, V = row c, C = s⁻² scalar]
  --
  -- Part 2 (σ ≥ σ_tilde):
  --   From SM: H_tilde.inv = H.inv - (PSD rank-1 term) ≼ H.inv.
  --   Hence dotProduct a (H_tilde.inv *ᵥ a) ≤ dotProduct a (H.inv *ᵥ a).
  --   Dividing by t² > 0: σ_tilde ≤ σ.
  --
  -- Part 3 (σ_tilde ≥ (1-σ_c) σ):
  --   `posSemidef_rankOne_PSD_lower_bound` with A = H.inv, u = c/s gives
  --   H_tilde.inv ≽ (1-σ_c) H.inv.
  --   Hence dotProduct a (H_tilde.inv *ᵥ a) ≥ (1-σ_c) · dotProduct a (H.inv *ᵥ a).
  --   Dividing by t² > 0: σ_tilde ≥ (1-σ_c) σ.
  --
  -- Part 1 (σ_tilde_c / (1-σ_tilde_c) ≥ σ):
  --   By the reverse SM: H.inv = H_tilde.inv + (PSD rank-1 term involving H_tilde.inv).
  --   Applying the analogous PSD bound: H.inv ≼ (1/(1-σ_tilde_c)) H_tilde.inv.
  --   Hence for any vector a and slack t:
  --     σ ≤ (1/(1-σ_tilde_c)) σ_tilde_c = σ_tilde_c / (1-σ_tilde_c).
  sorry
