import Optlib.Convex.Subgradient

set_option linter.unusedSectionVars false

/-!
# Proposition 1.5 — Existence of subgradients

Source: papers/Bubeck_convex_optimization/sections/01_02_basic_properties_of_convexity.md

Informal statement:
  Let X ⊆ ℝⁿ be convex, f : X → ℝ.
  (1) If ∀ x ∈ X, ∂f(x) ≠ ∅ then f is convex.
  (2) Conversely, if f is convex then for any x ∈ int(X), ∂f(x) ≠ ∅.
  (3) If f is convex and differentiable at x then ∇f(x) ∈ ∂f(x).

We work with X = univ (the whole space E).

## Proof strategy

(1) Let z = a•x + b•y (a+b=1, a,b≥0). Pick g ∈ ∂f(z). By the subgradient definition:
    f(x) ≥ f(z) + ⟪g, x - z⟫  and  f(y) ≥ f(z) + ⟪g, y - z⟫
    Note x - z = b•(x-y) and y - z = a•(y-x).
    So: f(x) ≥ f(z) + b*⟪g,x-y⟫  and  f(y) ≥ f(z) - a*⟪g,x-y⟫
    Take a-multiple of first + b-multiple of second; the inner-product terms cancel,
    giving f(z) ≤ a•f(x) + b•f(y).

(2) `SubderivAt.nonempty` from Optlib (requires continuity hypothesis).

(3) `SubderivAt_eq_gradient` from Optlib gives SubderivAt f x = {∇f(x)},
    so ∇f(x) ∈ SubderivAt f x, i.e., HasSubgradientAt f (∇f x) x.
-/

open Set

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E] [CompleteSpace E]

/-- **Proposition 1.5** (Bubeck §1.2), part 1:
    If every point has a nonempty subdifferential, then f is convex. -/
theorem proposition_1_5_convex_of_subgradient
    {f : E → ℝ}
    (h : ∀ x, (SubderivAt f x).Nonempty) :
    ConvexOn ℝ univ f := by
  constructor
  · exact convex_univ
  intro x _ y _ a b ha hb hab
  obtain ⟨g, hg⟩ := h (a • x + b • y)
  -- Unfold set membership to HasSubgradientAt
  simp only [SubderivAt, Set.mem_setOf_eq] at hg
  -- hg : ∀ u, f u ≥ f (a • x + b • y) + inner g (u - (a • x + b • y))
  -- Get the two subgradient inequalities
  have hx := hg x   -- f x ≥ f z + inner g (x - z)
  have hy := hg y   -- f y ≥ f z + inner g (y - z)
  -- Simplify: x - z = b • (x - y), using that x = a • x + b • x
  have heqx : x = a • x + b • x := by
    rw [← add_smul, hab, one_smul]
  have key1 : x - (a • x + b • y) = b • (x - y) := by
    calc x - (a • x + b • y)
        = (a • x + b • x) - (a • x + b • y) := by rw [← heqx]
      _ = b • x - b • y := by abel
      _ = b • (x - y) := by rw [smul_sub]
  -- Simplify: y - z = a • (y - x), using that y = a • y + b • y
  have heqy : y = a • y + b • y := by
    rw [← add_smul, hab, one_smul]
  have key2 : y - (a • x + b • y) = a • (y - x) := by
    calc y - (a • x + b • y)
        = (a • y + b • y) - (a • x + b • y) := by rw [← heqy]
      _ = a • y - a • x := by abel
      _ = a • (y - x) := by rw [smul_sub]
  rw [key1, inner_smul_right] at hx
  rw [key2, inner_smul_right] at hy
  -- hx : f x ≥ f z + b * inner g (x - y)
  -- hy : f y ≥ f z + a * inner g (y - x)
  -- Rewrite inner g (y - x) = -inner g (x - y)
  have anti : inner (𝕜 := ℝ) g (y - x) = -inner (𝕜 := ℝ) g (x - y) := by
    rw [← neg_sub x y, inner_neg_right]
  rw [anti] at hy
  -- hx : f x ≥ f z + b * c,  hy : f y ≥ f z + a * (-c)  where c = inner g (x - y)
  set fz := f (a • x + b • y)
  set c : ℝ := inner (𝕜 := ℝ) g (x - y)
  -- Explicit degree-2 witnesses:
  -- w1: 0 ≤ a * (f x - fz - b * c)  from ha and hx
  -- w2: 0 ≤ b * (f y - fz + a * c)  from hb and hy
  have w1 : (0 : ℝ) ≤ a * (f x - fz - b * c) :=
    mul_nonneg ha (by linarith)
  have w2 : (0 : ℝ) ≤ b * (f y - fz + a * c) :=
    mul_nonneg hb (by linarith)
  -- a*fz + b*fz = (a+b)*fz = fz
  have h4 : a * fz + b * fz = fz :=
    calc a * fz + b * fz = (a + b) * fz := by ring
      _ = fz := by rw [hab, one_mul]
  -- Goal uses a • f x  which equals a * f x for ℝ
  simp only [smul_eq_mul]
  -- Linear arithmetic: sum w1+w2 (expanded via h1,h2) + cancellation h3,h4 → goal
  linarith

/-- **Proposition 1.5** (Bubeck §1.2), part 2:
    A convex (and continuous) function has nonempty subdifferential at every point. -/
theorem proposition_1_5_subgradient_nonempty
    {f : E → ℝ}
    (hf : ConvexOn ℝ univ f)
    (hc : ContinuousOn f univ) :
    ∀ x, (SubderivAt f x).Nonempty :=
  fun x => Set.nonempty_coe_sort.mp (SubderivAt.nonempty hf hc x)

/-- **Proposition 1.5** (Bubeck §1.2), part 3:
    If f is convex and differentiable at x then ∇f(x) is a subgradient of f at x. -/
theorem proposition_1_5_gradient_is_subgradient
    {f : E → ℝ} {x f'x : E}
    (hf : ConvexOn ℝ univ f)
    (hd : HasGradientAt f f'x x) :
    HasSubgradientAt f f'x x := by
  have hmem : f'x ∈ SubderivAt f x := by
    rw [SubderivAt_eq_gradient hf hd]
    exact Set.mem_singleton f'x
  simp only [SubderivAt, Set.mem_setOf_eq] at hmem
  exact hmem
