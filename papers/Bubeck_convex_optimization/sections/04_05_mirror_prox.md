---
book: Bubeck_convex_optimization
chapter: 4
chapter_title: Almost dimension-free convex optimization in non-Euclidean spaces
section: 5
section_title: Mirror prox
subsection: null
subsection_title: null
section_id: '4.5'
tex_label: ''
theorems:
- id: Theorem 4.4
  label: ''
  tex_label: ''
lean_files:
- id: Theorem 4.4
  path: proofs/Bubeck_convex_optimization/Theorem44.lean
  status: pending
---

\section{Mirror prox}
It can be shown that mirror descent accelerates for smooth functions to the rate $1/t$. We will prove this result in Chapter \ref{rand} (see Theorem \ref{th:SMDsmooth}). We describe here a variant of mirror descent which also attains the rate $1/t$ for smooth functions. This method is called mirror prox and it was introduced in \cite{Nem04}. 

The true power of mirror prox will reveal itself later in the text when we deal with smooth representations of non-smooth functions as well as stochastic oracles), while mirror descent does not.}.

Mirror prox is described by the following equations:
\begin{align*}
& \nabla \Phi(y_{t+1}') = \nabla \Phi(x_{t}) - \eta \nabla f(x_t), \\ \\
& y_{t+1} \in \argmin_{x \in \mathcal{X} \cap \mathcal{D}} D_{\Phi}(x,y_{t+1}') , \\  \\
& \nabla \Phi(x_{t+1}') = \nabla \Phi(x_{t}) - \eta \nabla f(y_{t+1}), \\ \\
& x_{t+1} \in \argmin_{x \in \mathcal{X} \cap \mathcal{D}} D_{\Phi}(x,x_{t+1}') .
\end{align*}
In words the algorithm first makes a step of mirror descent to go from $x_t$ to $y_{t+1}$, and then it makes a similar step to obtain $x_{t+1}$, starting again from $x_t$ but this time using the gradient of $f$ evaluated at $y_{t+1}$ (instead of $x_t$), see Figure \ref{fig:mp} for an illustration. The following result justifies the procedure.

\clip (-2.4,-0.7) rectangle (0.5,1);
\draw[rotate=30, very thick] (0,-0.5) ellipse (0.73 and 1);
\draw[very thick] (-2,0) ellipse (1 and 0.5);
\node (S) [very thick, regular polygon, regular polygon sides=6, draw,
inner sep=22] at (0,0) {};
\node at (0.3,-0.6) {$\cD$};
\node at (-2.2,-0.4) {$\R^n$};
\node at (0.12, -0.22) {$\cX$};
\node [tokens=1] (noeudat) at (-0.1,0.15) [label=right:{$x_t$}] {};
\node [tokens=1] (noeudat1) at (-0.15,-0.13) [label=right:{$y_{t+1}$}] {};
\node [tokens=1] (noeudwt1) at (-0.4,-0.45) [label=below right:{$y_{t+1}'$}] {};
\draw[->, thick] (noeudwt1) .. controls (-0.3, -0.45) and (-0.15, -0.2) .. (noeudat1) node[midway, below right] {projection};
\node [tokens=1] (noeudat3) at (-0.2,0) [label=right:{$x_{t+1}$}] {};
\node [tokens=1] (noeudwt3) at (-0.3,-0.2) [label=left:{$x_{t+1}'$}] {};
\draw[->, thick] (noeudwt3) .. controls (-0.22, -0.12) and (-0.22, -0.1) .. (noeudat3) {};
\node [tokens=1] (noeudmat) at (-1.7,0.3) [label=right:{$\nabla \Phi(x_t)$}] {};
\node [tokens=1] (noeudmwt1) at (-2,-0.2) [label=below right:{$\nabla \Phi(y_{t+1}')$}] {};
\node [tokens=1] (noeudmwt2) at (-1.6,-0.1) [label=right:{$\nabla \Phi(x_{t+1}')$}] {};
\draw[->, thick] (noeudmat) -- (noeudmwt2) node[midway, right] {$- \eta \nabla f(y_{t+1})$};
\draw[->, thick, dashed] (noeudmat) -- (noeudmwt1) node[midway, left] {$- \eta \nabla f(x_t)$};
\draw[->, semithick] (-0.4,0.5) .. controls (-0.7,0.6) and (-1, 0.6) .. (-1.3,0.5) node[midway, above] {$\nabla \Phi$}; 
\draw[->, semithick] (-1.45,-0.5) .. controls (-1.15,-0.6) and (-0.85, -0.6) .. (-0.55,-0.5) node[midway, below] {$(\nabla \Phi)^{-1}$}; 

\caption{Illustration of mirror prox.}
\label{fig:mp}

**Theorem**

Let $\Phi$ be a mirror map $\rho$-strongly convex on $\mathcal{X} \cap \mathcal{D}$ w.r.t. $\|\cdot\|$. Let $R^2 = \sup_{x \in \mathcal{X} \cap \mathcal{D}} \Phi(x) - \Phi(x_1)$, and $f$ be convex and $\beta$-smooth w.r.t. $\|\cdot\|$. Then mirror prox with $\eta = \frac{\rho}{\beta}$ satisfies
$$f\bigg(\frac{1}{t} \sum_{s=1}^t y_{s+1} \bigg) - f(x^*) \leq \frac{\beta R^2}{\rho t} .$$

*Proof.*

Let $x \in \mathcal{X} \cap \mathcal{D}$. We write
\begin{eqnarray*}
f(y_{t+1}) - f(x) & \leq & \nabla f(y_{t+1})^{\top} (y_{t+1} - x) \\
& = & \nabla f(y_{t+1})^{\top} (x_{t+1} - x) + \nabla f(x_t)^{\top} (y_{t+1} - x_{t+1}) \\
& & + (\nabla f(y_{t+1}) - \nabla f(x_t))^{\top} (y_{t+1} - x_{t+1}) .
\end{eqnarray*}
We will now bound separately these three terms. For the first one, using the definition of the method, Lemma \ref{lem:todonow2}, and equation \eqref{eq:useful1}, one gets
\begin{align*}
& \eta \nabla f(y_{t+1})^{\top} (x_{t+1} - x) \\
& = ( \nabla \Phi(x_t) - \nabla \Phi(x_{t+1}'))^{\top} (x_{t+1} - x) \\
& \leq ( \nabla \Phi(x_t) - \nabla \Phi(x_{t+1}))^{\top} (x_{t+1} - x) \\
& = D_{\Phi}(x,x_t) - D_{\Phi}(x, x_{t+1}) - D_{\Phi}(x_{t+1}, x_t) .
\end{align*}
For the second term using the same properties than above and the strong-convexity of the mirror map one obtains

& \eta \nabla f(x_t)^{\top} (y_{t+1} - x_{t+1}) \notag\\
& = ( \nabla \Phi(x_t) - \nabla \Phi(y_{t+1}'))^{\top} (y_{t+1} - x_{t+1}) \notag\\
& \leq ( \nabla \Phi(x_t) - \nabla \Phi(y_{t+1}))^{\top} (y_{t+1} - x_{t+1}) \notag\\
& = D_{\Phi}(x_{t+1},x_t) - D_{\Phi}(x_{t+1}, y_{t+1}) - D_{\Phi}(y_{t+1}, x_t) \label{eq:pourplustard1}\\
& \leq D_{\Phi}(x_{t+1},x_t) - \frac{\rho}{2} \|x_{t+1} - y_{t+1} \|^2 - \frac{\rho}{2} \|y_{t+1} - x_t\|^2 . \notag

Finally for the last term, using Cauchy-Schwarz, $\beta$-smoothness, and $2 ab \leq a^2 + b^2$ one gets
\begin{align*}
& (\nabla f(y_{t+1}) - \nabla f(x_t))^{\top} (y_{t+1} - x_{t+1}) \\
& \leq \|\nabla f(y_{t+1}) - \nabla f(x_t)\|_*  \cdot \|y_{t+1} - x_{t+1} \| \\
& \leq \beta \|y_{t+1} - x_t\| \cdot \|y_{t+1} - x_{t+1} \| \\
& \leq \frac{\beta}{2} \|y_{t+1} - x_t\|^2 + \frac{\beta}{2}  \|y_{t+1} - x_{t+1} \|^2 . 
\end{align*}
Thus summing up these three terms and using that $\eta = \frac{\rho}{\beta}$ one gets
$$f(y_{t+1}) - f(x) \leq \frac{D_{\Phi}(x,x_t) - D_{\Phi}(x,x_{t+1})}{\eta} .$$
The proof is concluded with straightforward computations.