---
book: Bubeck_convex_optimization
chapter: 2
chapter_title: Convex optimization in finite dimension
section: 1
section_title: The center of gravity method
subsection: null
subsection_title: null
section_id: '2.1'
tex_label: sec:gravity
theorems:
- id: Theorem 2.1
  label: ''
  tex_label: th:centerofgravity
- id: Lemma 2.2
  label: ''
  tex_label: lem:Gru60
lean_files:
- id: Theorem 2.1
  path: proofs/Bubeck_convex_optimization/Theorem21.lean
  status: partial
- id: Lemma 2.2
  path: proofs/Bubeck_convex_optimization/Lemma22.lean
  status: partial

---

\section{The center of gravity method} \label{sec:gravity}
We consider the following simple iterative algorithm: let $\cS_1= \cX$, and for $t \geq 1$ do the following:

\item Compute

c_t = \frac{1}{\mathrm{vol}(\cS_t)} \int_{x \in \cS_t} x dx .

\item Query the first order oracle at $c_t$ and obtain $w_t \in \partial f (c_t)$. Let
$$\cS_{t+1} = \cS_t \cap \{x \in \R^n : (x-c_t)^{\top} w_t \leq 0\} .$$

If stopped after $t$ queries to the first order oracle then we use $t$ queries to a zeroth order oracle to output
$$x_t\in \argmin_{1 \leq r \leq t} f(c_r) .$$
This procedure is known as the {\em center of gravity method}, it was discovered independently on both sides of the Wall by \cite{Lev65} and \cite{New65}.

**Theorem**

\label{th:centerofgravity}
The center of gravity method satisfies
$$f(x_t) - \min_{x \in \mathcal{X}} f(x) \leq 2 B \left(1 - \frac1{e} \right)^{t/n} .$$

Before proving this result a few comments are in order. 

To attain an $\epsilon$-optimal point the center of gravity method requires $O( n \log (2 B / \epsilon))$ queries to both the first and zeroth order oracles. It can be shown that this is the best one can hope for, in the sense that for $\epsilon$ small enough one needs $\Omega(n \log(1/ \epsilon))$ calls to the oracle in order to find an $\epsilon$-optimal point, see \cite{NY83} for a formal proof.

The rate of convergence given by Theorem \ref{th:centerofgravity} is exponentially fast. In the optimization literature this is called a {\em linear rate} as the (estimated) error at iteration $t+1$ is linearly related to the error at iteration $t$.

The last and most important comment concerns the computational complexity of the method. It turns out that finding the center of gravity $c_t$ is a very difficult problem by itself, and we do not have computationally efficient procedure to carry out this computation in general. In Section \ref{sec:rwmethod} we will discuss a relatively recent (compared to the 50 years old center of gravity method!) randomized algorithm to approximately compute the center of gravity. This will in turn give a randomized center of gravity method which we will describe in detail.

We now turn to the proof of Theorem \ref{th:centerofgravity}. We will use the following elementary result from convex geometry:

**Lemma** (\cite{Gru60})
 \label{lem:Gru60}
Let $\cK$ be a centered convex set, i.e., $\int_{x \in \cK} x dx = 0$, then for any $w \in \R^n, w \neq 0$, one has
$$\mathrm{Vol} \left( \cK \cap \{x \in \R^n : x^{\top} w \geq 0\} \right) \geq \frac{1}{e} \mathrm{Vol} (\cK) .$$

We now prove Theorem \ref{th:centerofgravity}.

*Proof.*

Let $x^*$ be such that $f(x^*) = \min_{x \in \mathcal{X}} f(x)$. Since $w_t \in \partial f(c_t)$ one has
$$f(c_t) - f(x) \leq w_t^{\top} (c_t - x) .$$
and thus
 \label{eq:centerofgravity1}
\cS_{t} \setminus \cS_{t+1} \subset \{x \in \cX : (x-c_t)^{\top} w_t > 0\} \subset \{x \in \cX : f(x) > f(c_t)\} ,

which clearly implies that one can never remove the optimal point from our sets in consideration, that is $x^* \in \cS_t$ for any $t$.
Without loss of generality we can assume that we always have $w_t \neq 0$, for otherwise one would have $f(c_t) = f(x^*)$ which immediately conludes the proof. Now using that $w_t \neq 0$ for any $t$ and Lemma \ref{lem:Gru60} one clearly obtains
$$\mathrm{vol}(\cS_{t+1}) \leq \left(1 - \frac1{e} \right)^t \mathrm{vol}(\cX) .$$
For $\epsilon \in [0,1]$, let $\mathcal{X}_{\epsilon} = \{(1-\epsilon) x^* + \epsilon x, x \in \mathcal{X}\}$. Note that $\mathrm{vol}(\mathcal{X}_{\epsilon}) = \epsilon^n \mathrm{vol}(\mathcal{X})$. These volume computations show that for $\epsilon > \left(1 - \frac1{e} \right)^{t/n}$ one has $\mathrm{vol}(\mathcal{X}_{\epsilon}) > \mathrm{vol}(\cS_{t+1})$. In particular this implies that for $\epsilon > \left(1 - \frac1{e} \right)^{t/n}$, there must exist a time $r \in \{1,\hdots, t\}$, and $x_{\epsilon} \in \mathcal{X}_{\epsilon}$, such that $x_{\epsilon} \in \cS_{r}$ and $x_{\epsilon} \not\in \cS_{r+1}$. In particular by \eqref{eq:centerofgravity1} one has $f(c_r) < f(x_{\epsilon})$. On the other hand by convexity of $f$ one clearly has $f(x_{\epsilon}) \leq f(x^*) + 2 \epsilon B$. This concludes the proof.