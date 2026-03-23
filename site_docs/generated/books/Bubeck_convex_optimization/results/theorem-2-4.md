# Theorem 2.4

[Bubeck Convex Optimization](../index.md) / [Chapter 2](../chapters/chapter-2.md) / [Section 2.2](../sections/section-2-2-the-ellipsoid-method.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-pending">Pending</span>

**Roadmap context:** <span class="roadmap-pill roadmap-critical">Critical</span> Stabilize the finite-dimensional geometry chapter by isolating the deepest geometric gaps and sequencing the provable matrix lemmas around them.

## Informal Statement

**Theorem**

For $t \geq 2n^2 \log(R/r)$ the ellipsoid method satisfies $\{c_1, \hdots, c_t\} \cap \cX \neq \emptyset$ and

\[
f(x_t) - \min_{x \in \mathcal{X}} f(x) \leq \frac{2 B R}{r} \exp\left( - \frac{t}{2 n^2}\right) .
\]

We observe that the oracle complexity of the ellipsoid method is much worse than the one of the center gravity method, indeed the former needs $O(n^2 \log(1/\epsilon))$ calls to the oracles while the latter requires only $O(n \log(1/\epsilon))$ calls. However from a computational point of view the situation is much better: in many cases one can derive an efficient separation oracle, while the center of gravity method is basically always intractable. This is for instance the case in the context of LPs and SDPs: with the notation of Section \ref{sec:structured} the computational complexity of the separation oracle for LPs is $O(m n)$ while for SDPs it is $O(\max(m,n) n^2)$ (we use the fact that the spectral decomposition of a matrix can be done in $O(n^3)$ operations). This gives an overall complexity of $O(\max(m,n) n^3 \log(1/\epsilon))$ for LPs and $O(\max(m,n^2) n^6 \log(1/\epsilon))$ for SDPs. We note however that the ellipsoid method is almost never used in practice, essentially because the method is too rigid to exploit the potential easiness of real problems (e.g., the volume decrease given by \eqref{eq:ellipsoidlemma2} is essentially always tight).

## Lean Formalization

No Lean snippet is available yet because the proof file does not exist.

## Metadata

| Field | Value |
|-------|-------|
| Display name | Theorem 2.4 |
| Proof file status | `missing` |
| Tracker status | `pending` |
| Computed status | `pending` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Theorem24.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem24.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/02_02_the_ellipsoid_method.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/02_02_the_ellipsoid_method.md) |

## Dependencies

- Chapter 2 depends on finite-dimensional measure lemmas and matrix identities not needed in Chapter 1.

## Chapter Blockers

- Brunn-Minkowski slicing and cone-optimality arguments are still outside the current Mathlib surface area.
- Several chapter theorems depend on measure-theoretic and matrix-analytic lemmas that are not yet factored into reusable modules.

## Nearby Results

- Previous: [Lemma 2.3](./lemma-2-3.md)
- Next: [Lemma 2.5](./lemma-2-5.md)
