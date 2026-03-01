---
book: Bubeck_convex_optimization
chapter: 6
chapter_title: Convex optimization and randomness
section: 5
section_title: Acceleration by randomization for saddle points
subsection: null
subsection_title: null
section_id: '6.5'
tex_label: ''
theorems:
- id: Theorem 6.10
  label: ''
  tex_label: th:sspmd
lean_files:
- id: Theorem 6.10
  path: proofs/Bubeck_convex_optimization/Theorem610.lean
  status: pending
---

\section{Acceleration by randomization for saddle points}
We explore now the use of randomness for saddle point computations. That is we consider the context of Section \ref{sec:sp} with a stochastic oracle of the following form: given $z=(x,y) \in \cX \times \cY$ it outputs $\tg(z) = (\tg_{\cX}(x,y), \tg_{\cY}(x,y))$ where $\E \ (\tg_{\cX}(x,y) | x,y) \in \partial_x \phi(x,y)$, and $\E \ (\tg_{\cY}(x,y) | x,y) \in \partial_y (-\phi(x,y))$. Instead of using true subgradients as in SP-MD (see Section \ref{sec:spmd}) we use here the outputs of the stochastic oracle. We refer to the resulting algorithm as S-SP-MD (Stochastic Saddle Point Mirror Descent). Using the same reasoning than in Section \ref{sec:smd} and Section \ref{sec:spmd} one can derive the following theorem.

**Theorem**
 \label{th:sspmd}
Assume that the stochastic oracle is such that $\E \left(\|\tg_{\cX}(x,y)\|_{\cX}^* \right)^2 \leq B_{\cX}^2$, and $\E \left(\|\tg_{\cY}(x,y)\|_{\cY}^* \right)^2 \leq B_{\cY}^2$. Then S-SP-MD with $a= \frac{B_{\cX}}{R_{\cX}}$, $b=\frac{B_{\cY}}{R_{\cY}}$, and $\eta=\sqrt{\frac{2}{t}}$ satisfies
$$\E \left( \max_{y \in \mathcal{Y}} \phi\left( \frac1{t} \sum_{s=1}^t x_s,y \right) - \min_{x \in \mathcal{X}} \phi\left(x, \frac1{t} \sum_{s=1}^t y_s \right) \right) \leq (R_{\cX} B_{\cX} + R_{\cY} B_{\cY}) \sqrt{\frac{2}{t}}.$$

Using S-SP-MD we revisit the examples of Section \ref{sec:spex2} and Section \ref{sec:spex3}. In both cases one has $\phi(x,y) = x^{\top} A y$ (with $A_i$ being the $i^{th}$ column of $A$), and thus $\nabla_x \phi(x,y) = Ay$ and $\nabla_y \phi(x,y) = A^{\top} x$.
\newline

\noindent
**Matrix games.** Here $x \in \Delta_n$ and $y \in \Delta_m$. Thus there is a quite natural stochastic oracle:
 \label{eq:oraclematrixgame}
\tg_{\cX}(x,y) = A_I, \; \text{where} \; I \in [m] \; \text{is drawn according to} \; y \in \Delta_m ,

and $\forall i \in [m]$,
 \label{eq:oraclematrixgame2}
\tg_{\cY}(x,y)(i) = A_i(J), \; \text{where} \; J \in [n] \; \text{is drawn according to} \; x \in \Delta_n .

Clearly $\|\tg_{\cX}(x,y)\|_{\infty} \leq \|A\|_{\mathrm{max}}$ and $\|\tg_{\cX}(x,y)\|_{\infty} \leq \|A\|_{\mathrm{max}}$, which implies that S-SP-MD attains an $\epsilon$-optimal pair of points with $O\left(\|A\|_{\mathrm{max}}^2 \log(n+m) / \epsilon^2 \right)$ iterations. Furthermore the computational complexity of a step of S-SP-MD is dominated by drawing the indices $I$ and $J$ which takes $O(n + m)$. Thus overall the complexity of getting an $\epsilon$-optimal Nash equilibrium with S-SP-MD is $O\left(\|A\|_{\mathrm{max}}^2 (n + m) \log(n+m) / \epsilon^2  \right)$. While the dependency on $\epsilon$ is worse than for SP-MP (see Section \ref{sec:spex2}), the dependencies on the dimensions is $\tilde{O}(n+m)$ instead of $\tilde{O}(nm)$. In particular, quite astonishingly, this is {\em sublinear} in the size of the matrix $A$. The possibility of sublinear algorithms for this problem was first observed in \cite{GK95}.
\newline

\noindent
**Linear classification.** Here $x \in \mB_{2,n}$ and $y \in \Delta_m$. Thus the stochastic oracle for the $x$-subgradient can be taken as in \eqref{eq:oraclematrixgame} but for the $y$-subgradient we modify \eqref{eq:oraclematrixgame2} as follows. For a vector $x$ we denote by $x^2$ the vector such that $x^2(i) = x(i)^2$. For all $i \in [m]$,
$$\tg_{\cY}(x,y)(i) = \frac{\|x\|^2}{x(j)} A_i(J), \; \text{where} \; J \in [n] \; \text{is drawn according to} \; \frac{x^2}{\|x\|_2^2} \in \Delta_n .$$ 
Note that one indeed has $\E (\tg_{\cY}(x,y)(i) | x,y) = \sum_{j=1}^n x(j) A_i(j) = (A^{\top} x)(i)$.
Furthermore $\|\tg_{\cX}(x,y)\|_2 \leq B$, and
$$\E (\|\tg_{\cY}(x,y)\|_{\infty}^2 | x,y) = \sum_{j=1}^n \frac{x(j)^2}{\|x\|_2^2} \max_{i \in [m]} \left(\frac{\|x\|^2}{x(j)} A_i(j)\right)^2 \leq \sum_{j=1}^n \max_{i \in [m]} A_i(j)^2 .$$
Unfortunately this last term can be $O(n)$. However it turns out that one can do a more careful analysis of mirror descent in terms of local norms, which allows to prove that the ``local variance" is dimension-free. We refer to \cite{BC12} for more details on these local norms, and to \cite{CHW12} for the specific details in the linear classification situation.