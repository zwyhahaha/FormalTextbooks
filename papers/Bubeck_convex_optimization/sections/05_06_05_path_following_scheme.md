---
book: Bubeck_convex_optimization
chapter: 5
chapter_title: Beyond the black-box model
section: 6
section_title: Interior point methods
subsection: 5
subsection_title: Path-following scheme
section_id: 5.6.5
tex_label: ''
theorems:
- id: Theorem 5.9
  label: ''
  tex_label: ''
lean_files:
- id: Theorem 5.9
  path: proofs/Bubeck_convex_optimization/Theorem59.lean
  status: pending
---

\subsection{Path-following scheme}
We can now formally describe and analyze the most basic IPM called the {\em path-following scheme}. Let $F$ be $\nu$-self-concordant barrier for $\cX$. Assume that one can find $x_0$ such that $\lambda_{F_{t_0}}(x_0) \leq 1/4$ for some small value $t_0 >0$ (we describe a method to find $x_0$ at the end of this subsection).

Then for $k \geq 0$, let
\begin{eqnarray*}
& & t_{k+1} = \left(1 + \frac1{13\sqrt{\nu}}\right) t_k ,\\
& & x_{k+1} = x_k - [\nabla^2 F(x_k)]^{-1} (t_{k+1} c + \nabla F(x_k) ) .
\end{eqnarray*}
The next theorem shows that after $O\left( \sqrt{\nu} \log \frac{\nu}{t_0 \epsilon} \right)$ iterations of the path-following scheme one obtains an $\epsilon$-optimal point.

**Theorem**

The path-following scheme described above satisfies
$$c^{\top} x_k - \min_{x \in \mathcal{X}} c^{\top} x \leq \frac{2 \nu}{t_0} \exp\left( - \frac{k}{1+13\sqrt{\nu}} \right) .$$

*Proof.*

We show that the iterates $(x_k)_{k \geq 0}$ remain close to the central path $(x^*(t_k))_{k \geq 0}$. Precisely one can easily prove by induction that 
$$\lambda_{F_{t_k}}(x_k) \leq 1/4 .$$
Indeed using Theorem \ref{th:NMsc} and equation \eqref{eq:trucipm12} one immediately obtains
\begin{eqnarray*}
\lambda_{F_{t_{k+1}}}(x_{k+1}) & \leq & 2 \lambda_{F_{t_{k+1}}}(x_k)^2 \\
& \leq & 2 \left(\frac{t_{k+1}}{t_k} \lambda_{F_{t_k}}(x_k) + \left(\frac{t_{k+1}}{t_k} - 1\right) \sqrt{\nu}\right)^2  \\
& \leq & 1/4 ,
\end{eqnarray*}
where we used in the last inequality that $t_{k+1} / t_k = 1 + \frac1{13\sqrt{\nu}}$ and $\nu \geq 1$.

Thus using \eqref{eq:trucipm4} one obtains
$$c^{\top} x_k - \min_{x \in \mathcal{X}} c^{\top} x \leq \frac{\nu + \sqrt{\nu} / 3 + 1/12}{t_k} \leq \frac{2 \nu}{t_k} .$$
Observe that $t_{k} = \left(1 + \frac1{13\sqrt{\nu}}\right)^{k} t_0$, which finally yields
$$c^{\top} x_k - \min_{x \in \mathcal{X}} c^{\top} x \leq \frac{2 \nu}{t_0} \left(1 + \frac1{13\sqrt{\nu}}\right)^{- k}.$$

At this point we still need to explain how one can get close to an intial point $x^*(t_0)$ of the central path. This can be done with the following rather clever trick. Assume that one has some point $y_0 \in \cX$. The observation is that $y_0$ is on the central path at $t=1$ for the problem where $c$ is replaced by $- \nabla F(y_0)$. Now instead of following this central path as $t \to +\infty$, one follows it as $t \to 0$. Indeed for $t$ small enough the central paths for $c$ and for $- \nabla F(y_0)$ will be very close. Thus we iterate the following equations, starting with $t_0' = 1$,
\begin{eqnarray*}
& & t_{k+1}' = \left(1 - \frac1{13\sqrt{\nu}}\right) t_k' ,\\
& & y_{k+1} = y_k - [\nabla^2 F(y_k)]^{-1} (- t_{k+1}' \nabla F(y_0) + \nabla F(y_k) ) .
\end{eqnarray*}
A straightforward analysis shows that for $k = O(\sqrt{\nu} \log \nu)$, which corresponds to $t_k'=1/\nu^{O(1)}$, one obtains a point $y_k$ such that $\lambda_{F_{t_k'}}(y_k) \leq 1/4$. In other words one can initialize the path-following scheme with $t_0 = t_k'$ and $x_0 = y_k$.