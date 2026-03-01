---
book: Bubeck_convex_optimization
chapter: 4
chapter_title: Almost dimension-free convex optimization in non-Euclidean spaces
section: 4
section_title: Lazy mirror descent, aka Nesterov's dual averaging
subsection: null
subsection_title: null
section_id: '4.4'
tex_label: ''
theorems:
- id: Theorem 4.3
  label: ''
  tex_label: ''
lean_files:
- id: Theorem 4.3
  path: proofs/Bubeck_convex_optimization/Theorem43.lean
  status: pending
---

\section{Lazy mirror descent, aka Nesterov's dual averaging}
In this section we consider a slightly more efficient version of mirror descent for which we can prove that Theorem \ref{th:MD} still holds true. This alternative algorithm can be advantageous in some situations (such as distributed settings), but the basic mirror descent scheme remains important for extensions considered later in this text (saddle points, stochastic oracles, ...). 

In lazy mirror descent, also commonly known as Nesterov's dual averaging or simply dual averaging, one replaces \eqref{eq:MD1} by
$$\nabla \Phi(y_{t+1}) = \nabla \Phi(y_{t}) - \eta g_t ,$$
and also $y_1$ is such that $\nabla \Phi(y_1) = 0$. In other words instead of going back and forth between the primal and the dual, dual averaging simply averages the gradients in the dual, and if asked for a point in the primal it simply maps the current dual point to the primal using the same methodology as mirror descent. In particular using \eqref{eq:MD3} one immediately sees that dual averaging is defined by:
 \label{eq:DA0}
x_t = \argmin_{x \in \mathcal{X} \cap \mathcal{D}} \ \eta \sum_{s=1}^{t-1} g_s^{\top} x + \Phi(x) .

**Theorem**

Let $\Phi$ be a mirror map $\rho$-strongly convex on $\mathcal{X} \cap \mathcal{D}$ w.r.t. $\|\cdot\|$.
Let $R^2 = \sup_{x \in \mathcal{X} \cap \mathcal{D}} \Phi(x) - \Phi(x_1)$, and $f$ be convex and $L$-Lipschitz w.r.t. $\|\cdot\|$. Then dual averaging with $\eta = \frac{R}{L} \sqrt{\frac{\rho}{2 t}}$ satisfies
$$f\bigg(\frac{1}{t} \sum_{s=1}^t x_s \bigg) - f(x^*) \leq 2 RL \sqrt{\frac{2}{\rho t}} .$$

*Proof.*

We define $\psi_t(x) = \eta \sum_{s=1}^{t} g_s^{\top} x + \Phi(x)$, so that $x_t \in  \argmin_{x \in \mathcal{X} \cap \mathcal{D}} \psi_{t-1}(x)$. Since $\Phi$ is $\rho$-strongly convex one clearly has that $\psi_t$ is $\rho$-strongly convex, and thus
\begin{eqnarray*}
\psi_t(x_{t+1}) - \psi_t(x_t) & \leq & \nabla \psi_t(x_{t+1})^{\top}(x_{t+1} - x_{t}) - \frac{\rho}{2} \|x_{t+1} - x_t\|^2 \\
& \leq & - \frac{\rho}{2} \|x_{t+1} - x_t\|^2 ,
\end{eqnarray*}
where the second inequality comes from the first order optimality condition for $x_{t+1}$ (see Proposition \ref{prop:firstorder}). Next observe that
\begin{eqnarray*}
\psi_t(x_{t+1}) - \psi_t(x_t) & = & \psi_{t-1}(x_{t+1}) - \psi_{t-1}(x_t) + \eta g_t^{\top} (x_{t+1} - x_t) \\
& \geq & \eta g_t^{\top} (x_{t+1} - x_t) .
\end{eqnarray*}
Putting together the two above displays and using Cauchy-Schwarz (with the assumption $\|g_t\|_* \leq L$) one obtains
$$\frac{\rho}{2} \|x_{t+1} - x_t\|^2 \leq \eta g_t^{\top} (x_t - x_{t+1}) \leq \eta L \|x_t - x_{t+1} \|.$$
In particular this shows that $\|x_{t+1} - x_t\| \leq \frac{2 \eta L}{\rho}$ and thus with the above display
 \label{eq:DA1}
g_t^{\top} (x_t - x_{t+1}) \leq \frac{2 \eta L^2}{\rho} .

Now we claim that for any $x \in \cX \cap \cD$,
 \label{eq:DA2}
\sum_{s=1}^t g_s^{\top} (x_s - x) \leq \sum_{s=1}^t g_s^{\top} (x_s - x_{s+1}) + \frac{\Phi(x) - \Phi(x_1)}{\eta} ,

which would clearly conclude the proof thanks to \eqref{eq:DA1} and straightforward computations. Equation \eqref{eq:DA2} is equivalent to 
$$\sum_{s=1}^t g_s^{\top} x_{s+1} + \frac{\Phi(x_1)}{\eta} \leq \sum_{s=1}^t g_s^{\top} x + \frac{\Phi(x)}{\eta} ,$$
and we now prove the latter equation by induction. At $t=0$ it is true since $x_1 \in \argmin_{x \in \cX \cap \cD} \Phi(x)$. The following inequalities prove the inductive step, where we use the induction hypothesis at $x=x_{t+1}$ for the first inequality, and the definition of $x_{t+1}$ for the second inequality:
$$\sum_{s=1}^{t} g_s^{\top} x_{s+1} + \frac{\Phi(x_1)}{\eta} \leq g_{t}^{\top}x_{t+1} + \sum_{s=1}^{t-1} g_s^{\top} x_{t+1} + \frac{\Phi(x_{t+1})}{\eta} \leq \sum_{s=1}^{t} g_s^{\top} x + \frac{\Phi(x)}{\eta} .$$