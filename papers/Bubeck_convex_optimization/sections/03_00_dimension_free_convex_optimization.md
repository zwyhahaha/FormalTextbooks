---
book: Bubeck_convex_optimization
chapter: 3
chapter_title: Dimension-free convex optimization
section: 0
section_title: Dimension-free convex optimization
subsection: null
subsection_title: null
section_id: '3.0'
tex_label: ''
theorems:
- id: Lemma 3.1
  label: ''
  tex_label: lem:todonow
lean_files:
- id: Lemma 3.1
  path: proofs/Bubeck_convex_optimization/Lemma31.lean
  status: pending
---

We investigate here variants of the {\em gradient descent} scheme. This iterative algorithm, which can be traced back to \cite{Cau47}, is the simplest strategy to minimize a differentiable function $f$ on $\R^n$. Starting at some initial point $x_1 \in \R^n$ it iterates the following equation:
 \label{eq:Cau47}
x_{t+1} = x_t - \eta \nabla f(x_t) ,

where $\eta > 0$ is a fixed step-size parameter. The rationale behind \eqref{eq:Cau47} is to make a small step in the direction that minimizes the local first order Taylor approximation of $f$ (also known as the steepest descent direction). 

As we shall see, methods of the type \eqref{eq:Cau47} can obtain an oracle complexity {\em independent of the dimension}. This feature makes them particularly attractive for optimization in very high dimension.

Apart from Section \ref{sec:FW}, in this chapter $\|\cdot\|$ denotes the Euclidean norm. The set of constraints $\cX \subset \R^n$ is assumed to be compact and convex. 

We define the projection operator $\Pi_{\cX}$ on $\cX$ by
$$\Pi_{\cX}(x) = \argmin_{y \in \mathcal{X}} \|x - y\| .$$
The following lemma will prove to be useful in our study. It is an easy corollary of Proposition \ref{prop:firstorder}, see also Figure \ref{fig:pythagore}.

**Lemma**
 \label{lem:todonow}
Let $x \in \cX$ and $y \in \R^n$, then
$$(\Pi_{\cX}(y) - x)^{\top} (\Pi_{\cX}(y) - y) \leq 0 ,$$
which also implies $\|\Pi_{\cX}(y) - x\|^2 + \|y - \Pi_{\cX}(y)\|^2 \leq \|y - x\|^2$.

\clip (0.4,-0.4) rectangle (-1.2,1.2);
\draw[rotate=30, very thick] (0,0) ellipse (0.5 and 0.7);
\node [tokens=1] (noeud1) at (-0.45,-0.1) [label=right:{$x$}] {};
\node [tokens=1] (noeud2) at (-0.6, 0.8) [label=above left:{$y$}] {};
\draw[<->, thick] (noeud1) -- (noeud2) node[midway, below left] {$\|y - x \|$};
\node [tokens=1] (noeud3) at (-60:-0.7) [label=below right:{$\Pi_{\cX}(y)$}] {};
\draw[<->, thick] (noeud2) -- (noeud3) node[midway, above right] {$\|y - \Pi_{\cX}(y) \|$};
\draw[<->, thick] (noeud1) -- (noeud3) node[midway, right] {$\|\Pi_{\cX}(y) - x\|$};
\node at (0.15,-0.2) {$\cX$};

\caption{Illustration of Lemma \ref{lem:todonow}.}
\label{fig:pythagore}

Unless specified otherwise all the proofs in this chapter are taken from \cite{Nes04} (with slight simplification in some cases).