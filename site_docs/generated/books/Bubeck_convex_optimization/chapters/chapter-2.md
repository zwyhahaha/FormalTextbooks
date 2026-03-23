# Chapter 2 — Convex optimization in finite dimension

## Section 2.1 — The center of gravity method

### [Theorem 2.1](../results/theorem-2-1.md)

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

### [Lemma 2.2](../results/lemma-2-2.md)

**Lemma** (\cite{Gru60})

Let $\cK$ be a centered convex set, i.e., $\int_{x \in \cK} x dx = 0$, then for any $w \in \R^n, w \neq 0$, one has

\[
\mathrm{Vol} \left( \cK \cap \{x \in \R^n : x^{\top} w \geq 0\} \right) \geq \frac{1}{e} \mathrm{Vol} (\cK) .
\]

We now prove Theorem \ref{th:centerofgravity}.

## Section 2.2 — The ellipsoid method

### [Lemma 2.3](../results/lemma-2-3.md)

**Lemma**

Let $\mathcal{E}_0 = \{x \in \R^n : (x - c_0)^{\top} H_0^{-1} (x-c_0) \leq 1 \}$. For any $w \in \R^n$, $w \neq 0$, there exists an ellipsoid $\mathcal{E}$ such that

\mathcal{E} \supset \{x \in \mathcal{E}_0 : w^{\top} (x-c_0) \leq 0\} , \label{eq:ellipsoidlemma1}

and 

\mathrm{vol}(\mathcal{E}) \leq \exp \left(- \frac{1}{2 n} \right) \mathrm{vol}(\mathcal{E}_0) . \label{eq:ellipsoidlemma2}

Furthermore for $n \geq 2$ one can take $\cE = \{x \in \R^n : (x - c)^{\top} H^{-1} (x-c) \leq 1 \}$ where

& c = c_0 - \frac{1}{n+1} \frac{H_0 w}{\sqrt{w^{\top} H_0 w}} , \label{eq:ellipsoidlemma3}\\
& H = \frac{n^2}{n^2-1} \left(H_0 - \frac{2}{n+1} \frac{H_0 w w^{\top} H_0}{w^{\top} H_0 w} \right) . \label{eq:ellipsoidlemma4}

### [Theorem 2.4](../results/theorem-2-4.md)

**Theorem**

For $t \geq 2n^2 \log(R/r)$ the ellipsoid method satisfies $\{c_1, \hdots, c_t\} \cap \cX \neq \emptyset$ and

\[
f(x_t) - \min_{x \in \mathcal{X}} f(x) \leq \frac{2 B R}{r} \exp\left( - \frac{t}{2 n^2}\right) .
\]

We observe that the oracle complexity of the ellipsoid method is much worse than the one of the center gravity method, indeed the former needs $O(n^2 \log(1/\epsilon))$ calls to the oracles while the latter requires only $O(n \log(1/\epsilon))$ calls. However from a computational point of view the situation is much better: in many cases one can derive an efficient separation oracle, while the center of gravity method is basically always intractable. This is for instance the case in the context of LPs and SDPs: with the notation of Section \ref{sec:structured} the computational complexity of the separation oracle for LPs is $O(m n)$ while for SDPs it is $O(\max(m,n) n^2)$ (we use the fact that the spectral decomposition of a matrix can be done in $O(n^3)$ operations). This gives an overall complexity of $O(\max(m,n) n^3 \log(1/\epsilon))$ for LPs and $O(\max(m,n^2) n^6 \log(1/\epsilon))$ for SDPs. We note however that the ellipsoid method is almost never used in practice, essentially because the method is too rigid to exploit the potential easiness of real problems (e.g., the volume decrease given by \eqref{eq:ellipsoidlemma2} is essentially always tight).

## Section 2.3.4 — Constraints and the volumetric barrier

### [Lemma 2.5](../results/lemma-2-5.md)

**Lemma**

One has for any $i \in [m+1]$,

\[
\frac{\tilde{\sigma}_{m+1}(x)}{1 - \tilde{\sigma}_{m+1}(x)} \geq \sigma_i(x) \geq \tilde{\sigma}_i(x) \geq (1-\sigma_{m+1}(x)) \sigma_i(x) .
\]

### [Theorem 2.6](../results/theorem-2-6.md)

**Theorem**

Let $\lambda(x) = \|\nabla v(x) \|_{Q(x)^{-1}}$ be an approximate Newton decrement, $\epsilon = \min_{i \in [m]} \sigma_i(x)$, and assume that $\lambda(x)^2 \leq \frac{2 \sqrt{\epsilon} - \epsilon}{36}$. Then

\[
v(x) - v(x^*) \leq 2 \lambda(x)^2 .
\]

We also denote $\tilde{\lambda}$ for the approximate Newton decrement of $\tilde{v}$. The goal for the rest of the section is to prove the following theorem which gives the precise understanding of the volumetric barrier we were looking for.

### [Theorem 2.7](../results/theorem-2-7.md)

**Theorem**

Let $\epsilon := \min_{i \in [m]} \sigma_i(x^*)$, $\delta := \sigma_{m+1}(x^*) / \sqrt{\epsilon}$ and assume that $\frac{\left(\delta \sqrt{\epsilon} + \sqrt{\delta^{3} \sqrt{\epsilon}}\right)^2}{1- \delta \sqrt{\epsilon}} < \frac{2 \sqrt{\epsilon} - \epsilon}{36}$. Then one has

\tilde{v}(\tilde{x}^*) - v(x^*) \geq \frac{1}{2} \log(1+\delta \sqrt{\epsilon}) - 2  \frac{\left(\delta \sqrt{\epsilon} + \sqrt{\delta^{3} \sqrt{\epsilon}}\right)^2}{1- \delta \sqrt{\epsilon}}  .

On the other hand assuming that $\tilde{\sigma}_{m+1}(\tilde{x}^*) = \min_{i \in [m+1]} \tilde{\sigma}_{i}(\tilde{x}^*) =: \epsilon$ and that $\epsilon \leq 1/4$, one has 

\tilde{v}(\tilde{x}^*) - v(x^*) \leq - \frac{1}{2} \log(1 - \epsilon) + \frac{8 \epsilon^2}{(1-\epsilon)^2}.

Before going into the proof let us see briefly how Theorem \ref{th:V1} give the two inequalities stated at the beginning of Section \ref{sec:analysis}. To prove \eqref{eq:analysis2} we use \eqref{eq:thV11} with $\delta=1/5$ and $\epsilon \leq 0.006$, and we observe that in this case the right hand side of \eqref{eq:thV11} is lower bounded by $\frac{1}{20} \sqrt{\epsilon}$. On the other hand to prove \eqref{eq:analysis1} we use \eqref{eq:thV12}, and we observe that for $\epsilon \leq 0.006$ the right hand side of \eqref{eq:thV12} is upper bounded by $\epsilon$.

### [Lemma 2.8](../results/lemma-2-8.md)

**Lemma**

One has

\sqrt{1- \sigma_{m+1}(x)} \ \tilde{\lambda} (x) \leq \|\nabla {v}(x)\|_{Q(x)^{-1}} + \sigma_{m+1}(x) + \sqrt{\frac{\sigma_{m+1}^3(x)}{\min_{i \in [m]} \sigma_i(x)}} .

Furthermore if $\tilde{\sigma}_{m+1}(x) = \min_{i \in [m+1]} \tilde{\sigma}_{i}(x)$ then one also has

\lambda(x) \leq  \|\nabla \tilde{v}(x)\|_{Q(x)^{-1}} + \frac{2 \ \tilde{\sigma}_{m+1}(x)}{1 - \tilde{\sigma}_{m+1}(x)} .
