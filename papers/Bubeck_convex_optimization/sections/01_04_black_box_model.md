---
book: Bubeck_convex_optimization
chapter: 1
chapter_title: Introduction
section: 4
section_title: Black-box model
subsection: null
subsection_title: null
section_id: '1.4'
tex_label: sec:blackbox
theorems: []
lean_files: []
---

\section{Black-box model} \label{sec:blackbox}
We now describe our first model of ``input" for the objective function and the set of constraints. In the black-box model we assume that we have unlimited computational resources, the set of constraint $\cX$ is known, and the objective function $f: \cX \rightarrow \R$ is unknown but can be accessed through queries to {\em oracles}:

\item A zeroth order oracle takes as input a point $x \in \cX$ and outputs the value of $f$ at $x$.
\item A first order oracle takes as input a point $x \in \cX$ and outputs a subgradient of $f$ at $x$.

In this context we are interested in understanding the {\em oracle complexity} of convex optimization, that is how many queries to the oracles are necessary and sufficient to find an $\epsilon$-approximate minima of a convex function. To show an upper bound on the sample complexity we need to propose an algorithm, while lower bounds are obtained by information theoretic reasoning (we need to argue that if the number of queries is ``too small" then we don't have enough information about the function to identify an $\epsilon$-approximate solution).

From a mathematical point of view, the strength of the black-box model is that it will allow us to derive a {\em complete} theory of convex optimization, in the sense that we will obtain matching upper and lower bounds on the oracle complexity for various subclasses of interesting convex functions. While the model by itself does not limit our computational resources (for instance any operation on the constraint set $\cX$ is allowed) we will of course pay special attention to the algorithms' {\em computational complexity} (i.e., the number of elementary operations that the algorithm needs to do). We will also be interested in the situation where the set of constraint $\cX$ is unknown and can only be accessed through a {\em separation oracle}: given $x \in \R^n$, it outputs either that $x$ is in $\mathcal{X}$, or if $x \not\in \mathcal{X}$ then it outputs a separating hyperplane between $x$ and $\mathcal{X}$. 

The black-box model was essentially developed in the early days of convex optimization (in the Seventies) with \cite{NY83} being still an important reference for this theory (see also \cite{Nem95}). In the recent years this model and the corresponding algorithms have regained a lot of popularity, essentially for two reasons:

\item It is possible to develop algorithms with dimension-free oracle complexity which is quite attractive for optimization problems in very high dimension.
\item Many algorithms developed in this model are robust to noise in the output of the oracles. This is especially interesting for stochastic optimization, and very relevant to machine learning applications. We will explore this in details in Chapter \ref{rand}.

Chapter \ref{finitedim}, Chapter \ref{dimfree} and Chapter \ref{mirror} are dedicated to the study of the black-box model (noisy oracles are discussed in Chapter \ref{rand}). We do not cover the setting where only a zeroth order oracle is available, also called derivative free optimization, and we refer to \cite{CSV09, ABM11} for further references on this.