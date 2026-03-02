import Optlib.Convex.ConvexFunction

set_option linter.unusedSectionVars false

/-!
# Definition 1.1 — Convex sets and convex functions

Source: papers/Bubeck_convex_optimization/sections/01_00_introduction.md

The book defines:

**Convex set**: A set 𝒳 ⊆ ℝⁿ is convex if it contains all its line segments:
  ∀ x, y ∈ 𝒳, ∀ γ ∈ [0,1],  (1−γ)x + γy ∈ 𝒳

**Convex function**: A function f : 𝒳 → ℝ is convex if it lies below its chords:
  ∀ x, y ∈ 𝒳, ∀ γ ∈ [0,1],  f((1−γ)x + γy) ≤ (1−γ)f(x) + γf(y)

These are precisely Mathlib's `Convex ℝ 𝒳` and `ConvexOn ℝ 𝒳 f`, with the
substitution  a = 1−γ,  b = γ  (so a+b = 1, a ≥ 0, b ≥ 0).
-/

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]

/-- **Definition 1.1** (Bubeck §1), convex sets.

A set `𝒳` is convex in Mathlib's sense if and only if it satisfies the book's
chord condition: for all `x, y ∈ 𝒳` and `γ ∈ [0,1]`, the point `(1−γ)•x + γ•y`
belongs to `𝒳`. -/
theorem definition_1_1_convex_set (𝒳 : Set E) :
    Convex ℝ 𝒳 ↔
    ∀ x ∈ 𝒳, ∀ y ∈ 𝒳, ∀ γ : ℝ, 0 ≤ γ → γ ≤ 1 →
      (1 - γ) • x + γ • y ∈ 𝒳 := by
  constructor
  · intro h x hx y hy γ hγ hγ1
    exact h hx hy (by linarith) hγ (by ring)
  · intro h x hx y hy a b ha hb hab
    have hb1 : b ≤ 1 := by linarith
    have key := h x hx y hy b hb hb1
    rwa [show a = 1 - b by linarith]

/-- **Definition 1.1** (Bubeck §1), convex functions.

A function `f : E → ℝ` is `ConvexOn ℝ 𝒳 f` in Mathlib's sense if and only if
`𝒳` is convex and `f` satisfies the book's chord condition:
for all `x, y ∈ 𝒳` and `γ ∈ [0,1]`,  `f((1−γ)•x + γ•y) ≤ (1−γ)•f(x) + γ•f(y)`. -/
theorem definition_1_1_convex_function (𝒳 : Set E) (f : E → ℝ) :
    ConvexOn ℝ 𝒳 f ↔
    Convex ℝ 𝒳 ∧
    ∀ x ∈ 𝒳, ∀ y ∈ 𝒳, ∀ γ : ℝ, 0 ≤ γ → γ ≤ 1 →
      f ((1 - γ) • x + γ • y) ≤ (1 - γ) • f x + γ • f y := by
  rw [ConvexOn]
  constructor
  · rintro ⟨hconv, hf⟩
    refine ⟨hconv, fun x hx y hy γ hγ hγ1 => ?_⟩
    have := hf hx hy (by linarith : (0 : ℝ) ≤ 1 - γ) hγ (by ring)
    simpa using this
  · rintro ⟨hconv, hf⟩
    refine ⟨hconv, fun x hx y hy a b ha hb hab => ?_⟩
    have hb1 : b ≤ 1 := by linarith
    have key := hf x hx y hy b hb hb1
    rw [show a = 1 - b by linarith]
    simpa using key
