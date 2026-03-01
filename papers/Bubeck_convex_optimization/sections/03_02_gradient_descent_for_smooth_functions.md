---
book: Bubeck_convex_optimization
chapter: 3
chapter_title: Dimension-free convex optimization
section: 2
section_title: Gradient descent for smooth functions
subsection: null
subsection_title: null
section_id: '3.2'
tex_label: sec:gdsmooth
theorems:
- id: Theorem 3.2
  label: ''
  tex_label: th:gdsmooth
- id: Lemma 3.3
  label: ''
  tex_label: lem:sand
- id: Lemma 3.4
  label: ''
  tex_label: lem:2
lean_files:
- id: Theorem 3.2
  path: proofs/Bubeck_convex_optimization/Theorem32.lean
  status: pending
- id: Lemma 3.3
  path: proofs/Bubeck_convex_optimization/Lemma33.lean
  status: pending
- id: Lemma 3.4
  path: proofs/Bubeck_convex_optimization/Lemma34.lean
  status: pending
---

\section{Gradient descent for smooth functions} \label{sec:gdsmooth}
We say that a continuously differentiable function $f$ is $\beta$-smooth if the gradient $\nabla f$ is $\beta$-Lipschitz, that is 
$$\|\nabla f(x) - \nabla f(y) \| \leq \beta \|x-y\| .$$
Note that if $f$ is twice differentiable then this is equivalent to the eigenvalues of the Hessians being smaller than $\beta$.
In this section we explore potential improvements in the rate of convergence under such a smoothness assumption.
In order to avoid technicalities we consider first the unconstrained situation, where $f$ is a convex and $\beta$-smooth function on $\R^n$. 
The next theorem shows that {\em gradient descent}, which iterates $x_{t+1} = x_t - \eta \nabla f(x_t)$, attains a much faster rate in this situation than in the non-smooth case of the previous section.

**Theorem**
 \label{th:gdsmooth}

Let $f$ be convex and $\beta$-smooth on $\R^n$. 
Then gradient descent with $\eta = \frac{1}{\beta}$ satisfies
$$f(x_t) - f(x^*) \leq \frac{2 \beta \|x_1 - x^*\|^2}{t-1} .$$

Before embarking on the proof we state a few properties of smooth convex functions.

**Lemma**
 \label{lem:sand}
Let $f$ be a $\beta$-smooth function on $\R^n$. Then for any $x, y \in \R^n$, one has
$$|f(x) - f(y) - \nabla f(y)^{\top} (x - y)| \leq \frac{\beta}{2} \|x - y\|^2 .$$

*Proof.*

We represent $f(x) - f(y)$ as an integral, apply Cauchy-Schwarz and then $\beta$-smoothness:
\begin{align*}
& |f(x) - f(y) - \nabla f(y)^{\top} (x - y)| \\
& = \left|\int_0^1 \nabla f(y + t(x-y))^{\top} (x-y) dt -  \nabla f(y)^{\top} (x - y) \right| \\
& \leq \int_0^1 \|\nabla f(y + t(x-y)) -  \nabla f(y)\| \cdot \|x - y\| dt \\
& \leq \int_0^1 \beta t \|x-y\|^2 dt \\
& = \frac{\beta}{2} \|x-y\|^2 .
\end{align*}

In particular this lemma shows that if $f$ is convex and $\beta$-smooth, then for any $x, y \in \R^n$, one has
 \label{eq:defaltsmooth}
0 \leq f(x) - f(y) - \nabla f(y)^{\top} (x - y) \leq \frac{\beta}{2} \|x - y\|^2 .

This gives in particular the following important inequality to evaluate the improvement in one step of gradient descent:
 \label{eq:onestepofgd}
f\left(x - \frac{1}{\beta} \nabla f(x)\right) - f(x) \leq - \frac{1}{2 \beta} \|\nabla f(x)\|^2 .

The next lemma, which improves the basic inequality for subgradients under the smoothness assumption, shows that in fact $f$ is convex and $\beta$-smooth if and only if \eqref{eq:defaltsmooth} holds true. In the literature \eqref{eq:defaltsmooth} is often used as a definition of smooth convex functions.

**Lemma**
 \label{lem:2}
Let $f$ be such that \eqref{eq:defaltsmooth} holds true. Then for any $x, y \in \R^n$, one has
$$f(x) - f(y) \leq \nabla f(x)^{\top} (x - y) - \frac{1}{2 \beta} \|\nabla f(x) - \nabla f(y)\|^2 .$$

*Proof.*

Let $z = y - \frac{1}{\beta} (\nabla f(y) - \nabla f(x))$. Then one has
\begin{align*}
& f(x) - f(y) \\
& = f(x) - f(z) + f(z) - f(y) \\
& \leq \nabla f(x)^{\top} (x-z) + \nabla f(y)^{\top} (z-y) + \frac{\beta}{2} \|z - y\|^2 \\
& = \nabla f(x)^{\top}(x-y) + (\nabla f(x) - \nabla f(y))^{\top} (y-z) + \frac{1}{2 \beta} \|\nabla f(x) - \nabla f(y)\|^2 \\
& = \nabla f(x)^{\top} (x - y) - \frac{1}{2 \beta} \|\nabla f(x) - \nabla f(y)\|^2 .
\end{align*}

We can now prove Theorem \ref{th:gdsmooth}

*Proof.*

Using \eqref{eq:onestepofgd} and the definition of the method one has
$$f(x_{s+1}) - f(x_s) \leq - \frac{1}{2 \beta} \|\nabla f(x_s)\|^2.$$
In particular, denoting $\delta_s = f(x_s) - f(x^*)$, this shows:
$$\delta_{s+1} \leq \delta_s  - \frac{1}{2 \beta} \|\nabla f(x_s)\|^2.$$
One also has by convexity
$$\delta_s \leq \nabla f(x_s)^{\top} (x_s - x^*) \leq \|x_s - x^*\| \cdot \|\nabla f(x_s)\| .$$
We will prove that $\|x_s - x^*\|$ is decreasing with $s$, which with the two above displays will imply
$$\delta_{s+1} \leq \delta_s  - \frac{1}{2 \beta \|x_1 - x^*\|^2} \delta_s^2.$$
Let us see how to use this last inequality to conclude the proof. Let $\omega = \frac{1}{2 \beta \|x_1 - x^*\|^2}$, then that $\delta_1 \leq \frac{1}{4 \omega}$. This improves the rate of Theorem \ref{th:gdsmooth} from $\frac{2 \beta \|x_1 - x^*\|^2}{t-1}$ to $\frac{2 \beta \|x_1 - x^*\|^2}{t+3}$.}
$$\omega \delta_s^2 + \delta_{s+1} \leq \delta_s \Leftrightarrow \omega \frac{\delta_s}{\delta_{s+1}} + \frac{1}{\delta_{s}} \leq \frac{1}{\delta_{s+1}} \Rightarrow \frac{1}{\delta_{s+1}} - \frac{1}{\delta_{s}} \geq \omega \Rightarrow \frac{1}{\delta_t} \geq \omega (t-1) .$$

Thus it only remains to show that $\|x_s - x^*\|$ is decreasing with $s$. Using Lemma \ref{lem:2} one immediately gets
 \label{eq:coercive1}
(\nabla f(x) - \nabla f(y))^{\top} (x - y) \geq \frac{1}{\beta} \|\nabla f(x) - \nabla f(y)\|^2 .

We use this as follows (together with $\nabla f(x^*) = 0$)
\begin{eqnarray*}
\|x_{s+1} - x^*\|^2& = & \|x_{s} - \frac{1}{\beta} \nabla f(x_s) - x^*\|^2 \\
& = & \|x_{s} - x^*\|^2 - \frac{2}{\beta} \nabla f(x_s)^{\top} (x_s - x^*) + \frac{1}{\beta^2} \|\nabla f(x_s)\|^2 \\
& \leq & \|x_{s} - x^*\|^2 - \frac{1}{\beta^2} \|\nabla f(x_s)\|^2 \\
& \leq & \|x_{s} - x^*\|^2 ,
\end{eqnarray*}
which concludes the proof.