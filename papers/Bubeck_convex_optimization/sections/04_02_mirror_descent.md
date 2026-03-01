---
book: Bubeck_convex_optimization
chapter: 4
chapter_title: Almost dimension-free convex optimization in non-Euclidean spaces
section: 2
section_title: Mirror descent
subsection: null
subsection_title: null
section_id: '4.2'
tex_label: sec:MD
theorems:
- id: Theorem 4.2
  label: ''
  tex_label: th:MD
lean_files:
- id: Theorem 4.2
  path: proofs/Bubeck_convex_optimization/Theorem42.lean
  status: pending
---

\section{Mirror descent} \label{sec:MD}
We can now describe the mirror descent strategy based on a mirror map $\Phi$. Let $x_1 \in \argmin_{x \in \mathcal{X} \cap \mathcal{D}} \Phi(x)$. Then for $t \geq 1$, let $y_{t+1} \in \mathcal{D}$ such that
 \label{eq:MD1}
\nabla \Phi(y_{t+1}) = \nabla \Phi(x_{t}) - \eta g_t, \ \text{where} \ g_t \in \partial f(x_t) ,

and
 \label{eq:MD2}
x_{t+1} \in \Pi_{\cX}^{\Phi} (y_{t+1}) .

See Figure \ref{fig:MD} for an illustration of this procedure.

\clip (-2.4,-0.7) rectangle (1,1);
\draw[rotate=30, very thick] (0,-0.5) ellipse (0.7 and 1);
\draw[very thick] (-2,0) ellipse (1 and 0.5);
\node (S) [very thick, regular polygon, regular polygon sides=6, draw,
inner sep=20] at (0,0) {};
\node at (0.3,-0.6) {$\cD$};
\node at (-1.9,-0.4) {$\R^n$};
\node at (0.1, -0.2) {$\cX$};
\node [tokens=1] (noeudat) at (-0.1,0.15) [label=right:{$x_t$}] {};
\node [tokens=1] (noeudat1) at (-0.15,-0.1) [label=right:{$x_{t+1}$}] {};
\node [tokens=1] (noeudwt1) at (-0.4,-0.45) [label=below right:{$y_{t+1}$}] {};
\draw[->, thick] (noeudwt1) .. controls (-0.3, -0.45) and (-0.15, -0.2) .. (noeudat1) node[midway, below right] {projection \eqref{eq:MD2}};
\node [tokens=1] (noeudmat) at (-1.62,0.15) [label=right:{$\nabla \Phi(x_t)$}] {};
\node [tokens=1] (noeudmwt1) at (-1.42,-0.1) [label=right:{$\nabla \Phi(y_{t+1})$}] {};
\draw[->, thick] (noeudmat) -- (noeudmwt1) node[midway, left] {{c} \\ gradient step \\ \eqref{eq:MD1} };
\draw[->, semithick] (noeudat) .. controls (-0.6,0.45) and (-1.12, 0.45) .. (noeudmat) node[midway, above] {$\nabla \Phi$}; 
\draw[->, semithick] (noeudmwt1) .. controls (-1.22,-0.5) and (-0.44, -0.46) .. (noeudwt1) node[midway, below] {$(\nabla \Phi)^{-1}$}; 

\caption{Illustration of mirror descent.}
\label{fig:MD}

**Theorem**
 \label{th:MD}
Let $\Phi$ be a mirror map $\rho$-strongly convex on $\mathcal{X} \cap \mathcal{D}$ w.r.t. $\|\cdot\|$.
Let $R^2 = \sup_{x \in \mathcal{X} \cap \mathcal{D}} \Phi(x) - \Phi(x_1)$, and $f$ be convex and $L$-Lipschitz w.r.t. $\|\cdot\|$. Then mirror descent with $\eta = \frac{R}{L} \sqrt{\frac{2 \rho}{t}}$ satisfies
$$f\bigg(\frac{1}{t} \sum_{s=1}^t x_s \bigg) - f(x^*) \leq RL \sqrt{\frac{2}{\rho t}} .$$

*Proof.*

Let $x \in \mathcal{X} \cap \mathcal{D}$. The claimed bound will be obtained by taking a limit $x \rightarrow x^*$. Now by convexity of $f$, the definition of mirror descent, equation \eqref{eq:useful1}, and Lemma \ref{lem:todonow2}, one has
\begin{align*}
& f(x_s) - f(x) \\
& \leq g_s^{\top} (x_s - x) \\
& = \frac{1}{\eta} (\nabla \Phi(x_s) - \nabla \Phi(y_{s+1}))^{\top} (x_s - x) \\
& = \frac{1}{\eta} \bigg( D_{\Phi}(x, x_s) + D_{\Phi}(x_s, y_{s+1}) - D_{\Phi}(x, y_{s+1}) \bigg) \\
& \leq \frac{1}{\eta} \bigg( D_{\Phi}(x, x_s) + D_{\Phi}(x_s, y_{s+1}) - D_{\Phi}(x, x_{s+1}) - D_{\Phi}(x_{s+1}, y_{s+1}) \bigg) .
\end{align*}
The term $D_{\Phi}(x, x_s) -  D_{\Phi}(x, x_{s+1})$ will lead to a telescopic sum when summing over $s=1$ to $s=t$, and it remains to bound the other term as follows using $\rho$-strong convexity of the mirror map and $a z - b z^2 \leq \frac{a^2}{4 b}, \forall z \in \R$:
\begin{align*}
& D_{\Phi}(x_s, y_{s+1}) - D_{\Phi}(x_{s+1}, y_{s+1}) \\
& = \Phi(x_s) - \Phi(x_{s+1}) - \nabla \Phi(y_{s+1})^{\top} (x_{s} - x_{s+1}) \\
& \leq (\nabla \Phi(x_s) - \nabla \Phi(y_{s+1}))^{\top} (x_{s} - x_{s+1}) - \frac{\rho}{2} \|x_s - x_{s+1}\|^2 \\
& = \eta g_s^{\top} (x_{s} - x_{s+1}) - \frac{\rho}{2} \|x_s - x_{s+1}\|^2 \\
& \leq \eta L \|x_{s} - x_{s+1}\| - \frac{\rho}{2} \|x_s - x_{s+1}\|^2 \\
& \leq \frac{(\eta L)^2}{2 \rho}.
\end{align*}
We proved 
$$\sum_{s=1}^t \bigg(f(x_s) - f(x)\bigg) \leq \frac{D_{\Phi}(x,x_1)}{\eta} + \eta \frac{L^2 t}{2 \rho},$$
which concludes the proof up to trivial computation.

We observe that one can rewrite mirror descent as follows:

x_{t+1} & = & \argmin_{x \in \mathcal{X} \cap \mathcal{D}} \ D_{\Phi}(x,y_{t+1}) \notag \\
& = & \argmin_{x \in \mathcal{X} \cap \mathcal{D}} \ \Phi(x) - \nabla \Phi(y_{t+1})^{\top} x \label{eq:MD3} \\
& = & \argmin_{x \in \mathcal{X} \cap \mathcal{D}} \ \Phi(x) - (\nabla \Phi(x_{t}) - \eta g_t)^{\top} x \notag \\
& = & \argmin_{x \in \mathcal{X} \cap \mathcal{D}} \ \eta g_t^{\top} x + D_{\Phi}(x,x_t) . \label{eq:MDproxview}

This last expression is often taken as the definition of mirror descent (see \cite{BT03}). It gives a proximal point of view on mirror descent: the method is trying to minimize the local linearization of the function while not moving too far away from the previous point, with distances measured via the Bregman divergence of the mirror map.