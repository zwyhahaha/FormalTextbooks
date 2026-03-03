# Informal Proof: Grünbaum's Theorem (Lemma 2.2)

## Sources
- [Grünbaum (1960) — "Partitions of mass-distributions and of convex bodies by hyperplanes", Pacific J. Math. 10(4)](https://projecteuclid.org/journals/pacific-journal-of-mathematics/volume-10/issue-4/Partitions-of-mass-distributions-and-of-convex-bodies-by-hyperplanes/pjm/1103038065.pdf)
- [MIT OCW 18.409 Lecture 13 — Brunn-Minkowski, Grünbaum's inequality](https://ocw.mit.edu/courses/18-409-topics-in-theoretical-computer-science-an-algorithmists-toolkit-fall-2009/24a211eecdfd8fb9a6092a4c2acf14cf_MIT18_409F09_scribe13.pdf)
- [Vempala — Algorithmic Convex Geometry lecture notes](https://faculty.cc.gatech.edu/~vempala/acg/notes.pdf)
- [Wikipedia — Brunn–Minkowski theorem](https://en.wikipedia.org/wiki/Brunn%E2%80%93Minkowski_theorem)

## Theorem Statement

Let 𝒦 ⊆ ℝⁿ be a convex measurable set with finite volume, centered at the origin
(i.e., ∫_{x ∈ 𝒦} x dx = 0). For any nonzero direction w ∈ ℝⁿ, the positive
halfspace captures at least 1/e of the volume:

  Vol(𝒦 ∩ {x ∈ ℝⁿ : ⟨x, w⟩ ≥ 0}) ≥ (1/e) · Vol(𝒦)

Equivalently in the Lean statement:
  μ(𝒦) / e ≤ μ(𝒦 ∩ {x | 0 ≤ ⟪x, w⟫_ℝ})

## Proof Steps

### Step 1: Affine Invariance / WLOG Reduction

**English:** The bound is affine-invariant: if T : ℝⁿ → ℝⁿ is an invertible affine
map, then Vol(T(𝒦) ∩ H) / Vol(T(𝒦)) = Vol(𝒦 ∩ T⁻¹(H)) / Vol(𝒦) (the Jacobian
cancels). Since the centroid also transforms affinely, we may assume WLOG that
the direction w is the first standard basis vector e₁, so the halfspace becomes
{x : x₁ ≥ 0}. The centroid condition ∫_{𝒦} x dx = 0 fixes the "center" at origin.

**Math:** WLOG w = e₁. Define:
  K₊ = 𝒦 ∩ {x : x₁ ≥ 0},   K₋ = 𝒦 ∩ {x : x₁ ≤ 0}
We need to show Vol(K₊) ≥ (1/e) · Vol(𝒦).

**Lean/Mathlib hint:** `AffineMap.volume_image`, `MeasureTheory.Measure.map_apply`,
`LinearEquiv.det`; in practice this step is handled by "assume e₁ WLOG" in the
informal proof and doesn't need explicit Lean tactics — state the theorem directly
with w : E and ⟪x, w⟫_ℝ.

**Sorry prediction:** no — WLOG is implicit in the statement; no Lean tactic needed.

---

### Step 2: Slicing via Brunn-Minkowski (Concavity of Cross-Section Volumes)

**English:** For each t ∈ ℝ, define the cross-section slice of 𝒦 at height t along w:
  𝒦_t = {x' ∈ ℝⁿ⁻¹ : (t, x') ∈ 𝒦}
By the Brunn-Minkowski inequality, the function t ↦ Vol_{n-1}(𝒦_t)^{1/(n-1)} is
concave on its support [a, b] (where a ≤ 0 ≤ b since the centroid is at 0).
Because the centroid is 0, the 1D moment vanishes:
  ∫ t · Vol_{n-1}(𝒦_t) dt = 0
This pins the "center of mass" of the profile function at t = 0.

**Math:** Let v(t) = Vol_{n-1}(𝒦_t). By B-M: v(t)^{1/(n-1)} is concave on [a, b].
Centroid condition: ∫_{a}^{b} t · v(t) dt = 0, so ∫₀^b t·v(t) dt = -∫_a^0 t·v(t) dt.

**Lean/Mathlib hint:**
- `MeasureTheory.integral_comp_mul_right` for Fubini slicing
- `Convex.inner_smul_le_inner_smul_iff` for concavity
- The Brunn-Minkowski slicing form is NOT currently in Mathlib 4 — needs `sorry`
- Search: `MeasureTheory.MeasurePreserving` for slicing decomposition

**Sorry prediction:** yes — the Brunn-Minkowski concavity of slices is the core
gap; not available in Mathlib4 in this form.

---

### Step 3: Reduction to Cone (Worst Case)

**English:** The concavity of v(t)^{1/(n-1)} and the centroid-pinning condition
together imply that the worst case (minimum Vol(K₊)/Vol(𝒦)) is achieved by a
cone: a convex body where the profile v(t) is linear (i.e., a right cone with
apex at a and base at b). For the cone, the centroid lies at b·n/(n+1), i.e.,
x₁ coordinate of centroid = b/(n+1)·n = 0 requires a specific ratio of a to b.
Concretely: for a cone in ℝⁿ with apex at (-a) and base at b (both positive),
the centroid-at-0 condition forces a/b = 1/n, so b = n·a.

**Math:** For a cone: v(t) = C·(t - a)^{n-1} for t ∈ [a, b], a < 0 < b.
Centroid = 0 implies ∫_a^b t·(t-a)^{n-1} dt = 0, giving b = -n·a.
Volume ratio:
  Vol(K₊)/Vol(𝒦) = ∫_0^b (t-a)^{n-1}dt / ∫_a^b (t-a)^{n-1}dt
                  = (b-a+a)ⁿ/... [after substitution]
                  = (n/(n+1))ⁿ

**Lean/Mathlib hint:**
- `integral_pow` for ∫ t^n dt bounds
- `Real.rpow_natCast` for (n/(n+1))^n
- The reduction "worst case is cone" requires `sorry` — needs a variational argument
  or the Prékopa-Leindler inequality; not in Mathlib4

**Sorry prediction:** yes — the variational argument that the cone achieves the
minimum is not formalized in Mathlib4.

---

### Step 4: Inequality (1 − 1/n)ⁿ ≥ 1/e

**English:** The cone gives Vol(K₊)/Vol(𝒦) = (n/(n+1))ⁿ = (1 - 1/(n+1))ⁿ.
As n → ∞ this tends to 1/e from above. For all finite n ≥ 1:
  (n/(n+1))ⁿ ≥ 1/e = exp(-1)
This follows from ln(n/(n+1)) = ln(1 - 1/(n+1)) ≥ -1/(n+1)·(n+1)/(n) = -1/n
and n · ln(1 - 1/(n+1)) ≥ -n/(n+1) > -1.
So the worst-case ratio is (1-1/(n+1))ⁿ ≥ 1/e.

**Math:**
  (n/(n+1))ⁿ = exp(n · ln(n/(n+1)))
             = exp(-n · ln(1 + 1/n))
             ≥ exp(-n · (1/n))          [since ln(1+x) ≤ x for x > 0]
             = exp(-1) = 1/e

**Lean/Mathlib hint:**
- `Real.add_one_le_exp` or `Real.log_le_sub_one_of_le`: `log(1+x) ≤ x`
- `Real.exp_ge_one_add_of_nonneg`: for lower bounds on exp
- `Real.log_le_log_iff`, `Real.exp_le_exp`
- `Finset.prod_le_prod` for the product form
- This step is **provable in Lean** without sorry using Real.log bounds

**Sorry prediction:** no — standard real analysis lemmas in Mathlib4 suffice.

---

## Mathlib Gaps

The formalization of Grünbaum's theorem currently has two fundamental gaps in Mathlib4:

1. **Brunn-Minkowski slicing inequality** (Step 2): The statement that
   `Vol_{n-1}(𝒦_t)^{1/(n-1)}` is a concave function of t for a convex body 𝒦
   is NOT in Mathlib4. It requires the Prékopa-Leindler inequality or a direct
   Brunn-Minkowski argument on slices. Confirmed absent via `lean_loogle` search
   for `BrunnMinkowski` and `concave slices`.

2. **Variational optimality of the cone** (Step 3): The argument that among all
   convex bodies with a fixed centroid constraint, the cone achieves the minimum
   halfspace-volume ratio is a sophisticated variational argument (related to the
   Prékopa-Leindler inequality). Not in Mathlib4.

3. **Brunn-Minkowski in full generality**: `Mathlib.MeasureTheory.Group.GeometryOfNumbers`
   contains Minkowski's theorem for lattices but NOT the volume Brunn-Minkowski
   inequality `Vol(A+B)^{1/n} ≥ Vol(A)^{1/n} + Vol(B)^{1/n}`.

## Status
PROOF FOUND — classical proof fully understood; Steps 2–3 need `sorry` in Lean4
due to missing Mathlib lemmas (Brunn-Minkowski slicing, cone-optimality).
Final implementation will be `partial` status.
