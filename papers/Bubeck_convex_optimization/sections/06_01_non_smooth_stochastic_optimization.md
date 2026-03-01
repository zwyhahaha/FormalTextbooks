---
book: Bubeck_convex_optimization
chapter: 6
chapter_title: Convex optimization and randomness
section: 1
section_title: Non-smooth stochastic optimization
subsection: null
subsection_title: null
section_id: '6.1'
tex_label: sec:smd
theorems:
- id: Theorem 6.1
  label: ''
  tex_label: th:SMD
- id: Theorem 6.2
  label: ''
  tex_label: th:sgdstrong
lean_files:
- id: Theorem 6.1
  path: proofs/Bubeck_convex_optimization/Theorem61.lean
  status: pending
- id: Theorem 6.2
  path: proofs/Bubeck_convex_optimization/Theorem62.lean
  status: pending
---

\section{Non-smooth stochastic optimization} \label{sec:smd}
We initiate our study with stochastic mirror descent (S-MD) which is defined as follows: $x_1 \in \argmin_{\cX \cap \cD} \Phi(x)$, and
$$x_{t+1} = \argmin_{x \in \mathcal{X} \cap \mathcal{D}} \ \eta \tilde{g}(x_t)^{\top} x + D_{\Phi}(x,x_t) .$$
In this case equation \eqref{eq:vfMD} rewrites
$$\sum_{s=1}^t \tg(x_s)^{\top} (x_s - x) \leq \frac{R^2}{\eta} + \frac{\eta}{2 \rho} \sum_{s=1}^t \|\tg(x_s)\|_*^2 .$$
This immediately yields a rate of convergence thanks to the following simple observation based on the tower rule:
\begin{eqnarray*}
\E f\bigg(\frac{1}{t} \sum_{s=1}^t x_s \bigg) - f(x) & \leq & \frac{1}{t} \E \sum_{s=1}^t (f(x_s) - f(x)) \\
& \leq & \frac{1}{t} \E \sum_{s=1}^t \E(\tg(x_s) | x_s)^{\top} (x_s - x) \\
& = & \frac{1}{t} \E \sum_{s=1}^t \tg(x_s)^{\top} (x_s - x) .
\end{eqnarray*}
We just proved the following theorem.

**Theorem**
 \label{th:SMD}
Let $\Phi$ be a mirror map $1$-strongly convex on $\mathcal{X} \cap \mathcal{D}$ with respect to $\|\cdot\|$, and
let $R^2 = \sup_{x \in \mathcal{X} \cap \mathcal{D}} \Phi(x) - \Phi(x_1)$. Let $f$ be convex. Furthermore assume that the stochastic oracle is such that $\E \|\tg(x)\|_*^2 \leq B^2$. Then S-MD with $\eta = \frac{R}{B} \sqrt{\frac{2}{t}}$ satisfies
$$\E f\bigg(\frac{1}{t} \sum_{s=1}^t x_s \bigg) - \min_{x \in \mathcal{X}} f(x) \leq R B \sqrt{\frac{2}{t}} .$$

Similarly, in the Euclidean and strongly convex case, one can directly generalize Theorem \ref{th:LJSB12}. Precisely we consider stochastic gradient descent (SGD), that is S-MD with $\Phi(x) = \frac12 \|x\|_2^2$, with time-varying step size $(\eta_t)_{t \geq 1}$, that is
$$x_{t+1} = \Pi_{\cX}(x_t - \eta_t \tg(x_t)) .$$

**Theorem**
 \label{th:sgdstrong}
Let $f$ be $\alpha$-strongly convex, and assume that the stochastic oracle is such that $\E \|\tg(x)\|_*^2 \leq B^2$. Then SGD with $\eta_s = \frac{2}{\alpha (s+1)}$ satisfies
$$f \left(\sum_{s=1}^t \frac{2 s}{t(t+1)} x_s \right) - f(x^*) \leq \frac{2 B^2}{\alpha (t+1)} .$$