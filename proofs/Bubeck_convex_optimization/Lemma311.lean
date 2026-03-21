import Optlib.Function.Lsmooth
import proofs.Bubeck_convex_optimization.Lemma35

set_option linter.unusedSectionVars false
set_option linter.unusedVariables false

open InnerProductSpace

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E] [CompleteSpace E]

/-!
# Lemma 3.11 — Coercivity for β-smooth α-strongly convex functions (Bubeck §3.4.2)

Source: papers/Bubeck_convex_optimization/sections/03_04_02_strongly_convex_and_smooth_functions.md

Let f be β-smooth and α-strongly convex on ℝⁿ. Then for all x, y:
  ⟨∇f(x) - ∇f(y), x - y⟩ ≥ αβ/(β+α) * ‖x-y‖² + 1/(β+α) * ‖∇f(x) - ∇f(y)‖²
-/

/-! ### eq:coercive1: coercivity for smooth convex functions -/

/-- For a β-smooth convex f, ⟨f'(x)-f'(y), x-y⟩ ≥ 1/β * ‖f'(x)-f'(y)‖² -/
private lemma coercive1
    {f : E → ℝ} {f' : E → E} {β : ℝ} (hβ : 0 < β)
    (hlo : ∀ a b : E, 0 ≤ f a - f b - ⟪f' b, a - b⟫_ℝ)
    (hup : ∀ a b : E, f a - f b - ⟪f' b, a - b⟫_ℝ ≤ β / 2 * ‖a - b‖ ^ 2)
    (x y : E) :
    ⟪f' x - f' y, x - y⟫_ℝ ≥ 1 / β * ‖f' x - f' y‖ ^ 2 := by
  have h1 := lemma_3_5 hβ hlo hup x y
  have h2 : f y - f x ≤ -⟪f' y, x - y⟫_ℝ - 1 / (2 * β) * ‖f' x - f' y‖ ^ 2 := by
    have h := lemma_3_5 hβ hlo hup y x
    have hneg : ⟪f' y, y - x⟫_ℝ = -⟪f' y, x - y⟫_ℝ := by
      rw [show y - x = -(x - y) from by abel, inner_neg_right]
    have hnsym : ‖f' y - f' x‖ ^ 2 = ‖f' x - f' y‖ ^ 2 := by rw [norm_sub_rev]
    rw [hneg, hnsym] at h
    linarith
  -- Add h1 + h2; simplify 1/(2β) + 1/(2β) = 1/β using add_le_add + ring
  have hsum : (f x - f y) + (f y - f x) ≤
      (⟪f' x, x - y⟫_ℝ - 1 / (2 * β) * ‖f' x - f' y‖ ^ 2) +
      (-⟪f' y, x - y⟫_ℝ - 1 / (2 * β) * ‖f' x - f' y‖ ^ 2) :=
    add_le_add h1 h2
  have hzero : (f x - f y) + (f y - f x) = 0 := by ring
  have hrhs : (⟪f' x, x - y⟫_ℝ - 1 / (2 * β) * ‖f' x - f' y‖ ^ 2) +
      (-⟪f' y, x - y⟫_ℝ - 1 / (2 * β) * ‖f' x - f' y‖ ^ 2) =
      ⟪f' x, x - y⟫_ℝ - ⟪f' y, x - y⟫_ℝ - 1 / β * ‖f' x - f' y‖ ^ 2 := by
    field_simp; ring
  have hineq : 0 ≤ ⟪f' x, x - y⟫_ℝ - ⟪f' y, x - y⟫_ℝ - 1 / β * ‖f' x - f' y‖ ^ 2 := by
    linarith [hsum, hzero, hrhs]
  have hkey : ⟪f' x - f' y, x - y⟫_ℝ = ⟪f' x, x - y⟫_ℝ - ⟪f' y, x - y⟫_ℝ :=
    inner_sub_left _ _ _
  linarith [hkey, hineq]

/-! ### Key algebraic identity for φ = f - α/2 * ‖·‖² -/

private lemma phi_linearization_error
    {f : E → ℝ} {f' : E → E} {α : ℝ}
    (a b : E) :
    (f a - α / 2 * ‖a‖ ^ 2) - (f b - α / 2 * ‖b‖ ^ 2) -
        ⟪f' b - α • b, a - b⟫_ℝ =
    (f a - f b - ⟪f' b, a - b⟫_ℝ) - α / 2 * ‖a - b‖ ^ 2 := by
  have hinner : ⟪f' b - α • b, a - b⟫_ℝ = ⟪f' b, a - b⟫_ℝ - α * ⟪b, a - b⟫_ℝ := by
    rw [inner_sub_left, real_inner_smul_left]
  have hnd : α / 2 * ‖a‖ ^ 2 - α / 2 * ‖b‖ ^ 2 - α * ⟪b, a - b⟫_ℝ = α / 2 * ‖a - b‖ ^ 2 := by
    have h1 : ⟪b, a - b⟫_ℝ = ⟪a, b⟫_ℝ - ‖b‖ ^ 2 := by
      rw [inner_sub_right, real_inner_self_eq_norm_sq, real_inner_comm]
    rw [h1, norm_sub_sq_real]
    ring
  linarith [hinner, hnd]

/-! ### Main theorem -/

/-- **Lemma 3.11** (Bubeck §3.4.2): For f β-smooth and α-strongly convex,
    ⟨∇f(x) - ∇f(y), x - y⟩ ≥ αβ/(β+α) * ‖x-y‖² + 1/(β+α) * ‖∇f(x) - ∇f(y)‖² -/
theorem lemma_3_11
    {f : E → ℝ} {f' : E → E} {α β : ℝ}
    (hα : 0 < α) (hβ : 0 < β) (hαβ : α ≤ β)
    (hsc : ∀ a b : E, α / 2 * ‖a - b‖ ^ 2 ≤ f a - f b - ⟪f' b, a - b⟫_ℝ)
    (hup : ∀ a b : E, f a - f b - ⟪f' b, a - b⟫_ℝ ≤ β / 2 * ‖a - b‖ ^ 2)
    (x y : E) :
    ⟪f' x - f' y, x - y⟫_ℝ ≥
      α * β / (β + α) * ‖x - y‖ ^ 2 + 1 / (β + α) * ‖f' x - f' y‖ ^ 2 := by
  have hlo_f : ∀ a b : E, 0 ≤ f a - f b - ⟪f' b, a - b⟫_ℝ :=
    fun a b => le_trans (by positivity) (hsc a b)
  have hlo_φ : ∀ a b : E,
      0 ≤ (f a - α / 2 * ‖a‖ ^ 2) - (f b - α / 2 * ‖b‖ ^ 2) -
          ⟪f' b - α • b, a - b⟫_ℝ := fun a b => by
    rw [phi_linearization_error]; linarith [hsc a b]
  have hup_φ : ∀ a b : E,
      (f a - α / 2 * ‖a‖ ^ 2) - (f b - α / 2 * ‖b‖ ^ 2) -
          ⟪f' b - α • b, a - b⟫_ℝ ≤ (β - α) / 2 * ‖a - b‖ ^ 2 := fun a b => by
    rw [phi_linearization_error]; linarith [hup a b]
  set u := f' x - f' y with hu_def
  set v := x - y with hv_def
  rcases eq_or_lt_of_le hαβ with rfl | hlt
  · -- Case α = β
    -- coercive1 for f with parameter α: ⟪u,v⟫ ≥ 1/α * ‖u‖²
    have hcoerc : ⟪u, v⟫_ℝ ≥ 1 / α * ‖u‖ ^ 2 := by
      have h := coercive1 hα hlo_f hup x y
      simp only [u, v] at h; exact h
    -- Strong convexity both ways: ⟪u,v⟫ ≥ α * ‖v‖²
    have hsc_both : ⟪u, v⟫_ℝ ≥ α * ‖v‖ ^ 2 := by
      have hxy := hsc y x   -- α/2 * ‖y-x‖² ≤ f y - f x - ⟪f'x, y-x⟫
      have hyx := hsc x y   -- α/2 * ‖v‖² ≤ f x - f y - ⟪f'y, v⟫
      have hsym : ‖y - x‖ ^ 2 = ‖v‖ ^ 2 := by rw [norm_sub_rev]
      have hneg_x : ⟪f' x, y - x⟫_ℝ = -⟪f' x, v⟫_ℝ := by
        have hyx : y - x = -v := by rw [hv_def]; abel
        rw [hyx, inner_neg_right]
      rw [hsym, hneg_x] at hxy
      -- hxy now: α/2 * ‖v‖² ≤ f y - f x + ⟪f'x, v⟫
      rw [show ⟪u, v⟫_ℝ = ⟪f' x, v⟫_ℝ - ⟪f' y, v⟫_ℝ from inner_sub_left _ _ _]
      linarith [hxy, hyx]
    -- Goal (α = β): ⟪u,v⟫ ≥ α²/(2α)*‖v‖² + 1/(2α)*‖u‖²
    -- Multiply by (α+α) > 0: equiv to (α+α)*⟪u,v⟫ ≥ α²*‖v‖² + ‖u‖²
    have h_mul1 : ‖u‖ ^ 2 ≤ α * ⟪u, v⟫_ℝ := by
      have h := mul_le_mul_of_nonneg_left hcoerc hα.le
      have : α * (1 / α * ‖u‖ ^ 2) = ‖u‖ ^ 2 := by field_simp
      linarith [h, this]
    have h_mul2 : α ^ 2 * ‖v‖ ^ 2 ≤ α * ⟪u, v⟫_ℝ := by
      have h := mul_le_mul_of_nonneg_left hsc_both hα.le
      have : α * (α * ‖v‖ ^ 2) = α ^ 2 * ‖v‖ ^ 2 := by ring
      linarith [h, this]
    rw [ge_iff_le, ← sub_nonneg]
    have hrewrite : ⟪u, v⟫_ℝ - (α * α / (α + α) * ‖v‖ ^ 2 + 1 / (α + α) * ‖u‖ ^ 2) =
        ((α + α) * ⟪u, v⟫_ℝ - α ^ 2 * ‖v‖ ^ 2 - ‖u‖ ^ 2) / (α + α) := by
      have : (α : ℝ) + α ≠ 0 := by linarith
      field_simp [this]
      ring
    rw [hrewrite]
    apply div_nonneg _ (by linarith)
    linarith [h_mul1, h_mul2]
  · -- Case α < β
    have hβα : 0 < β - α := sub_pos.mpr hlt
    have hβpα : (0 : ℝ) < β + α := by linarith
    -- Apply coercive1 to φ with parameter (β - α)
    have hcoerc := coercive1 (f := fun a => f a - α / 2 * ‖a‖ ^ 2)
        (f' := fun a => f' a - α • a) hβα hlo_φ hup_φ x y
    -- Simplify φ'(x) - φ'(y) = u - α•v
    have h_eq : f' x - α • x - (f' y - α • y) = u - α • v := by
      show f' x - α • x - (f' y - α • y) = (f' x - f' y) - α • (x - y)
      rw [smul_sub]; abel
    rw [show (fun a => f' a - α • a) x - (fun a => f' a - α • a) y = u - α • v from h_eq]
      at hcoerc
    -- ⟨u - α•v, v⟩ = ⟨u,v⟩ - α*‖v‖²
    have hinner_phi : ⟪u - α • v, v⟫_ℝ = ⟪u, v⟫_ℝ - α * ‖v‖ ^ 2 := by
      rw [inner_sub_left, real_inner_smul_left, real_inner_self_eq_norm_sq]
    -- ‖u - α•v‖² = ‖u‖² - 2α*⟨u,v⟩ + α²*‖v‖²
    have hnorm_phi : ‖u - α • v‖ ^ 2 = ‖u‖ ^ 2 - 2 * α * ⟪u, v⟫_ℝ + α ^ 2 * ‖v‖ ^ 2 := by
      rw [norm_sub_sq_real, norm_smul, Real.norm_eq_abs, abs_of_pos hα, inner_smul_right]
      ring
    rw [hinner_phi, hnorm_phi] at hcoerc
    -- hcoerc: ⟨u,v⟩ - α*‖v‖² ≥ 1/(β-α) * (‖u‖² - 2α*⟨u,v⟩ + α²*‖v‖²)
    -- Multiply by (β-α): (β-α)*(⟨u,v⟩-α*‖v‖²) ≥ ‖u‖² - 2α*⟨u,v⟩ + α²*‖v‖²
    have hkey : (β - α) * (⟪u, v⟫_ℝ - α * ‖v‖ ^ 2) ≥
        ‖u‖ ^ 2 - 2 * α * ⟪u, v⟫_ℝ + α ^ 2 * ‖v‖ ^ 2 := by
      have h : (β - α) * (1 / (β - α) * (‖u‖ ^ 2 - 2 * α * ⟪u, v⟫_ℝ + α ^ 2 * ‖v‖ ^ 2)) =
          ‖u‖ ^ 2 - 2 * α * ⟪u, v⟫_ℝ + α ^ 2 * ‖v‖ ^ 2 := by field_simp
      calc ‖u‖ ^ 2 - 2 * α * ⟪u, v⟫_ℝ + α ^ 2 * ‖v‖ ^ 2
          = (β - α) * (1 / (β - α) * (‖u‖ ^ 2 - 2 * α * ⟪u, v⟫_ℝ + α ^ 2 * ‖v‖ ^ 2)) := h.symm
        _ ≤ (β - α) * (⟪u, v⟫_ℝ - α * ‖v‖ ^ 2) :=
            mul_le_mul_of_nonneg_left hcoerc hβα.le
    -- (β+α)*⟨u,v⟩ ≥ ‖u‖² + α*β*‖v‖²
    have hfinal : (β + α) * ⟪u, v⟫_ℝ ≥ ‖u‖ ^ 2 + α * β * ‖v‖ ^ 2 := by nlinarith [hkey]
    rw [ge_iff_le, ← sub_nonneg]
    have hrewrite : ⟪u, v⟫_ℝ - (α * β / (β + α) * ‖v‖ ^ 2 + 1 / (β + α) * ‖u‖ ^ 2) =
        ((β + α) * ⟪u, v⟫_ℝ - α * β * ‖v‖ ^ 2 - ‖u‖ ^ 2) / (β + α) := by
      field_simp; ring
    rw [hrewrite]
    apply div_nonneg _ hβpα.le
    linarith [hfinal]
