---
book: Bubeck_convex_optimization
chapter: 6
chapter_title: Convex optimization and randomness
section: 4
section_title: Random coordinate descent
subsection: null
subsection_title: null
section_id: '6.4'
tex_label: ''
theorems:
- id: Theorem 6.6
  label: ''
  tex_label: ''
lean_files:
- id: Theorem 6.6
  path: proofs/Bubeck_convex_optimization/Theorem66.lean
  status: pending
---

\section{Random coordinate descent}
We assume throughout this section that $f$ is a convex and differentiable function on $\R^n$, with a unique minimizer $x^*$. We investigate one of the simplest possible scheme to optimize $f$, the random coordinate descent (RCD) method. In the following we denote $\nabla_i f(x) = \frac{\partial f}{\partial x_i} (x)$. RCD is defined as follows, with an arbitrary initial point $x_1 \in \R^n$,
$$x_{s+1} = x_s - \eta \nabla_{i_s} f(x) e_{i_s} ,$$
where $i_s$ is drawn uniformly at random from $[n]$ (and independently of everything else). 

One can view RCD as SGD with the specific oracle $\tg(x) = n \nabla_{I} f(x) e_I$ where $I$ is drawn uniformly at random from $[n]$. Clearly $\E \tg(x) = \nabla f(x)$, and furthermore
$$\E \|\tg(x)\|_2^2 = \frac{1}{n}\sum_{i=1}^n \|n \nabla_{i} f(x) e_i\|_2^2 = n \|\nabla f(x)\|_2^2 .$$
Thus using Theorem \ref{th:SMD} (with $\Phi(x) = \frac12 \|x\|_2^2$, that is S-MD being SGD) one immediately obtains the following result. 

**Theorem**

Let $f$ be convex and $L$-Lipschitz on $\R^n$, then RCD with $\eta = \frac{R}{L} \sqrt{\frac{2}{n t}}$ satisfies
$$\E f\bigg(\frac{1}{t} \sum_{s=1}^t x_s \bigg) - \min_{x \in \mathcal{X}} f(x) \leq R L \sqrt{\frac{2 n}{t}} .$$

Somewhat unsurprisingly RCD requires $n$ times more iterations than gradient descent to obtain the same accuracy. In the next section, we will see that this statement can be greatly improved by taking into account directional smoothness.