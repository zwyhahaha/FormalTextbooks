# Theorem 2.1

[Bubeck Convex Optimization](../index.md) / [Chapter 2](../chapters/chapter-2.md) / [Section 2.1](../sections/section-2-1-the-center-of-gravity-method.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-partial">Partial</span>

**Roadmap context:** <span class="roadmap-pill roadmap-critical">Critical</span> Stabilize the finite-dimensional geometry chapter by isolating the deepest geometric gaps and sequencing the provable matrix lemmas around them.

## Informal Statement

**Theorem**

The center of gravity method satisfies

\[
f(x_t) - \min_{x \in \mathcal{X}} f(x) \leq 2 B \left(1 - \frac1{e} \right)^{t/n} .
\]

Before proving this result a few comments are in order. 

To attain an $\epsilon$-optimal point the center of gravity method requires $O( n \log (2 B / \epsilon))$ queries to both the first and zeroth order oracles. It can be shown that this is the best one can hope for, in the sense that for $\epsilon$ small enough one needs $\Omega(n \log(1/ \epsilon))$ calls to the oracle in order to find an $\epsilon$-optimal point, see \cite{NY83} for a formal proof.

The rate of convergence given by Theorem \ref{th:centerofgravity} is exponentially fast. In the optimization literature this is called a {\em linear rate} as the (estimated) error at iteration $t+1$ is linearly related to the error at iteration $t$.

The last and most important comment concerns the computational complexity of the method. It turns out that finding the center of gravity $c_t$ is a very difficult problem by itself, and we do not have computationally efficient procedure to carry out this computation in general. In Section \ref{sec:rwmethod} we will discuss a relatively recent (compared to the 50 years old center of gravity method!) randomized algorithm to approximately compute the center of gravity. This will in turn give a randomized center of gravity method which we will describe in detail.

We now turn to the proof of Theorem \ref{th:centerofgravity}. We will use the following elementary result from convex geometry:

## Lean Formalization

Symbol: `theorem_2_1_center_of_gravity`

```lean
/-- **Theorem 2.1** (Bubeck §2.1): Convergence of the center of gravity method.

Given a convex body 𝒳 ⊆ E, a convex function f : E → ℝ bounded by B, and
sequences S_k, c_k, w_k encoding t steps of the algorithm:
  f(x_t) - min_{x ∈ 𝒳} f(x) ≤ 2 * B * (1 − 1/e)^(t/n)

where n = finrank ℝ E and x_t = argmin_{k < t} f(c_k).

**Dependencies:** Uses `cog_volume_decrease` (and hence Lemma 2.2, sorry). -/
theorem theorem_2_1_center_of_gravity
    (μ : Measure E) [Measure.IsAddHaarMeasure μ]
    -- Convex body 𝒳 ⊆ E
    {𝒳 : Set E}
    (h𝒳_compact   : IsCompact 𝒳)
    (h𝒳_convex    : Convex ℝ 𝒳)
    (h𝒳_interior  : (interior 𝒳).Nonempty)
    -- Convex function f : E → ℝ with |f| ≤ B on 𝒳
    {f : E → ℝ} {B : ℝ} (hB : 0 < B)
    (hf_convex    : ConvexOn ℝ 𝒳 f)
    (hf_bounded   : ∀ x ∈ 𝒳, |f x| ≤ B)
    -- Algorithm sequences (0-indexed, length t)
    (S : ℕ → Set E)  -- constraint sets
    (c : ℕ → E)      -- centroids
    (w : ℕ → E)      -- subgradients
    -- Algorithm invariants
    (hS_init     : S 0 = 𝒳)
    (hS_convex   : ∀ k, Convex ℝ (S k))
    (hS_meas     : ∀ k, MeasurableSet (S k))
    (hS_finite   : ∀ k, μ (S k) < ⊤)
    (hS_pos      : ∀ k, (μ (S k)).toReal > 0)
    (hS_sub      : ∀ k, S k ⊆ 𝒳)
    -- c_k is the centroid of S_k: ∫_{S_k} x dμ = vol(S_k) · c_k
    (hc_centroid : ∀ k, ∫ x in S k, x ∂μ = (μ (S k)).toReal • c k)
    -- c_k ∈ 𝒳 (centroid of a subset of 𝒳 lies in 𝒳 by convexity)
    (hc_mem      : ∀ k, c k ∈ 𝒳)
    -- w_k is a subgradient of f at c_k within 𝒳
    (hw_sub      : ∀ k, HasSubgradientWithinAt f (w k) 𝒳 (c k))
    -- w_k ≠ 0 (non-degenerate; if w_k = 0 then c_k is already optimal)
    (hw_ne       : ∀ k, w k ≠ 0)
    -- Algorithm step: S_{k+1} = S_k ∩ {x : ⟪x − c_k, w_k⟫ ≤ 0}
    (hS_step     : ∀ k, S (k + 1) = S k ∩ {x | ⟪x - c k, w k⟫ ≤ 0})
    -- Number of steps
    (t : ℕ) :
    (⨅ k ∈ Finset.range t, f (c k)) - ⨅ x ∈ 𝒳, f x ≤
      2 * B * (1 - 1 / exp 1) ^ ((t : ℝ) / (Module.finrank ℝ E : ℝ)) := by
  -- PROOF (all steps are sorry, see proof outline in module doc):
  --
  -- Step 1 — Optimum invariant (proved by induction):
  --   Let xstar := argmin_{𝒳} f.  Claim: xstar ∈ S k for all k.
  --   Base: xstar ∈ 𝒳 = S 0.
  --   Inductive step: assume xstar ∈ S k.
  --     By hw_sub k:  ∀ y ∈ 𝒳, f (c k) + ⟪w k, y − c k⟫ ≤ f y.
  --     Set y = xstar: f (c k) + ⟪w k, xstar − c k⟫ ≤ f xstar.
  --     Since c k ∈ 𝒳 and xstar is optimal: f xstar ≤ f (c k).
  --     Therefore ⟪w k, xstar − c k⟫ ≤ 0, i.e. ⟪xstar − c k, w k⟫ ≤ 0.
  --     So xstar ∈ {x : ⟪x − c k, w k⟫ ≤ 0} ∩ S k = S (k+1).
  --
  -- Step 2 — Volume decrease (by cog_volume_decrease):
  --   μ (S (k+1)) ≤ (1 − 1/e) * μ (S k)   for all k.
  --   (Requires hw_ne k for the w ≠ 0 condition of Lemma 2.2.)
  --
  -- Step 3 — Cumulative volume bound (by induction from Step 2):
  --   μ (S t) ≤ ENNReal.ofReal ((1 − 1/e)^t) * μ 𝒳.
  --
  -- Step 4 — ε-scaling argument:
  --   Let n := Module.finrank ℝ E.
  --   The set 𝒳_ε := (1−ε) • xstar + ε • 𝒳 is a scaled copy of 𝒳.
  --   By the n-homogeneity of Haar measure: μ 𝒳_ε = ε^n * μ 𝒳.
  --   For ε := (1−1/e)^(t/n), we get μ 𝒳_ε = (1−1/e)^t * μ 𝒳 ≥ μ (S t).
  --   So 𝒳_ε ⊄ S_t: there exists k < t and x_ε ∈ 𝒳_ε with
  --     x_ε ∈ S k but x_ε ∉ S (k+1).
  --   Since x_ε ∉ S (k+1) = S k ∩ {⟪x−c k, w k⟫ ≤ 0}:
  --     ⟪x_ε − c k, w k⟫ > 0.
  --   By subgradient (hw_sub k) at y = x_ε:
  --     f x_ε ≥ f (c k) + ⟪w k, x_ε − c k⟫ > f (c k).
  --   By convexity of f and x_ε = (1−ε)·xstar + ε·y for some y ∈ 𝒳:
  --     f x_ε ≤ (1−ε) * f xstar + ε * f y ≤ f xstar + ε * 2 * B.
  --   Therefore f (c k) < f xstar + 2 * B * ε.
  --   Since x_t = argmin_{k<t} f(c_k), we get f(x_t) ≤ f(c_k) < f xstar + 2Bε.
  --
```

## Metadata

| Field | Value |
|-------|-------|
| Display name | Theorem 2.1 |
| Proof file status | `present` |
| Tracker status | `partial` |
| Computed status | `partial` |
| Proof time | 7m 23s |
| Lean file | [proofs/Bubeck_convex_optimization/Theorem21.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem21.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/02_01_the_center_of_gravity_method.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/02_01_the_center_of_gravity_method.md) |

## Dependencies

- Chapter 2 depends on finite-dimensional measure lemmas and matrix identities not needed in Chapter 1.

## Chapter Blockers

- Brunn-Minkowski slicing and cone-optimality arguments are still outside the current Mathlib surface area.
- Several chapter theorems depend on measure-theoretic and matrix-analytic lemmas that are not yet factored into reusable modules.

## Nearby Results

- Previous: [Lemma 2.2](./lemma-2-2.md)
- Next: [Lemma 2.3](./lemma-2-3.md)
