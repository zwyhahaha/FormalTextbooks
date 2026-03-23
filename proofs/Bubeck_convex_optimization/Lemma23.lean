import Mathlib.LinearAlgebra.Matrix.PosDef
import Mathlib.Algebra.QuadraticDiscriminant
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
  have hn1 : (1 : ℝ) < (n : ℝ) := by norm_cast
  have hc_pos : 0 < wHw H₀ w := hH₀.2 w hw
  have hc_ne : wHw H₀ w ≠ 0 := ne_of_gt hc_pos
  set u := H₀ *ᵥ w with hu_def
  set c := wHw H₀ w with hc_def_eq
  set s := (2 : ℝ) / (((n : ℝ) + 1) * c) with hs_def
  have hscalar_pos : 0 < (n : ℝ)^2 / ((n : ℝ)^2 - 1) := by
    apply div_pos; positivity; nlinarith
  have hs_pos : 0 < s := by rw [hs_def]; positivity
  -- H₀ is real-symmetric
  have hH₀_sym : H₀ᵀ = H₀ := by
    rw [← Matrix.conjTranspose_eq_transpose_of_trivial]
    exact hH₀.isHermitian
  -- newMatrix = scalar • inner_matrix
  have hNM : newMatrix H₀ w = ((n : ℝ)^2 / ((n : ℝ)^2 - 1)) •
      (H₀ - s • vecMulVec u u) := by unfold newMatrix rank1Mat; rfl
  rw [hNM]
  -- vecMulVec u u is Hermitian
  have hVMV_herm : (vecMulVec u u).IsHermitian := by
    rw [Matrix.IsHermitian, Matrix.conjTranspose_eq_transpose_of_trivial]
    ext i j; simp [Matrix.transpose_apply, vecMulVec_apply, mul_comm]
  constructor
  · -- IsHermitian of scalar • (H₀ - s • vecMulVec u u)
    rw [Matrix.IsHermitian, Matrix.conjTranspose_smul, star_trivial]
    congr 1
    rw [Matrix.conjTranspose_sub, Matrix.conjTranspose_smul, star_trivial]
    rw [hH₀.isHermitian, hVMV_herm]
  · -- Positive definiteness
    intro v hv
    simp only [Pi.star_apply, star_trivial]
    rw [Matrix.smul_mulVec_assoc, dotProduct_smul]
    apply mul_pos hscalar_pos
    -- Expand (H₀ - s • vecMulVec u u) *ᵥ v
    have h_vmv : vecMulVec u u *ᵥ v = (u ⬝ᵥ v) • u := by
      funext i
      change ∑ j : Fin n, (u i * u j) * v j = (∑ j : Fin n, u j * v j) * u i
      rw [Finset.sum_mul]; congr 1; ext j; ring
    rw [Matrix.sub_mulVec, Matrix.smul_mulVec_assoc, h_vmv, dotProduct_sub, dotProduct_smul]
    -- Goal: 0 < v ⬝ᵥ (H₀ *ᵥ v) - s * ((u ⬝ᵥ v) * (u ⬝ᵥ v))
    -- Actually: dotProduct_smul gives s * ((u ⬝ᵥ v) * ...) — may need adjustment
    set A := u ⬝ᵥ v
    set B := v ⬝ᵥ (H₀ *ᵥ v)
    have hB_pos : 0 < B := hH₀.2 v hv
    -- Key: w ᵥ* H₀ = u (using H₀ symmetric)
    have h_wu_eq : w ᵥ* H₀ = u := by
      rw [show H₀ = H₀ᵀ from hH₀_sym.symm, Matrix.vecMul_transpose]
    -- Symmetry: w ⬝ᵥ (H₀ *ᵥ v) = A
    have h_wHv : w ⬝ᵥ (H₀ *ᵥ v) = A := by
      rw [Matrix.dotProduct_mulVec, h_wu_eq]
    -- Symmetry: v ⬝ᵥ (H₀ *ᵥ w) = A
    have h_vHw : v ⬝ᵥ (H₀ *ᵥ w) = A := by rw [dotProduct_comm]
    -- Cauchy-Schwarz: A^2 ≤ c * B via discriminant argument
    have hCS : A^2 ≤ c * B := by
      have hquad : ∀ t : ℝ, 0 ≤ B * (t * t) + (-2 * A) * t + c := by
        intro t
        -- Use PSD: (w - t•v) ⬝ᵥ H₀ *ᵥ (w - t•v) ≥ 0
        have hpsd : 0 ≤ (w - t • v) ⬝ᵥ (H₀ *ᵥ (w - t • v)) := by
          simpa [star_trivial] using hH₀.posSemidef.2 (w - t • v)
        -- Expand: = c - 2*t*A + t^2*B
        have h_wHw : w ⬝ᵥ H₀ *ᵥ w = c := by simp [hc_def_eq, wHw]
        have h_eq : (w - t • v) ⬝ᵥ (H₀ *ᵥ (w - t • v)) = B * (t * t) + (-2 * A) * t + c := by
          simp only [Matrix.mulVec_sub, Matrix.mulVec_smul, dotProduct_sub, sub_dotProduct,
                     smul_dotProduct, dotProduct_smul]
          simp only [h_wHv, h_vHw, h_wHw]
          simp only [smul_eq_mul]
          ring
        linarith [h_eq ▸ hpsd]
      have hdiscrim := discrim_le_zero hquad
      simp only [discrim, sq] at hdiscrim
      nlinarith
    -- Bound: B - s*(A*A) ≥ B*(1 - s*c) > 0
    have hs_c : s * c = 2 / ((n : ℝ) + 1) := by
      rw [hs_def]; field_simp [hc_ne]; ring
    have h_sc_lt1 : s * c < 1 := by
      rw [hs_c]; rw [div_lt_one (by linarith)]; linarith
    have hA_smul : (u ⬝ᵥ v) • u = A • u := rfl
    -- After dotProduct_smul, the goal is: 0 < B - s * (v ⬝ᵥ (A • u))
    -- which is 0 < B - s * (A * (v ⬝ᵥ u))
    -- and v ⬝ᵥ u = u ⬝ᵥ v = A by dotProduct_comm
    have h_vu : v ⬝ᵥ A • u = A * A := by
      rw [dotProduct_smul, dotProduct_comm]; simp [smul_eq_mul]
    rw [h_vu]
    simp only [smul_eq_mul]
    nlinarith [sq_nonneg A, hCS, mul_pos hs_pos hc_pos, hB_pos]

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
  have hc_pos : 0 < wHw H₀ w := hH₀.2 w hw
  have hc_ne : wHw H₀ w ≠ 0 := ne_of_gt hc_pos
  have hH₀_det_isUnit : IsUnit H₀.det :=
    (Matrix.isUnit_iff_isUnit_det H₀).mp hH₀.isUnit
  have hH₀_det_ne : H₀.det ≠ 0 := hH₀_det_isUnit.ne_zero
  -- H₀⁻¹ *ᵥ (H₀ *ᵥ w) = w
  have h_inv : H₀⁻¹ *ᵥ (H₀ *ᵥ w) = w := by
    rw [Matrix.mulVec_mulVec, Matrix.nonsing_inv_mul H₀ hH₀_det_isUnit, Matrix.one_mulVec]
  -- Inner matrix determinant via matrix determinant lemma
  have h_inner_det :
      (H₀ - (2 / (((n : ℝ) + 1) * wHw H₀ w)) • vecMulVec (H₀ *ᵥ w) (H₀ *ᵥ w)).det =
      H₀.det * (((n : ℝ) - 1) / ((n : ℝ) + 1)) := by
    set s := (2 : ℝ) / (((n : ℝ) + 1) * wHw H₀ w)
    have hrw : H₀ - s • vecMulVec (H₀ *ᵥ w) (H₀ *ᵥ w) =
        H₀ + Matrix.col Unit (-(s • (H₀ *ᵥ w))) * Matrix.row Unit (H₀ *ᵥ w) := by
      ext i j
      simp [vecMulVec_apply, Matrix.col_apply, Matrix.row_apply, Matrix.mul_apply, neg_smul]
      ring
    rw [hrw, Matrix.det_add_col_mul_row hH₀_det_isUnit]
    have h_1x1 : (1 + Matrix.row Unit (H₀ *ᵥ w) * H₀⁻¹ *
        Matrix.col Unit (-(s • (H₀ *ᵥ w)))).det = ((n : ℝ) - 1) / ((n : ℝ) + 1) := by
      rw [Matrix.det_unique]
      simp only [Matrix.add_apply, Matrix.one_apply_eq]
      have h_row_eq : Matrix.row Unit (H₀ *ᵥ w) * H₀⁻¹ =
          Matrix.row Unit ((H₀ *ᵥ w) ᵥ* H₀⁻¹) := by
        ext _ j; simp [Matrix.row_apply, Matrix.mul_apply, Matrix.vecMul, dotProduct]
      rw [show Matrix.row Unit (H₀ *ᵥ w) * H₀⁻¹ * Matrix.col Unit (-(s • (H₀ *ᵥ w))) =
          Matrix.row Unit ((H₀ *ᵥ w) ᵥ* H₀⁻¹) * Matrix.col Unit (-(s • (H₀ *ᵥ w))) from
          by rw [h_row_eq]]
      rw [Matrix.row_mul_col_apply]
      rw [show (H₀ *ᵥ w) ᵥ* H₀⁻¹ ⬝ᵥ -(s • (H₀ *ᵥ w)) =
          -s * ((H₀ *ᵥ w) ᵥ* H₀⁻¹ ⬝ᵥ (H₀ *ᵥ w)) from by
          simp [dotProduct_neg, dotProduct_smul]]
      rw [← Matrix.dotProduct_mulVec, h_inv]
      rw [show (H₀ *ᵥ w) ⬝ᵥ w = wHw H₀ w from by simp [wHw, dotProduct_comm]]
      simp only [s]; field_simp [hc_ne]; ring
    rw [h_1x1]
  -- Apply det_smul to newMatrix
  have hNM_det : (newMatrix H₀ w).det =
      ((n : ℝ) ^ 2 / ((n : ℝ) ^ 2 - 1)) ^ n *
      (H₀ - (2 / (((n : ℝ) + 1) * wHw H₀ w)) • vecMulVec (H₀ *ᵥ w) (H₀ *ᵥ w)).det := by
    unfold newMatrix rank1Mat
    rw [Matrix.det_smul, Fintype.card_fin]
  rw [hNM_det, h_inner_det]
  rw [mul_div_assoc, mul_div_cancel_left₀ _ hH₀_det_ne]

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
  set_option maxHeartbeats 400000 in
  simp only [Ellipsoid, Set.mem_setOf_eq] at hx_ell ⊢
  set y := x - c₀ with hy_def
  set c := wHw H₀ w with hc_def
  have hc_pos : 0 < c := hH₀.2 w hw
  have hc_ne : c ≠ 0 := hc_pos.ne'
  have hc_sqrt_pos : 0 < Real.sqrt c := Real.sqrt_pos.mpr hc_pos
  have hc_sqrt_ne : Real.sqrt c ≠ 0 := hc_sqrt_pos.ne'
  have hc_sqrt_sq : Real.sqrt c ^ 2 = c := Real.sq_sqrt (le_of_lt hc_pos)
  have hn1 : (1 : ℝ) < (n : ℝ) := by exact_mod_cast (show 1 < n from by omega)
  have hn1_pos : (0 : ℝ) < (n : ℝ) - 1 := by linarith
  have hn1_ne : ((n : ℝ) - 1) ≠ 0 := hn1_pos.ne'
  have hn2_pos : (0 : ℝ) < (n : ℝ) ^ 2 - 1 := by nlinarith
  have hn2_ne : ((n : ℝ) ^ 2 - 1) ≠ 0 := hn2_pos.ne'
  have hn_sq_pos : (0 : ℝ) < (n : ℝ) ^ 2 := by positivity
  have hn_sq_ne : ((n : ℝ) ^ 2) ≠ 0 := hn_sq_pos.ne'
  have hn_pos : (0 : ℝ) < (n : ℝ) := by linarith
  have hn_ne : ((n : ℝ)) ≠ 0 := hn_pos.ne'
  have hn1p_pos : (0 : ℝ) < (n : ℝ) + 1 := by linarith
  have hn1p_ne : ((n : ℝ) + 1) ≠ 0 := hn1p_pos.ne'
  -- H₀ invertibility
  have hH₀_det_isUnit : IsUnit H₀.det :=
    (Matrix.isUnit_iff_isUnit_det H₀).mp hH₀.isUnit
  have hH₀_mul_inv : H₀ * H₀⁻¹ = 1 := Matrix.mul_nonsing_inv H₀ hH₀_det_isUnit
  have hH₀_inv_mul : H₀⁻¹ * H₀ = 1 := Matrix.nonsing_inv_mul H₀ hH₀_det_isUnit
  -- H₀ symmetry
  have hH₀_sym : H₀ᵀ = H₀ := by
    rw [← Matrix.conjTranspose_eq_transpose_of_trivial]; exact hH₀.isHermitian
  -- u = H₀w
  set u := H₀ *ᵥ w with hu_def
  -- H₀⁻¹ *ᵥ u = w
  have hH₀inv_u : H₀⁻¹ *ᵥ u = w := by
    rw [hu_def, Matrix.mulVec_mulVec, hH₀_inv_mul, Matrix.one_mulVec]
  -- u ᵥ* H₀⁻¹ = w  (using symmetry of H₀⁻¹)
  have h_u_vecmul_inv : u ᵥ* H₀⁻¹ = w := by
    have hH₀inv_sym : H₀⁻¹ᵀ = H₀⁻¹ := by
      rw [Matrix.transpose_nonsing_inv, hH₀_sym]
    have : u ᵥ* H₀⁻¹ = H₀⁻¹ *ᵥ u := by
      conv_lhs => rw [← hH₀inv_sym]
      rw [Matrix.vecMul_transpose]
    rw [this, hH₀inv_u]
  -- u ⬝ᵥ w = c
  have h_u_w : u ⬝ᵥ w = c := by
    simp [hc_def, wHw, hu_def, Matrix.dotProduct_mulVec, dotProduct_comm]
  -- H₀ * vecMulVec w w = vecMulVec u w
  have hH₀_mul_vmv : H₀ * vecMulVec w w = vecMulVec u w := by
    ext i j
    simp only [vecMulVec_apply, Matrix.mul_apply, hu_def, Matrix.mulVec, dotProduct]
    rw [show ∑ x_1 : Fin n, H₀ i x_1 * (w x_1 * w j) =
        ∑ x_1 : Fin n, (H₀ i x_1 * w x_1) * w j from by congr 1; ext k; ring]
    rw [← Finset.sum_mul]
  -- vecMulVec u u * H₀⁻¹ = vecMulVec u w
  have hVMV_mul_inv : vecMulVec u u * H₀⁻¹ = vecMulVec u w := by
    ext i j
    simp only [vecMulVec_apply, Matrix.mul_apply]
    have hstep : ∑ k : Fin n, u i * u k * H₀⁻¹ k j = u i * (u ᵥ* H₀⁻¹) j := by
      simp only [Matrix.vecMul, dotProduct, Finset.mul_sum]
      congr 1; ext k; ring
    rw [hstep, h_u_vecmul_inv]
  -- vecMulVec u u * vecMulVec w w = c • vecMulVec u w
  have hVMV_mul_vmv : vecMulVec u u * vecMulVec w w = c • vecMulVec u w := by
    ext i j
    simp only [vecMulVec_apply, Matrix.mul_apply, Matrix.smul_apply, smul_eq_mul]
    have : ∑ k : Fin n, u i * u k * (w k * w j) = u i * (u ⬝ᵥ w) * w j := by
      simp_rw [show ∀ k : Fin n, u i * u k * (w k * w j) = u i * w j * (u k * w k)
                from fun k => by ring]
      rw [← Finset.mul_sum]
      have hdot : ∑ k : Fin n, u k * w k = u ⬝ᵥ w := by simp [Matrix.dotProduct]
      rw [hdot]; ring
    rw [this, h_u_w]; ring
  -- Scalar abbreviations: s = 2/((n+1)c), t = 2/((n-1)c)
  set s := (2 : ℝ) / (((n : ℝ) + 1) * c) with hs_def
  set t := (2 : ℝ) / (((n : ℝ) - 1) * c) with ht_def
  -- t - s - s*t*c = 0
  have h_tsc : t - s - s * t * c = 0 := by
    rw [hs_def, ht_def]; field_simp [hc_ne]; ring
  -- Sherman-Morrison: (H₀ - s • uu) * (H₀⁻¹ + t • ww) = 1
  have hSM_inner : (H₀ - s • vecMulVec u u) * (H₀⁻¹ + t • vecMulVec w w) = 1 := by
    have step2 : H₀ * (t • vecMulVec w w) = t • vecMulVec u w := by
      rw [Matrix.mul_smul, hH₀_mul_vmv]
    have step3 : s • vecMulVec u u * H₀⁻¹ = s • vecMulVec u w := by
      rw [Matrix.smul_mul, hVMV_mul_inv]
    have step4 : s • vecMulVec u u * (t • vecMulVec w w) =
        (s * t * c) • vecMulVec u w := by
      rw [Matrix.smul_mul, Matrix.mul_smul, hVMV_mul_vmv, smul_smul, smul_smul]
    rw [Matrix.sub_mul, Matrix.mul_add, Matrix.mul_add]
    rw [hH₀_mul_inv, step2, step3, step4]
    -- Goal: 1 + t • vmv - (s • vmv + (s*t*c) • vmv) = 1
    have hcoeff : t - s - s * t * c = 0 := h_tsc
    ext i j
    simp only [Matrix.add_apply, Matrix.sub_apply, Matrix.smul_apply, Matrix.one_apply,
               smul_eq_mul]
    by_cases hij : i = j
    · subst hij; simp only [if_pos rfl]
      have key : t * vecMulVec u w i i - s * vecMulVec u w i i -
          s * t * c * vecMulVec u w i i = 0 := by
        linear_combination h_tsc * vecMulVec u w i i
      linarith
    · simp only [if_neg hij]
      have key : t * vecMulVec u w i j - s * vecMulVec u w i j -
          s * t * c * vecMulVec u w i j = 0 := by
        linear_combination h_tsc * vecMulVec u w i j
      linarith
  -- The candidate inverse: M = ((n²-1)/n²) • (H₀⁻¹ + t • vecMulVec w w)
  set M := (((n : ℝ) ^ 2 - 1) / (n : ℝ) ^ 2) • (H₀⁻¹ + t • vecMulVec w w) with hM_def
  -- newMatrix * M = 1
  have hSM : newMatrix H₀ w * M = 1 := by
    unfold newMatrix rank1Mat
    rw [hM_def, Matrix.smul_mul, Matrix.mul_smul, hSM_inner, smul_smul]
    have : (n : ℝ) ^ 2 / ((n : ℝ) ^ 2 - 1) * (((n : ℝ) ^ 2 - 1) / (n : ℝ) ^ 2) = 1 := by
      field_simp
    rw [this, one_smul]
  -- Therefore (newMatrix)⁻¹ = M
  have hInv : (newMatrix H₀ w)⁻¹ = M := Matrix.inv_eq_right_inv hSM
  -- Displacement from new center
  have hd : x - newCenter c₀ H₀ w = y + (1 / (((n : ℝ) + 1) * Real.sqrt c)) • u := by
    simp only [newCenter, hy_def, hu_def]
    ext i; simp [Pi.sub_apply, Pi.smul_apply]; ring
  -- Abbreviate displacement
  set d := y + (1 / (((n : ℝ) + 1) * Real.sqrt c)) • u with hd_def
  set τ := 1 / (((n : ℝ) + 1) * Real.sqrt c) with hτ_def
  -- Rewrite goal using hd and hInv
  rw [show x - newCenter c₀ H₀ w = d from hd, hInv, hM_def]
  -- Key inner products
  -- H₀⁻¹ *ᵥ d = H₀⁻¹ *ᵥ y + τ • w
  have hH₀inv_d : H₀⁻¹ *ᵥ d = H₀⁻¹ *ᵥ y + τ • w := by
    rw [hd_def, Matrix.mulVec_add, Matrix.mulVec_smul, hH₀inv_u]
  -- Set up α, β
  set α := w ⬝ᵥ y with hα_def
  set β := y ⬝ᵥ (H₀⁻¹ *ᵥ y) with hβ_def
  have hβ_le : β ≤ 1 := hx_ell
  have hα_le : α ≤ 0 := hx_half
  -- w ⬝ᵥ d = α + τ * c
  have hw_d : w ⬝ᵥ d = α + τ * c := by
    rw [hd_def, dotProduct_add, dotProduct_smul, smul_eq_mul]
    rw [show w ⬝ᵥ u = u ⬝ᵥ w from dotProduct_comm w u, h_u_w]
  -- H₀⁻¹ symmetry
  have hH₀inv_sym : H₀⁻¹ᵀ = H₀⁻¹ := by
    rw [Matrix.transpose_nonsing_inv, hH₀_sym]
  -- Symmetry of H₀⁻¹ quadratic form
  have hsym_H₀inv : ∀ a b : Fin n → ℝ, a ⬝ᵥ (H₀⁻¹ *ᵥ b) = b ⬝ᵥ (H₀⁻¹ *ᵥ a) := by
    intro a b
    have ha : a ᵥ* H₀⁻¹ = H₀⁻¹ *ᵥ a := by
      have h := (Matrix.mulVec_transpose H₀⁻¹ a)  -- H₀⁻¹ᵀ *ᵥ a = a ᵥ* H₀⁻¹
      rw [hH₀inv_sym] at h; exact h.symm
    rw [Matrix.dotProduct_mulVec, ha, dotProduct_comm]
  -- Cauchy-Schwarz: α² ≤ c * β  (uses H₀ PSD via discriminant)
  have hCS : α ^ 2 ≤ c * β := by
    have hquad : ∀ ξ : ℝ, 0 ≤ β * (ξ * ξ) + (-2 * α) * ξ + c := by
      intro ξ
      have hpsd : 0 ≤ (w - ξ • (H₀⁻¹ *ᵥ y)) ⬝ᵥ (H₀ *ᵥ (w - ξ • (H₀⁻¹ *ᵥ y))) := by
        simpa [star_trivial] using hH₀.posSemidef.2 (w - ξ • (H₀⁻¹ *ᵥ y))
      have hH₀_cancel : H₀ *ᵥ (H₀⁻¹ *ᵥ y) = y := by
        rw [Matrix.mulVec_mulVec, hH₀_mul_inv, Matrix.one_mulVec]
      have h_wHw : w ⬝ᵥ (H₀ *ᵥ w) = c := by simp [hc_def, wHw]
      have h_wHinvy : w ⬝ᵥ (H₀ *ᵥ (H₀⁻¹ *ᵥ y)) = α := by
        rw [hH₀_cancel, hα_def]
      have h_invyHw : (H₀⁻¹ *ᵥ y) ⬝ᵥ (H₀ *ᵥ w) = α := by
        -- Use: (H₀⁻¹y)ᵀ(H₀w) = ((H₀⁻¹y)ᵀH₀)w = (H₀(H₀⁻¹y))ᵀw = yᵀw = α
        rw [Matrix.dotProduct_mulVec,
            show (H₀⁻¹ *ᵥ y) ᵥ* H₀ = H₀ *ᵥ (H₀⁻¹ *ᵥ y) from by
              have h := (Matrix.mulVec_transpose H₀ (H₀⁻¹ *ᵥ y)).symm
              rwa [hH₀_sym] at h,
            hH₀_cancel, dotProduct_comm, hα_def]
      have h_invyHinvy : (H₀⁻¹ *ᵥ y) ⬝ᵥ (H₀ *ᵥ (H₀⁻¹ *ᵥ y)) = β := by
        rw [hH₀_cancel, show (H₀⁻¹ *ᵥ y) ⬝ᵥ y = y ⬝ᵥ (H₀⁻¹ *ᵥ y) from dotProduct_comm _ _]
      have h_eq : (w - ξ • (H₀⁻¹ *ᵥ y)) ⬝ᵥ (H₀ *ᵥ (w - ξ • (H₀⁻¹ *ᵥ y))) =
          β * (ξ * ξ) + (-2 * α) * ξ + c := by
        simp only [Matrix.mulVec_sub, Matrix.mulVec_smul, dotProduct_sub, sub_dotProduct,
                   smul_dotProduct, dotProduct_smul, h_wHw, h_wHinvy, h_invyHw, h_invyHinvy]
        simp only [smul_eq_mul]; ring
      linarith [h_eq ▸ hpsd]
    have hdiscrim := discrim_le_zero hquad
    simp only [discrim, sq] at hdiscrim; nlinarith
  -- d ⬝ᵥ (H₀⁻¹ *ᵥ d) = β + 2τα + τ²c
  have hd_H₀inv_d : d ⬝ᵥ (H₀⁻¹ *ᵥ d) = β + 2 * τ * α + τ ^ 2 * c := by
    rw [hd_def, Matrix.mulVec_add, Matrix.mulVec_smul, hH₀inv_u]
    simp only [dotProduct_add, add_dotProduct, dotProduct_smul, smul_dotProduct, smul_eq_mul]
    have h1 : y ⬝ᵥ w = α := by rw [dotProduct_comm, hα_def]
    have h2 : u ⬝ᵥ (H₀⁻¹ *ᵥ y) = α := by
      rw [hsym_H₀inv u y, hH₀inv_u, hα_def, dotProduct_comm]
    rw [h1, h2, h_u_w]; ring
  -- (w ⬝ᵥ d)²
  have hw_d_sq : (w ⬝ᵥ d) ^ 2 = α ^ 2 + 2 * τ * c * α + τ ^ 2 * c ^ 2 := by
    rw [hw_d]; ring
  -- vecMulVec w w *ᵥ d = (w ⬝ᵥ d) • w
  have hvmv_app : vecMulVec w w *ᵥ d = (w ⬝ᵥ d) • w := by
    ext i
    simp only [vecMulVec_apply, Matrix.mulVec, dotProduct, Pi.smul_apply, smul_eq_mul]
    rw [show ∑ j : Fin n, w i * w j * d j = w i * ∑ j : Fin n, w j * d j from by
      rw [Finset.mul_sum]; congr 1; ext j; ring]
    ring
  -- Compute the full quadratic form directly
  -- Goal is: d ⬝ᵥ (((n²-1)/n²) • (H₀⁻¹ + t • vecMulVec w w) *ᵥ d) ≤ 1
  rw [Matrix.smul_mulVec_assoc, Matrix.add_mulVec, Matrix.smul_mulVec_assoc, hvmv_app]
  rw [dotProduct_smul, smul_eq_mul, dotProduct_add, dotProduct_smul, smul_eq_mul, hd_H₀inv_d]
  rw [show d ⬝ᵥ ((w ⬝ᵥ d) • w) = (w ⬝ᵥ d) ^ 2 from by
    rw [dotProduct_smul, smul_eq_mul, dotProduct_comm]; ring]
  rw [hw_d_sq]
  -- Goal: ((n²-1)/n²) * (β + 2τα + τ²c + t * (α² + 2τcα + τ²c²)) ≤ 1
  -- Proof: substitute q = α/√c ∈ [-1,0]; expression simplifies to
  --        (n²-1)/n²·β + 2(n+1)q(1+q)/n² + 1/n², which ≤ 1 since β≤1, q(1+q)≤0.
  have hsqc_sq : Real.sqrt c ^ 2 = c := hc_sqrt_sq
  -- Step 1: rewrite the expression in terms of q = α/√c
  -- Key sub-facts to avoid slow ring
  have hτ_sqc : τ * Real.sqrt c = 1 / ((↑n : ℝ) + 1) := by
    rw [hτ_def]; field_simp [hn1p_ne, hc_sqrt_ne]
  have hτ2c : τ ^ 2 * c = 1 / ((↑n : ℝ) + 1) ^ 2 := by
    have : τ ^ 2 * c = (τ * Real.sqrt c) ^ 2 := by
      rw [mul_pow]; congr 1; exact hc_sqrt_sq.symm
    rw [this, hτ_sqc]; ring
  have htc : t * c = 2 / ((↑n : ℝ) - 1) := by
    rw [ht_def]; field_simp [hn1_ne, hc_ne]
  have h_eq : (↑n ^ 2 - 1) / ↑n ^ 2 *
      (β + 2 * τ * α + τ ^ 2 * c + t * (α ^ 2 + 2 * τ * c * α + τ ^ 2 * c ^ 2)) =
      ((↑n ^ 2 - 1) * β + 2 * (↑n + 1) * (α / Real.sqrt c) *
       (1 + α / Real.sqrt c) + 1) / ↑n ^ 2 := by
    have hα_rw : α / Real.sqrt c = α * τ * ((↑n : ℝ) + 1) := by
      rw [hτ_def]; field_simp [hn1p_ne, hc_sqrt_ne]; ring
    rw [hα_rw]
    have h1 : τ ^ 2 * c + t * (τ ^ 2 * c ^ 2) = (τ ^ 2 * c) * (1 + t * c) := by ring
    have h2 : 2 * τ * α + t * (2 * τ * c * α) = 2 * τ * α * (1 + t * c) := by ring
    rw [show β + 2 * τ * α + τ ^ 2 * c + t * (α ^ 2 + 2 * τ * c * α + τ ^ 2 * c ^ 2) =
        β + 2 * τ * α * (1 + t * c) + (τ ^ 2 * c) * (1 + t * c) + t * α ^ 2 from by ring]
    rw [hτ2c, htc]
    field_simp [hn1_ne, hn1p_ne, hn_sq_ne]
    ring
  rw [h_eq]
  -- Step 2: set p = α/√c and derive bounds
  set p := α / Real.sqrt c with hp_def
  have hp_neg : p ≤ 0 :=
    div_nonpos_of_nonpos_of_nonneg hα_le (le_of_lt hc_sqrt_pos)
  have hp2_le_β : p ^ 2 ≤ β := by
    rw [hp_def, div_pow, div_le_iff (by positivity : (0 : ℝ) < Real.sqrt c ^ 2)]
    calc α ^ 2 ≤ c * β := hCS
         _ = Real.sqrt c ^ 2 * β := by rw [hsqc_sq]
  have hp_ge_m1 : -1 ≤ p := by
    nlinarith [sq_nonneg (p + 1), le_trans hp2_le_β hβ_le]
  have hp1p_le : p * (1 + p) ≤ 0 := by nlinarith
  -- Step 3: clear denominator and apply nlinarith
  rw [div_le_one hn_sq_pos]
  nlinarith [mul_nonneg (by linarith : (0 : ℝ) ≤ ↑n ^ 2 - 1) (by linarith : (0 : ℝ) ≤ 1 - β),
             mul_nonpos_of_nonneg_of_nonpos (by linarith : (0 : ℝ) ≤ 2 * ((↑n : ℝ) + 1)) hp1p_le]

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
