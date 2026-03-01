---
book: Bubeck_convex_optimization
chapter: 6
chapter_title: Convex optimization and randomness
section: 7
section_title: Random walk based methods
subsection: null
subsection_title: null
section_id: '6.7'
tex_label: sec:rwmethod
theorems:
- id: Lemma 6.14
  label: ''
  tex_label: lem:BerVem04
lean_files:
- id: Lemma 6.14
  path: proofs/Bubeck_convex_optimization/Lemma614.lean
  status: pending
---

\section{Random walk based methods} \label{sec:rwmethod}
Randomization naturally suggests itself in the center of gravity method (see Section \ref{sec:gravity}), as a way to circumvent the exact calculation of the center of gravity. This idea was proposed and developed in \cite{BerVem04}. We give below a condensed version of the main ideas of this paper.

Assuming that one can draw independent points $X_1, \hdots, X_N$ uniformly at random from the current set $\cS_t$, one could replace $c_t$ by $\hat{c}_t = \frac{1}{N} \sum_{i=1}^N X_i$. \cite{BerVem04} proved the following generalization of Lemma \ref{lem:Gru60} for the situation where one cuts a convex set through a point close the center of gravity. Recall that a convex set $\cK$ is in isotropic position if $\E X = 0$ and $\E X X^{\top} = \mI_n$, where $X$ is a random variable drawn uniformly at random from $\cK$. Note in particular that this implies $\E \|X\|_2^2 = n$. We also say that $\cK$ is in near-isotropic position if $\frac{1}{2} \mI_n \preceq \E X X^{\top} \preceq \frac3{2} \mI_n$.

**Lemma**
 \label{lem:BerVem04}
Let $\cK$ be a convex set in isotropic position. Then for any $w \in \R^n, w \neq 0$, $z \in \R^n$, one has
$$\mathrm{Vol} \left( \cK \cap \{x \in \R^n : (x-z)^{\top} w \geq 0\} \right) \geq \left(\frac{1}{e} - \|z\|_2\right) \mathrm{Vol} (\cK) .$$

Thus if one can ensure that $\cS_t$ is in (near) isotropic position, and $\|c_t - \hat{c}_t\|_2$ is small (say smaller than $0.1$), then the randomized center of gravity method (which replaces $c_t$ by $\hat{c}_t$) will converge at the same speed than the original center of gravity method. 

Assuming that $\cS_t$ is in isotropic position one immediately obtains $\E \|c_t - \hat{c}_t\|_2^2 = \frac{n}{N}$, and thus by Chebyshev's inequality one has $\P(\|c_t - \hat{c}_t\|_2 > 0.1) \leq 100 \frac{n}{N}$. In other words with $N = O(n)$ one can ensure that the randomized center of gravity method makes progress on a constant fraction of the iterations (to ensure progress at every step one would need a larger value of $N$ because of an union bound, but this is unnecessary).

Let us now consider the issue of putting $\cS_t$ in near-isotropic position. Let $\hat{\Sigma}_t = \frac1{N} \sum_{i=1}^N (X_i-\hat{c}_t) (X_i-\hat{c}_t)^{\top}$. \cite{Rud99} showed that as long as $N= \tilde{\Omega}(n)$, one has with high probability (say at least probability $1-1/n^2$) that the set $\hat{\Sigma}_t^{-1/2} (\cS_t - \hat{c}_t)$ is in near-isotropic position.

Thus it only remains to explain how to sample from a near-isotropic convex set $\cK$. This is where random walk ideas come into the picture. The hit-and-run walk.} is described as follows: at a point $x \in \cK$, let $\cL$ be a line that goes through $x$ in a direction taken uniformly at random, then move to a point chosen uniformly at random in $\cL \cap \cK$. \cite{Lov98} showed that if the starting point of the hit-and-run walk is chosen from a distribution ``close enough" to the uniform distribution on $\cK$, then after $O(n^3)$ steps the distribution of the last point is $\epsilon$ away (in total variation) from the uniform distribution on $\cK$. In the randomized center of gravity method one can obtain a good initial distribution for $\cS_t$ by using the distribution that was obtained for $\cS_{t-1}$. In order to initialize the entire process correctly we start here with $\cS_1 = [-L, L]^n \supset \cX$ (in Section \ref{sec:gravity} we used $\cS_1 = \cX$), and thus we also have to use a {\em separation oracle} at iterations where $\hat{c}_t \not\in \cX$, just like we did for the ellipsoid method (see Section \ref{sec:ellipsoid}).

Wrapping up the above discussion, we showed (informally) that to attain an $\epsilon$-optimal point with the randomized center of gravity method one needs: $\tilde{O}(n)$ iterations, each iterations requires $\tilde{O}(n)$ random samples from $\cS_t$ (in order to put it in isotropic position) as well as a call to either the separation oracle or the first order oracle, and each sample costs $\tilde{O}(n^3)$ steps of the random walk. Thus overall one needs $\tilde{O}(n)$ calls to the separation oracle and the first order oracle, as well as $\tilde{O}(n^5)$ steps of the random walk.