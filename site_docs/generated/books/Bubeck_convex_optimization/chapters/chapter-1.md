# Chapter 1 — Introduction

## Section 1.0 — Introduction

### [Definition 1.1 — Convex sets and convex functions](../results/definition-1-1.md)

**Definition** (Convex sets and convex functions)

A set $\cX \subset \R^n$ is said to be convex if it contains all of its segments, that is

\[
\forall (x,y,\gamma) \in \cX \times \cX \times [0,1], \; (1-\gamma) x + \gamma y \in \mathcal{X}.
\]

A function $f : \mathcal{X} \rightarrow \R$ is said to be convex if it always lies below its chords, that is

\[
\forall (x,y,\gamma) \in \cX \times \cX \times [0,1], \; f((1-\gamma) x + \gamma y) \leq (1-\gamma)f(x) + \gamma f(y) .
\]

We are interested in algorithms that take as input a convex set $\cX$ and a convex function $f$ and output an approximate minimum of $f$ over $\cX$. We write compactly the problem of finding the minimum of $f$ over $\cX$ as
\begin{align*}
& \mathrm{min.} \; f(x) \\
& \text{s.t.} \; x \in \cX .
\end{align*}
In the following we will make more precise how the set of constraints $\cX$ and the objective function $f$ are specified to the algorithm. Before that we proceed to give a few important examples of convex optimization problems in machine learning.

## Section 1.2 — Basic properties of convexity

### [Theorem 1.2 — Separation Theorem](../results/theorem-1-2.md)

**Theorem** (Separation Theorem)

Let $\mathcal{X} \subset \R^n$ be a closed convex set, and $x_0 \in \R^n \setminus \mathcal{X}$. Then, there exists $w \in \R^n$ and $t \in \R$ such that

\[
w^{\top} x_0 < t, \; \text{and} \; \forall x \in \mathcal{X}, w^{\top} x \geq t.
\]

Note that if $\mathcal{X}$ is not closed then one can only guarantee that $w^{\top} x_0 \leq w^{\top} x, \forall x \in \mathcal{X}$ (and $w \neq 0$). This immediately implies the Supporting Hyperplane Theorem ($\partial \cX$ denotes the boundary of $\cX$, that is the closure without the interior):

### [Theorem 1.3 — Supporting Hyperplane Theorem](../results/theorem-1-3.md)

**Theorem** (Supporting Hyperplane Theorem)

Let $\mathcal{X} \subset \R^n$ be a convex set, and $x_0 \in \partial \mathcal{X}$. Then, there exists $w \in \R^n, w \neq 0$ such that

\[
\forall x \in \mathcal{X}, w^{\top} x \geq w^{\top} x_0.
\]

We introduce now the key notion of {\em subgradients}.

### [Definition 1.4 — Subgradients](../results/definition-1-4.md)

**Definition** (Subgradients)

Let $\mathcal{X} \subset \R^n$, and $f : \mathcal{X} \rightarrow \R$. Then $g \in \R^n$ is a subgradient of $f$ at $x \in \mathcal{X}$ if for any $y \in \mathcal{X}$ one has

\[
f(x) - f(y) \leq g^{\top} (x - y) .
\]

The set of subgradients of $f$ at $x$ is denoted $\partial f (x)$.

To put it differently, for any $x \in \cX$ and $g \in \partial f(x)$, $f$ is above the linear function $y \mapsto f(x) + g^{\top} (y-x)$. The next result shows (essentially) that a convex functions always admit subgradients.

### [Proposition 1.5 — Existence of subgradients](../results/proposition-1-5.md)

**Proposition** (Existence of subgradients)

Let $\mathcal{X} \subset \R^n$ be convex, and $f : \mathcal{X} \rightarrow \R$. If $\forall x \in \mathcal{X}, \partial f(x) \neq \emptyset$ then $f$ is convex. Conversely if $f$ is convex then for any $x \in \mathrm{int}(\mathcal{X}), \partial f(x) \neq \emptyset$. Furthermore if $f$ is convex and differentiable at $x$ then $\nabla f(x) \in \partial f(x)$. 

Before going to the proof we recall the definition of the epigraph of a function $f : \mathcal{X} \rightarrow \R$:

\[
\mathrm{epi}(f) = \{(x,t) \in \mathcal{X} \times \R : t \geq f(x) \} .
\]

It is obvious that a function is convex if and only if its epigraph is a convex set.

## Section 1.3 — Why convexity?

### [Proposition 1.6 — Local minima are global minima](../results/proposition-1-6.md)

**Proposition** (Local minima are global minima)

Let $f$ be convex. If $x$ is a local minimum of $f$ then $x$ is a global minimum of $f$. Furthermore this happens if and only if $0 \in \partial f(x)$.

### [Proposition 1.7 — First order optimality condition](../results/proposition-1-7.md)

**Proposition** (First order optimality condition)

Let $f$ be convex and $\cX$ a closed convex set on which $f$ is differentiable. Then

\[
x^* \in \argmin_{x \in \cX} f(x) ,
\]

if and only if one has

\[
\nabla f(x^*)^{\top}(x^*-y) \leq 0, \forall y \in \cX .
\]
