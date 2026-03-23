# Theorem 3.13

[Bubeck Convex Optimization](../index.md) / [Chapter 3](../chapters/chapter-3.md) / [Section 3.5](../sections/section-3-5-lower-bounds.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-pending">Pending</span>

**Roadmap context:** <span class="roadmap-pill roadmap-high">High</span> Build a coherent first-order methods track that starts with gradient and subgradient methods, then expands toward strong convexity and acceleration.

## Informal Statement

**Theorem**

Let $t \leq n$, $L, R >0$. There exists a convex and $L$-Lipschitz function $f$ such that for any black-box procedure satisfying \eqref{eq:ass1},

\[
\min_{1 \leq s \leq t} f(x_s) - \min_{x \in \mB_2(R)} f(x) \geq  \frac{R L}{2 (1 + \sqrt{t})} .
\]

There also exists an $\alpha$-strongly convex and $L$-lipschitz function $f$ such that for any black-box procedure satisfying \eqref{eq:ass1},

\[
\min_{1 \leq s \leq t} f(x_s) - \min_{x \in \mB_2\left(\frac{L}{2 \alpha}\right)} f(x) \geq  \frac{L^2}{8 \alpha t} .
\]

Note that the above result is restricted to a number of iterations smaller than the dimension, that is $t \leq n$. This restriction is of course necessary to obtain lower bounds polynomial in $1/t$: as we saw in Chapter \ref{finitedim} one can always obtain an exponential rate of convergence when the number of calls to the oracle is larger than the dimension.

## Lean Formalization

No Lean snippet is available yet because the proof file does not exist.

## Metadata

| Field | Value |
|-------|-------|
| Display name | Theorem 3.13 |
| Proof file status | `missing` |
| Tracker status | `pending` |
| Computed status | `pending` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Theorem313.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem313.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/03_05_lower_bounds.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/03_05_lower_bounds.md) |

## Dependencies

- Reuse Optlib gradient-descent interfaces wherever the book statement is only a wrapper around a stronger library theorem.

## Chapter Blockers

- Several later theorems depend on stronger reusable templates for accelerated arguments.

## Nearby Results

- Previous: [Theorem 3.12](./theorem-3-12.md)
- Next: [Theorem 3.14](./theorem-3-14.md)
