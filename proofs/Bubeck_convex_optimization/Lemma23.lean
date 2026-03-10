import Mathlib.LinearAlgebra.Matrix.PosDef
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.LinearAlgebra.Matrix.SchurComplement
import Mathlib.MeasureTheory.Measure.Lebesgue.EqHaar
import Mathlib.MeasureTheory.Measure.Lebesgue.VolumeOfBalls
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.InnerProductSpace.PiL2

set_option linter.unusedSectionVars false

/-!
# Lemma 2.3 — Ellipsoid Method: Geometric Lemma

Source: papers/Bubeck_convex_optimization/sections/02_02_the_ellipsoid_method.md

## Informal statement

Let E₀ = {x ∈ ℝⁿ : (x - c₀)ᵀ H₀⁻¹ (x - c₀) ≤ 1} be an ellipsoid with center c₀ and
positive definite shape matrix H₀. For any nonzero w ∈ ℝⁿ, define:

  c := c₀ - (1/(n+1)) · H₀w / √(wᵀH₀w)
  H := n²/(n²-1) · (H₀ - 2/(n+1) · H₀wwᵀH₀ / (wᵀH₀w))

Then E := {x ∈ ℝⁿ : (x - c)ᵀ H⁻¹ (x - c) ≤ 1} satisfies:
1. E ⊇ {x ∈ E₀ : wᵀ(x - c₀) ≤ 0}  (containment of half-ellipsoid)
2. vol(E) ≤ exp(-1/(2n)) · vol(E₀)   (volume reduction)

## Proof sketch

For n=1 the result is obvious.
For n≥2: reduce to the unit ball case via Φ(x) = c₀ + H₀^(1/2) x, derive the
formulas by minimizing volume subject to the touching conditions, then apply
Sherman-Morrison to convert H⁻¹ formula to the stated H formula.

The key facts:
- det(H)/det(H₀) = (n²/(n²-1))ⁿ · (n-1)/(n+1) (via matrix determinant lemma)
- vol(E)/vol(E₀) = √(det H / det H₀) ≤ exp(-1/(2n)) (by elementary calculus)
-/

open Matrix MeasureTheory Real

/-- The ellipsoid E(c, H) = {x : (x-c)ᵀ H⁻¹ (x-c) ≤ 1}
    where H is a positive definite matrix -/
def Ellipsoid {n : ℕ} (c : Fin n → ℝ) (H : Matrix (Fin n) (Fin n) ℝ) : Set (Fin n → ℝ) :=
  {x | dotProduct (x - c) (H⁻¹ *ᵥ (x - c)) ≤ 1}

/-- The scalar wᵀ H₀ w (appears in denominator of update formulas) -/
noncomputable def wHw {n : ℕ} (H₀ : Matrix (Fin n) (Fin n) ℝ) (w : Fin n → ℝ) : ℝ :=
  dotProduct w (H₀ *ᵥ w)

/-- The rank-1 matrix H₀ w wᵀ H₀ = (H₀w) ⊗ (H₀w) -/
noncomputable def rank1Mat {n : ℕ} (H₀ : Matrix (Fin n) (Fin n) ℝ) (w : Fin n → ℝ) :
    Matrix (Fin n) (Fin n) ℝ :=
  vecMulVec (H₀ *ᵥ w) (H₀ *ᵥ w)

/-- The new center after the ellipsoid update:
    c = c₀ - (1/(n+1)) · H₀w / √(wᵀH₀w) -/
noncomputable def newCenter {n : ℕ} (c₀ : Fin n → ℝ) (H₀ : Matrix (Fin n) (Fin n) ℝ)
    (w : Fin n → ℝ) : Fin n → ℝ :=
  c₀ - (1 / ((n : ℝ) + 1) / Real.sqrt (wHw H₀ w)) • (H₀ *ᵥ w)

/-- The new shape matrix after the ellipsoid update:
    H = n²/(n²-1) · (H₀ - 2/(n+1) · H₀wwᵀH₀ / (wᵀH₀w)) -/
noncomputable def newMatrix {n : ℕ} (H₀ : Matrix (Fin n) (Fin n) ℝ) (w : Fin n → ℝ) :
    Matrix (Fin n) (Fin n) ℝ :=
  ((n : ℝ) ^ 2 / ((n : ℝ) ^ 2 - 1)) •
    (H₀ - (2 / (((n : ℝ) + 1) * wHw H₀ w)) • rank1Mat H₀ w)

/-! ## Key lemmas -/

/-- wᵀH₀w > 0 when H₀ is positive definite and w ≠ 0 -/
lemma wHw_pos {n : ℕ} {H₀ : Matrix (Fin n) (Fin n) ℝ} (hH₀ : H₀.PosDef)
    {w : Fin n → ℝ} (hw : w ≠ 0) : 0 < wHw H₀ w :=
  hH₀.2 w hw

/-- The new shape matrix H is positive definite when H₀ is PD, n ≥ 2, and w ≠ 0.

Proof idea: Let P = rank1Mat H₀ w / (wᵀH₀w) be the rank-1 projection in the H₀^(1/2)
basis. The eigenvalue of P in direction H₀^(1/2)w is 1; all other eigenvalues are 0.
So I - (2/(n+1)) P is PD (since 2/(n+1) < 1 for n ≥ 1).
Then H₀(I - (2/(n+1)) P') is congruent to H₀^(1/2)(I - (2/(n+1)) P')H₀^(1/2) which is PD.
The scalar (n²/(n²-1)) > 0 for n ≥ 2.
-/
lemma newMatrix_posDef {n : ℕ} {H₀ : Matrix (Fin n) (Fin n) ℝ} (hH₀ : H₀.PosDef)
    {w : Fin n → ℝ} (hw : w ≠ 0) (hn : 2 ≤ n) : (newMatrix H₀ w).PosDef := by
  sorry
  -- TODO: detailed eigenvalue analysis of the rank-1 update

/-- The determinant ratio:
    det(newMatrix H₀ w) / det(H₀) = (n²/(n²-1))ⁿ · (n-1)/(n+1)

Proof idea (matrix determinant lemma):
Let Ã = H₀ - (2/(n+1)(wᵀH₀w)) · H₀wwᵀH₀.
Since H₀wwᵀH₀ is rank-1 with eigenvector H₀^(1/2)w having eigenvalue wᵀH₀w,
the matrix determinant lemma (det(A + uvᵀ) = det(A)(1 + vᵀA⁻¹u)) gives:
  det(Ã) = det(H₀) · (1 - 2/(n+1)) = det(H₀) · (n-1)/(n+1)
The scalar factor (n²/(n²-1))ⁿ from the smul gives the full ratio.
-/
lemma det_newMatrix_ratio {n : ℕ} {H₀ : Matrix (Fin n) (Fin n) ℝ} (hH₀ : H₀.PosDef)
    {w : Fin n → ℝ} (hw : w ≠ 0) (hn : 2 ≤ n) :
    (newMatrix H₀ w).det / H₀.det =
    ((n : ℝ) ^ 2 / ((n : ℝ) ^ 2 - 1)) ^ n * (((n : ℝ) - 1) / ((n : ℝ) + 1)) := by
  sorry
  -- TODO: Matrix.det_smul + matrix determinant lemma (Matrix.det_add_col_mul_row)

/-- Volume reduction bound:
    √((n²/(n²-1))ⁿ · (n-1)/(n+1)) ≤ exp(-1/(2n))

This is equivalent to (n²/(n²-1))ⁿ · (n-1)/(n+1) ≤ exp(-1/n).
Follows from the elementary bound: the function f(h) = h²(2h-h²)^(n-1)
attains maximum value ≥ exp(1/n) at h = 1 + 1/n.
-/
lemma det_ratio_vol_bound {n : ℕ} (hn : 2 ≤ n) :
    Real.sqrt (((n : ℝ) ^ 2 / ((n : ℝ) ^ 2 - 1)) ^ n * (((n : ℝ) - 1) / ((n : ℝ) + 1))) ≤
    Real.exp (-(1 / (2 * (n : ℝ)))) := by
  sorry
  -- TODO: elementary analysis; the bound follows from (1 + 1/n)^n ≥ e^(1/2) type estimates

/-- Containment lemma: if x ∈ E₀ and wᵀ(x-c₀) ≤ 0, then x ∈ newEllipsoid.

Proof idea (unit ball reduction):
  1. Let Φ : ℝⁿ → ℝⁿ, Φ(x) = H₀^(1/2)(x - c₀), so E₀ = Φ⁻¹(B).
  2. Let v = H₀^(1/2)w / ‖H₀^(1/2)w‖ (unit vector). The half-ellipsoid maps to {u ∈ B : vᵀu ≤ 0}.
  3. The formula for newCenter/newMatrix corresponds (after pullback by Φ) to the
     unique minimal-volume ellipsoid for the half-ball in direction v.
  4. Algebraic verification: for ‖u‖ ≤ 1, vᵀu ≤ 0, the ellipsoid condition
     (n²-1)/n²·‖u+v/(n+1)‖² + 2(n+1)/n²·(vᵀu+1/(n+1))² ≤ 1 holds.
     [The two key touching conditions are: equality at u = -v and at u ∈ ∂B∩v⊥.]
-/
lemma half_ellipsoid_contained {n : ℕ} {c₀ : Fin n → ℝ}
    {H₀ : Matrix (Fin n) (Fin n) ℝ} (hH₀ : H₀.PosDef)
    {w : Fin n → ℝ} (hw : w ≠ 0) (hn : 2 ≤ n)
    {x : Fin n → ℝ}
    (hx_ell : x ∈ Ellipsoid c₀ H₀)
    (hx_half : dotProduct w (x - c₀) ≤ 0) :
    x ∈ Ellipsoid (newCenter c₀ H₀ w) (newMatrix H₀ w) := by
  sorry
  -- TODO: algebraic verification after reducing to unit ball via H₀^(1/2)

/-! ## Main theorem -/

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
