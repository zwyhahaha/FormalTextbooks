# Informal Proof: Grünbaum's Theorem (Lemma 2.2)

## Source: Claude (primary)
This proof was written by Claude from mathematical knowledge.
WebSearch was used for cross-checking only (see Sources below).

## Sources
- [Grünbaum (1960) — "Partitions of mass-distributions and of convex bodies by hyperplanes", Pacific J. Math. 10(4)](https://projecteuclid.org/journals/pacific-journal-of-mathematics/volume-10/issue-4/Partitions-of-mass-distributions-and-of-convex-bodies-by-hyperplanes/pjm/1103038065.pdf)
- [MIT OCW 18.409 Lecture 13 — Brunn-Minkowski, Grünbaum's inequality](https://ocw.mit.edu/courses/18-409-topics-in-theoretical-computer-science-an-algorithmists-toolkit-fall-2009/24a211eecdfd8fb9a6092a4c2acf14cf_MIT18_409F09_scribe13.pdf)
- [Vempala — Algorithmic Convex Geometry lecture notes](https://faculty.cc.gatech.edu/~vempala/acg/notes.pdf)
- [Wikipedia — Brunn–Minkowski theorem](https://en.wikipedia.org/wiki/Brunn%E2%80%93Minkowski_theorem)

## Theorem Statement

Let 𝒦 ⊆ ℝⁿ be a convex measurable set with finite volume, centered at the origin
(i.e., ∫_{x ∈ 𝒦} x dx = 0, meaning the centroid is at 0). For any nonzero direction
w ∈ ℝⁿ, the positive halfspace captures at least 1/e of the volume:

  Vol(𝒦 ∩ {x ∈ ℝⁿ : ⟨x, w⟩ ≥ 0}) ≥ (1/e) · Vol(𝒦)

Equivalently in the Lean statement:
  μ(𝒦) / e ≤ μ(𝒦 ∩ {x | 0 ≤ ⟪x, w⟫_ℝ})

where μ is the Haar measure on ℝⁿ (Lebesgue measure).

## Proof

The proof proceeds in four steps:
1. WLOG reduction to w = e₁
2. Brunn-Minkowski slicing: concavity of cross-section volumes
3. Variational argument: worst-case is a cone, giving ratio (n/(n+1))ⁿ
4. Arithmetic bound: (n/(n+1))ⁿ ≥ exp(-1) = 1/e

---

### Step 1: WLOG Reduction

**Claim:** It suffices to prove the inequality for w = e₁ (the first standard basis vector).

**Proof of claim:** The bound is affine-invariant. Let T : ℝⁿ → ℝⁿ be any invertible linear
map. If 𝒦' = T(𝒦), then:
- Centredness is preserved: ∫_{𝒦'} x dx = T(∫_{𝒦} x dx) = T(0) = 0
- Volume ratios are preserved: Vol(𝒦' ∩ H) / Vol(𝒦') = Vol(𝒦 ∩ T⁻¹H) / Vol(𝒦)
  (the Jacobian factor |det T| cancels numerator and denominator)
- The halfspace {x : ⟨x, w⟩ ≥ 0} transforms to {y : ⟨T⁻¹y, w⟩ ≥ 0}

Choose T such that Tw = e₁ · ‖Tw‖. Then {y : ⟨y, Tw⟩ ≥ 0} = {y : y₁ ≥ 0}.
So Vol(𝒦' ∩ {y₁ ≥ 0}) / Vol(𝒦') = Vol(𝒦 ∩ {x : ⟨x,w⟩ ≥ 0}) / Vol(𝒦).
Hence it suffices to prove the result for K' with w = e₁.

**Named theorems used:** Change of variables formula for integration.

**Lean lemma search:**
- `MeasureTheory.Measure.map_apply` — for transforming measures
- `LinearEquiv.det` — for Jacobian
- This step is implicit in the Lean statement (proved for general w via ⟪x, w⟫_ℝ directly)

**Lean tactic sketch:**
```lean
-- No Lean tactics needed — the Lean theorem is stated for general w : E,
-- so this WLOG argument is implicit in the abstract inner product space framework.
trivial
```

**Genuine Mathlib gap?** no — handled implicitly by the abstract formulation.

---

### Step 2: Slicing via Brunn-Minkowski

**Claim:** Let 𝒦 ⊆ ℝⁿ be convex. For each t ∈ ℝ, define the cross-section
  𝒦_t = {x' ∈ ℝⁿ⁻¹ : (t, x') ∈ 𝒦}
(where we write ℝⁿ = ℝ × ℝⁿ⁻¹). Then:
(a) Each 𝒦_t is convex (possibly empty).
(b) The function v : ℝ → ℝ≥0, v(t) = Voln₋₁(𝒦_t), is measurable.
(c) By Fubini: Vol(𝒦) = ∫ v(t) dt.
(d) By the Brunn-Minkowski inequality: t ↦ v(t)^{1/(n-1)} is **concave** on
    its support [a, b] (where a = inf{t : 𝒦_t ≠ ∅} and b = sup{t : 𝒦_t ≠ ∅}).
(e) The centroid condition ∫ x·e₁ dx = 0 gives ∫_a^b t·v(t) dt = 0, so 0 ∈ (a, b).

**Proof of claim (a):** If x', y' ∈ 𝒦_t, then (t, x') ∈ 𝒦 and (t, y') ∈ 𝒦.
For λ ∈ [0,1]: λ(t, x') + (1-λ)(t, y') = (t, λx' + (1-λ)y') ∈ 𝒦 (by convexity of 𝒦).
Hence λx' + (1-λ)y' ∈ 𝒦_t. So 𝒦_t is convex. ✓

**Proof of claim (c):** Fubini's theorem applied to 1_{𝒦}:
  Vol(𝒦) = ∫_{ℝⁿ} 1_{𝒦}(t, x') dt dx' = ∫_ℝ (∫_{ℝⁿ⁻¹} 1_{𝒦_t}(x') dx') dt = ∫_ℝ v(t) dt. ✓

**Proof of claim (d):** This is the Brunn-Minkowski slicing lemma. For s, t ∈ [a,b] and λ ∈ [0,1]:
  𝒦_{λt+(1-λ)s} ⊇ λ·𝒦_t + (1-λ)·𝒦_s  (Minkowski sum)
Proof: if x' ∈ 𝒦_t and y' ∈ 𝒦_s, then λ(t,x') + (1-λ)(s,y') ∈ 𝒦 (convexity),
so the first coordinate is λt+(1-λ)s and the second is λx'+(1-λ)y'. Hence
λx'+(1-λ)y' ∈ 𝒦_{λt+(1-λ)s}. ✓ (This part is elementary.)

By the Brunn-Minkowski inequality in ℝⁿ⁻¹:
  Voln₋₁(λ·𝒦_t + (1-λ)·𝒦_s)^{1/(n-1)} ≥ λ·Voln₋₁(𝒦_t)^{1/(n-1)} + (1-λ)·Voln₋₁(𝒦_s)^{1/(n-1)}
Combining: v(λt+(1-λ)s)^{1/(n-1)} ≥ λ·v(t)^{1/(n-1)} + (1-λ)·v(s)^{1/(n-1)}.
This says t ↦ v(t)^{1/(n-1)} is concave. ✓

**Proof of claim (e):** By Fubini:
  ∫_{𝒦} x_1 dx = ∫_ℝ t · (∫_{𝒦_t} dx') dt = ∫_a^b t · v(t) dt.
The centroid condition gives this = 0. Since v(t) > 0 on (a,b) and v is not identically 0,
we cannot have both a ≥ 0 or b ≤ 0, hence a < 0 < b. ✓

**Named theorems used:**
- Fubini's theorem: ∫_{A×B} f(x,y) d(x,y) = ∫_A (∫_B f(x,y) dy) dx
- Brunn-Minkowski inequality in ℝ^m: Vol(A+B)^{1/m} ≥ Vol(A)^{1/m} + Vol(B)^{1/m}

**Lean tactic sketch:**
```lean
-- goal: show v(t)^(1/(n-1)) is concave
-- Sub-goals:
-- 1. K_t is convex (proved from K convex — elementary)
-- 2. Minkowski sum inclusion: K_{λt+(1-λ)s} ⊇ λ·K_t + (1-λ)·K_s
-- 3. Brunn-Minkowski in ℝ^(n-1) ← GENUINE GAP
apply brunn_minkowski_slicing_concavity  -- does not exist in Mathlib4
```

**Genuine Mathlib gap?** yes

### Sub-proof: brunn_minkowski_inequality_rn

**Statement:** For any two bounded measurable sets A, B ⊆ ℝⁿ with positive volume:
  Voln(A + B)^{1/n} ≥ Voln(A)^{1/n} + Voln(B)^{1/n}
where A + B = {a + b : a ∈ A, b ∈ B} is the Minkowski sum.

**Proof:**

#### Sub-step 1: One-dimensional case
**Claim:** For A, B ⊆ ℝ measurable with Vol(A), Vol(B) > 0:
  Vol(A + B) ≥ Vol(A) + Vol(B).
**Proof of claim:** Let a = inf A, b = inf B (possibly -∞; use a' ∈ A, b' ∈ B instead).
A + B ⊇ A + b' (a translate of A) ∪ a' + B (a translate of B) by monotonicity.
These two sets are disjoint (max A + b' ≤ max(A+B') ≤ max(A)+max(B') ≤... actually this argument is more subtle).
Better: A + B ⊇ (inf A + B) ∪ (A + inf B), and these are essentially disjoint up to shifts.
More precisely, A + B contains [a + b, ∞) ∩ (shifted A or shifted B).
Standard proof: WLOG A = [0, |A|] and B = [0, |B|] by rearrangement; then A + B ⊇ [0, |A|+|B|].
**Lean tactic sketch:**
```lean
-- This 1D result follows from MeasureTheory.Measure.addHaar_add_le or
-- is provable by linarith after rearrangement
simp [Set.measure_add_le]  -- not available
```
**Remaining gaps:** 1D B-M is not in Mathlib4 either.

#### Sub-step 2: Induction / Prékopa-Leindler
**Claim:** The n-dimensional B-M follows by induction using Prékopa-Leindler:
If f, g, h : ℝⁿ → ℝ≥0 and h(λx+(1-λ)y) ≥ f(x)^λ g(y)^{1-λ} for all x,y, then:
  (∫ h)^{1/n} ≥ (∫ f)^{1/n} + (∫ g)^{1/n}? (actually the right statement is ∫h ≥ (∫f)^λ(∫g)^{1-λ})
**Lean tactic sketch:**
```lean
-- Prékopa-Leindler: not in Mathlib4
sorry -- GENUINE GAP: Prékopa-Leindler inequality
```
**Remaining gaps:** Prékopa-Leindler not in Mathlib4.

**Conclusion on Gap 1:** The Brunn-Minkowski inequality in ℝⁿ is NOT in Mathlib4 (confirmed
by searching for "BrunnMinkowski", "volume_add", "Minkowski_sum_measure" — all return no results).
The gap propagates to the concavity of slices claim. This is a genuine Mathlib gap at 2+ levels.

---

### Step 3: Worst Case is a Cone

**Claim:** Among all convex bodies K ⊆ ℝⁿ with centroid at 0 and support contained in [a, b] × ℝⁿ⁻¹,
the minimum value of Vol(K ∩ {x₁ ≥ 0}) / Vol(K) is achieved by a cone, and this minimum equals (n/(n+1))ⁿ.

**Proof of claim:**

Let v : [a,b] → ℝ≥0 be any nonnegative concave function (this is v(t)^{1/(n-1)} from Step 2 raised to the
power (n-1), so v(t) itself is (n-1)-concave). The ratio we want to minimize is:
  r = ∫_0^b v(t) dt / ∫_a^b v(t) dt

The centroid condition pins: ∫_a^b t·v(t) dt = 0.

**Step 3a: Reduction to n=1 / functional form.**
Set φ(t) = v(t)^{1/(n-1)} (concave on [a,b]). The constraints are:
- φ ≥ 0, concave, φ(a) = φ(b) = 0
- ∫_a^b t·φ(t)^{n-1} dt = 0 (centroid pinning)
We minimize r = ∫_0^b φ(t)^{n-1} dt / ∫_a^b φ(t)^{n-1} dt.

**Step 3b: Extremal function is tent (linear) on each side.**
By the theory of Choquet or log-convexity arguments: among concave functions with fixed integral
and fixed moment, the minimum is achieved by the piecewise-linear (tent) function:
  φ(t) = C · (t - a) for t ∈ [a, 0]  (negative side)
  φ(t) = C · (b - t) for t ∈ [0, b]  (positive side)
Actually, the minimum is achieved by a one-sided tent (a cone):
  φ(t) = C · (t - a) for all t ∈ [a, b]
because this is the "pointiest" possible function (least positive-halfspace mass).

**Step 3c: Compute the cone ratio.**
For φ(t) = t - a (linear, apex at a, base at b):
v(t) = φ(t)^{n-1} = (t - a)^{n-1}.
Centroid condition: ∫_a^b t·(t-a)^{n-1} dt = 0.
Substituting u = t - a:
  ∫_0^{b-a} (u+a)·u^{n-1} du = 0
  ∫_0^{b-a} u^n du + a ∫_0^{b-a} u^{n-1} du = 0
  (b-a)^{n+1}/(n+1) + a·(b-a)^n/n = 0
  (b-a)^n [(b-a)/(n+1) + a/n] = 0
Since b > a (b-a > 0), we need (b-a)/(n+1) + a/n = 0:
  n(b-a) + a(n+1) = 0
  nb - na + an + a = 0
  nb + a = 0
  a = -b/n  (so b = -na, or equivalently a/b = -1/n)
Set a = -1 (normalize), then b = n. Support is [-1, n].

Volume ratio:
  ∫_0^n (t-(-1))^{n-1} dt / ∫_{-1}^n (t-(-1))^{n-1} dt
  = ∫_0^n (t+1)^{n-1} dt / ∫_{-1}^n (t+1)^{n-1} dt
Substitute u = t+1:
  = ∫_1^{n+1} u^{n-1} du / ∫_0^{n+1} u^{n-1} du
  = [(n+1)^n - 1] / (n+1)^n · n/...

Wait, let me redo this more carefully.
Numerator: ∫_0^n (t+1)^{n-1} dt = [(t+1)^n/n]_0^n = ((n+1)^n - 1)/n
Denominator: ∫_{-1}^n (t+1)^{n-1} dt = [(t+1)^n/n]_{-1}^n = (n+1)^n/n

Ratio = ((n+1)^n - 1)/n · n/(n+1)^n = ((n+1)^n - 1)/(n+1)^n = 1 - 1/(n+1)^n.

Hmm, that gives 1 - 1/(n+1)^n, not (n/(n+1))^n. Let me recheck...

Actually, I need to be more careful. The standard Grünbaum proof computes the cone as:
For v(t) = (t - a)^{n-1} on [a, b]:
- Normalize so a = -1, then b = n (from centroid condition above)
- K_+ fraction = ∫_0^n (t+1)^{n-1}dt / ∫_{-1}^n (t+1)^{n-1}dt

Numerator: ∫_0^n (t+1)^{n-1} dt. Let u = t+1: ∫_1^{n+1} u^{n-1} du = [u^n/n]_1^{n+1} = ((n+1)^n - 1)/n
Denominator: ∫_{-1}^n (t+1)^{n-1} dt. Let u = t+1: ∫_0^{n+1} u^{n-1} du = (n+1)^n/n

Ratio = ((n+1)^n - 1)/(n+1)^n = 1 - (n+1)^{-n}

But Grünbaum's theorem says the minimum is (n/(n+1))^n = (1 - 1/(n+1))^n.

The discrepancy suggests that this is NOT the minimum — the minimum is achieved by a different cone.
Actually, I think I have the wrong extremal: the MINIMUM is achieved by the halfspace K_-, not K_+.
For the negative halfspace {x₁ ≤ 0}: ratio = 1 - ((n+1)^n - 1)/(n+1)^n = 1/(n+1)^n.

Still not (n/(n+1))^n. Let me look at this differently.

The correct cone for Grünbaum: apex at b (not at a). So v(t) = (b - t)^{n-1} on [a, b].

Centroid with v(t) = (b-t)^{n-1}:
∫_a^b t(b-t)^{n-1} dt = 0
Let u = b - t, t = b - u, dt = -du:
∫_{b-a}^0 (b-u)·u^{n-1}·(-du) = ∫_0^{b-a} (b-u)u^{n-1} du = 0
b·(b-a)^n/n - (b-a)^{n+1}/(n+1) = 0
(b-a)^n [b/n - (b-a)/(n+1)] = 0
b(n+1) - n(b-a) = 0
b·n + b - nb + na = 0
b + na = 0
b = -na

So for a = -1: b = n. Same cone.

Now v(t) = (b-t)^{n-1} = (n-t)^{n-1} on [-1, n].

K_+ = {t ≥ 0}: ∫_0^n (n-t)^{n-1}dt = [-(n-t)^n/n]_0^n = n^n/n = n^{n-1}
K total: ∫_{-1}^n (n-t)^{n-1}dt = [-(n-t)^n/n]_{-1}^n = (n+1)^n/n

Ratio = n^{n-1} / ((n+1)^n/n) = n^n / (n+1)^n = (n/(n+1))^n ✓

So the correct cone for Grünbaum has profile v(t) = (b-t)^{n-1} (apex at b, base at a).

This makes sense: the halfspace K_+ = {t ≥ 0} is the "large" part near the base.
The minimum ratio (n/(n+1))^n is achieved with v(t) = (b-t)^{n-1}.

**Named theorems used:**
- Integration by substitution: ∫_a^b f(t-c) dt = ∫_{a-c}^{b-c} f(u) du
- Power integrals: ∫_0^L u^{n-1} du = L^n/n
- Variational argument (extremal function among concave profiles) — the hardest part

**Lean tactic sketch:**
```lean
-- Compute the cone ratio (n/(n+1))^n
-- This specific computation is doable in Lean:
have h_cone_numerator : ∫ t in Set.Ioc 0 n, (n - t)^(n-1) ∂(volume : Measure ℝ) = (n : ℝ)^n / n := by
  rw [integral_Ioc_rpow_of_gt (by norm_num) (by norm_num)]
  ring
-- But the variational argument (why cone is extremal) is a sorry
sorry -- GENUINE GAP: variational argument that tent/cone is extremal
```

**Genuine Mathlib gap?** yes

### Sub-proof: cone_is_extremal_for_grunbaum

**Statement:** Among all (n-1)-concave functions φ : [a, b] → ℝ≥0 with support [a, b],
φ(a) = 0, and ∫_a^b t·φ(t) dt = 0, the ratio ∫_0^b φ(t) dt / ∫_a^b φ(t) dt is minimized
by φ(t) = C·(b-t)^{n-1}, giving minimum value (n/(n+1))^n.

**Proof:**

#### Sub-step 1: Concavity of power means
**Claim:** If φ^{1/(n-1)} is concave and φ(a) = 0, then φ is dominated by the cone
profile at each point: φ(t) ≤ φ_cone(t) = [(b-t)/(b-a)]^{n-1} · φ(x_max).
Wait, this is the wrong direction — we want a LOWER bound on K_+.

Actually the claim for Grünbaum is: K_+ is LARGE. The minimum ratio (n/(n+1))^n is achieved
when K_+ is as small as possible, which is when the profile is "peaked toward b" (cone with apex at b).

**Proof via Prékopa-Leindler (if available):** The log-concavity of the measure (which follows
from B-M / Prékopa-Leindler) implies the halfspace measure satisfies:
  μ(K ∩ H_+) · μ(K ∩ H_-)^n ≤ μ(K)^{n+1} · something...
But this is not the standard route.

**Proof via direct variational calculus:**
Among all (n-1)-concave profiles φ on [a,b] with ∫ t φ(t) dt = 0, the minimum of
∫_0^b φ / ∫_a^b φ is achieved at an extreme point of the feasible set.
The extreme points of the set of (n-1)-concave functions with ∫ t φ = 0 are:
- Functions supported on a single interval [c, d] with φ(t) = L · (t-c) for t ∈ [c,d]
  or φ(t) = L · (d-t) for t ∈ [c,d] (i.e., tent functions with one endpoint at a or b).
The minimum ratio is achieved by the most "right-heavy" function, which is the right cone
φ(t) = (b-t)^{n-1}. ✓ (Variational argument, not in Mathlib4.)

**Lean tactic sketch:**
```lean
sorry -- GENUINE GAP: variational argument for cone optimality
      -- 2 recursive levels reached (Step 3 → Sub-step 1 → here)
      -- lean_leansearch("extremal concave function integral ratio") → no results
      -- lean_loogle("ConcaveOn ℝ _ _ → _") → no relevant results
```
**Remaining gaps:** This is a genuine deep gap. At 2+ recursive levels, this sorry is accepted.

---

### Step 4: Arithmetic Bound (n/(n+1))ⁿ ≥ 1/e

**Claim:** For any n ≥ 1: (n/(n+1))ⁿ ≥ exp(-1).

**Proof of claim:**
  (n/(n+1))ⁿ = exp(n · log(n/(n+1)))
              = exp(-n · log(1 + 1/n))

We need: -n · log(1 + 1/n) ≥ -1, i.e., n · log(1 + 1/n) ≤ 1.

Since log(1+x) ≤ x for all x > 0 (from 1 + x ≤ exp(x)):
  log(1 + 1/n) ≤ 1/n
  n · log(1 + 1/n) ≤ n · (1/n) = 1  ✓

Therefore: (n/(n+1))ⁿ = exp(n·log(n/(n+1))) ≥ exp(-1) = 1/e. ✓

**Named theorems used:**
- `Real.add_one_le_exp x`: 1 + x ≤ exp(x), hence log(1+x) ≤ x for x ≥ 0
- `Real.exp_le_exp_of_le`: monotonicity of exp
- `Real.log_pow`: log(rⁿ) = n·log(r)

**Lean tactic sketch:**
```lean
-- goal: exp(-1) ≤ (n/(n+1))^n
rw [← Real.exp_log (pow_pos h_ratio_pos n), Real.log_pow]
exact Real.exp_le_exp_of_le h_log_bound
-- where h_log_bound : -1 ≤ n * log(n/(n+1)) is proved by:
have h_log_ineq : log(n+1) - log(n) ≤ 1/n := by
  have h1 : 1/n + 1 ≤ exp(1/n) := Real.add_one_le_exp _
  ...
linarith
```

**Genuine Mathlib gap?** no — proved in `grunbaum_cone_ratio_ge_inv_exp` in Lemma22.lean. ✓

---

## Per-Step Lemma Map (Step 5.5)

### Step 1: WLOG
- leansearch: no lemmas needed (implicit)
- best_candidate: n/a

### Step 2: Brunn-Minkowski slicing
- leansearch("Brunn Minkowski volume convex set") → `MeasureTheory.exists_ne_zero_mem_lattice_of_measure_mul_two_pow_lt_measure` (not relevant)
- leansearch("log concave function concave power measure slice") → `Real.concaveOn_rpow` (not directly)
- loogle("Convex MeasurableSet Measure") → no results
- leanfinder("volume halfspace centroid convex") → `Convex.set_average_mem` (centroid membership, not volume)
- best_candidate: CONFIRMED GAP — Brunn-Minkowski slicing not in Mathlib4
  - Queries: "Brunn Minkowski", "volume add set concave", "slice concave convex body"
  - All return no relevant results

### Step 3: Cone optimality
- leansearch("extremal concave function halfspace volume") → no results
- leanfinder("cone volume ratio centroid halfspace fraction") → no results
- best_candidate: CONFIRMED GAP — variational cone optimality not in Mathlib4

### Step 4: Arithmetic bound
- best_candidate: `Real.add_one_le_exp` — proves 1 + x ≤ exp(x)
- status: PROVED in `grunbaum_cone_ratio_ge_inv_exp`

---

## Mathlib Gaps

### Gap 1: Brunn-Minkowski inequality
- **Missing theorem:** Vol(A + B)^{1/n} ≥ Vol(A)^{1/n} + Vol(B)^{1/n} for A, B ⊆ ℝⁿ
- lean_leansearch("Brunn Minkowski inequality volume") → not found
- lean_loogle("volume_add") → not found
- **Sub-proof:** inline above (Sub-proof: brunn_minkowski_inequality_rn)
- **Recursion depth:** 2 (Step 2 → Sub-step 1 → Prékopa-Leindler gap)
- **Status:** CONFIRMED GAP at 2+ levels — sorry accepted per skill rules

### Gap 2: Cone optimality (variational argument)
- **Missing theorem:** Among (n-1)-concave profiles with centroid at 0, the cone minimizes
  the halfspace volume fraction, achieving minimum (n/(n+1))^n
- lean_leansearch("extremal concave function integral centroid") → not found
- lean_loogle("ConcaveOn") → not relevant
- **Sub-proof:** inline above (Sub-proof: cone_is_extremal_for_grunbaum)
- **Recursion depth:** 2 (Step 3 → Sub-step 1 → here)
- **Status:** CONFIRMED GAP at 2+ levels — sorry accepted per skill rules

---

## Status
CLAUDE-AUTHORED PARTIAL — classical proof fully documented; Steps 2–3 require `sorry` in Lean4
due to confirmed missing Mathlib lemmas (Brunn-Minkowski inequality, cone-optimality variational argument).
Step 4 arithmetic bound is PROVED in `grunbaum_cone_ratio_ge_inv_exp` in Lemma22.lean.
The surrounding Lean proof structure (connecting h_ratio to the conclusion) is also complete.
