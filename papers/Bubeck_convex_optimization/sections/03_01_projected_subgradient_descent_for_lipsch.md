---
book: Bubeck_convex_optimization
chapter: 3
chapter_title: Dimension-free convex optimization
section: 1
section_title: Projected subgradient descent for Lipschitz functions
subsection: null
subsection_title: null
section_id: '3.1'
tex_label: sec:psgd
theorems:
- id: Theorem 3.2
  label: ''
  tex_label: th:pgd
lean_files:
- id: Theorem 3.2
  path: proofs/Bubeck_convex_optimization/Theorem32.lean
  status: pending
---

\section{Projected subgradient descent for Lipschitz functions} \label{sec:psgd}
In this section we assume that $\cX$ is contained in an Euclidean ball centered at $x_1 \in \cX$ and of radius $R$. Furthermore we assume that $f$ is such that for any $x \in \cX$ and any $g \in \partial f(x)$ (we assume $\partial f(x) \neq \emptyset$), one has $\|g\| \leq L$. Note that by the subgradient inequality and Cauchy-Schwarz this implies that $f$ is $L$-Lipschitz on $\cX$, that is $|f(x) - f(y)| \leq L \|x-y\|$. 

In this context we make two modifications to the basic gradient descent \eqref{eq:Cau47}. First, obviously, we replace the gradient $\nabla f(x)$ (which may not exist) by a subgradient $g \in \partial f(x)$. Secondly, and more importantly, we make sure that the updated point lies in $\cX$ by projecting back (if necessary) onto it. This gives the {\em projected subgradient descent} algorithm) \leq f(x_t)$. In that sense the projected subgradient descent is not a descent method.} which iterates the following equations for $t \geq 1$:

& y_{t+1} = x_t - \eta g_t , \ \text{where} \ g_t \in \partial f(x_t) , \label{eq:PGD1}\\
& x_{t+1} = \Pi_{\cX}(y_{t+1}) . \label{eq:PGD2}

This procedure is illustrated in Figure \ref{fig:pgd}. We prove now a rate of convergence for this method under the above assumptions.

\draw[rotate=30, very thick] (0,0) ellipse (0.5 and 0.7);
\node [tokens=1] (noeud1) at (-0.25,0.1) [label=below right:{$x_t$}] {};
\node [tokens=1] (noeud2) at (-0.8, 0.9) [label=above left:{$y_{t+1}$}] {};
\draw[->, thick] (noeud1) -- (noeud2) node[midway, left] {{c} \\ gradient step \\ \eqref{eq:PGD1} };

\node [tokens=1] (noeud3) at (-60:-0.7) [label=below right:{$x_{t+1}$}] {};
\draw[->, thick] (noeud2) -- (noeud3) node[midway, right] {projection \eqref{eq:PGD2}};
\node at (0.3,-0.4) {$\cX$};

\caption{Illustration of the projected subgradient descent method.}
\label{fig:pgd}

**Theorem**
 \label{th:pgd}
The projected subgradient descent method with $\eta = \frac{R}{L \sqrt{t}}$ satisfies 

$$f\left(\frac{1}{t} \sum_{s=1}^t x_s\right) - f(x^*) \leq \frac{R L}{\sqrt{t}} .$$

*Proof.*

Using the definition of subgradients, the definition of the method, and the elementary identity $2 a^{\top} b = \|a\|^2 + \|b\|^2 - \|a-b\|^2$, one obtains
\begin{eqnarray*}
f(x_s) - f(x^*) & \leq & g_s^{\top} (x_s - x^*) \\
& = & \frac{1}{\eta} (x_s - y_{s+1})^{\top} (x_s - x^*) \\
& = & \frac{1}{2 \eta} \left(\|x_s - x^*\|^2 + \|x_s - y_{s+1}\|^2 - \|y_{s+1} - x^*\|^2\right) \\
& = & \frac{1}{2 \eta} \left(\|x_s - x^*\|^2 - \|y_{s+1} - x^*\|^2\right) + \frac{\eta}{2} \|g_s\|^2.
\end{eqnarray*}
Now note that $\|g_s\| \leq L$, and furthermore by Lemma \ref{lem:todonow}

$$\|y_{s+1} - x^*\| \geq \|x_{s+1} - x^*\| .$$

Summing the resulting inequality over $s$, and using that $\|x_1 - x^*\| \leq R$ yield
$$\sum_{s=1}^t \left( f(x_s) - f(x^*) \right) \leq \frac{R^2}{2 \eta} + \frac{\eta L^2 t}{2} .$$
Plugging in the value of $\eta$ directly gives the statement (recall that by convexity $f((1/t) \sum_{s=1}^t x_s) \leq \frac1{t} \sum_{s=1}^t f(x_s)$).

We will show in Section \ref{sec:chap3LB} that the rate given in Theorem \ref{th:pgd} is unimprovable from a black-box perspective. Thus to reach an $\epsilon$-optimal point one needs $\Theta(1/\epsilon^2)$ calls to the oracle. In some sense this is an astonishing result as this complexity is independent for more on this.} of the ambient dimension $n$. On the other hand this is also quite disappointing compared to the scaling in $\log(1/\epsilon)$ of the center of gravity and ellipsoid method of Chapter \ref{finitedim}. To put it differently with gradient descent one could hope to reach a reasonable accuracy in very high dimension, while with the ellipsoid method one can reach very high accuracy in reasonably small dimension. A major task in the following sections will be to explore more restrictive assumptions on the function to be optimized in order to have the best of both worlds, that is an oracle complexity independent of the dimension and with a scaling in $\log(1/\epsilon)$.

The computational bottleneck of the projected subgradient descent is often the projection step \eqref{eq:PGD2} which is a convex optimization problem by itself. In some cases this problem may admit an analytical solution (think of $\cX$ being an Euclidean ball), or an easy and fast combinatorial algorithm to solve it (this is the case for $\cX$ being an $\ell_1$-ball, see \cite{MP89}). We will see in Section \ref{sec:FW} a projection-free algorithm which operates under an extra assumption of smoothness on the function to be optimized.

Finally we observe that the step-size recommended by Theorem \ref{th:pgd} depends on the number of iterations to be performed. In practice this may be an undesirable feature. However using a time-varying step size of the form $\eta_s = \frac{R}{L \sqrt{s}}$ one can prove the same rate up to a $\log t$ factor. In any case these step sizes are very small, which is the reason for the slow convergence. In the next section we will see that by assuming {\em smoothness} in the function $f$ one can afford to be much more aggressive. Indeed in this case, as one approaches the optimum the size of the gradients themselves will go to $0$, resulting in a sort of ``auto-tuning" of the step sizes which does not happen for an arbitrary convex function.