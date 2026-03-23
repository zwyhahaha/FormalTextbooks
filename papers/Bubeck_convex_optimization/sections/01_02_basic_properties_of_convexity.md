---
book: Bubeck_convex_optimization
chapter: 1
chapter_title: Introduction
section: 2
section_title: Basic properties of convexity
subsection: null
subsection_title: null
section_id: '1.2'
tex_label: ''
theorems:
- id: Theorem 1.2
  label: Separation Theorem
  tex_label: ''
- id: Theorem 1.3
  label: Supporting Hyperplane Theorem
  tex_label: ''
- id: Definition 1.4
  label: Subgradients
  tex_label: ''
- id: Proposition 1.5
  label: Existence of subgradients
  tex_label: prop:existencesubgradients
lean_files:
- id: Theorem 1.2
  path: proofs/Bubeck_convex_optimization/Theorem12.lean
  status: proved
- id: Theorem 1.3
  path: proofs/Bubeck_convex_optimization/Theorem13.lean
  status: pending
- id: Definition 1.4
  path: proofs/Bubeck_convex_optimization/Definition14.lean
  status: proved
- id: Proposition 1.5
  path: proofs/Bubeck_convex_optimization/Proposition15.lean
  status: proved

---

\section{Basic properties of convexity}
A basic result about convex sets that we shall use extensively is the Separation Theorem.

**Theorem** (Separation Theorem)

Let $\mathcal{X} \subset \R^n$ be a closed convex set, and $x_0 \in \R^n \setminus \mathcal{X}$. Then, there exists $w \in \R^n$ and $t \in \R$ such that
$$w^{\top} x_0 < t, \; \text{and} \; \forall x \in \mathcal{X}, w^{\top} x \geq t.$$

Note that if $\mathcal{X}$ is not closed then one can only guarantee that $w^{\top} x_0 \leq w^{\top} x, \forall x \in \mathcal{X}$ (and $w \neq 0$). This immediately implies the Supporting Hyperplane Theorem ($\partial \cX$ denotes the boundary of $\cX$, that is the closure without the interior):

**Theorem** (Supporting Hyperplane Theorem)

Let $\mathcal{X} \subset \R^n$ be a convex set, and $x_0 \in \partial \mathcal{X}$. Then, there exists $w \in \R^n, w \neq 0$ such that
$$\forall x \in \mathcal{X}, w^{\top} x \geq w^{\top} x_0.$$

We introduce now the key notion of {\em subgradients}.

**Definition** (Subgradients)

Let $\mathcal{X} \subset \R^n$, and $f : \mathcal{X} \rightarrow \R$. Then $g \in \R^n$ is a subgradient of $f$ at $x \in \mathcal{X}$ if for any $y \in \mathcal{X}$ one has
$$f(x) - f(y) \leq g^{\top} (x - y) .$$
The set of subgradients of $f$ at $x$ is denoted $\partial f (x)$.

To put it differently, for any $x \in \cX$ and $g \in \partial f(x)$, $f$ is above the linear function $y \mapsto f(x) + g^{\top} (y-x)$. The next result shows (essentially) that a convex functions always admit subgradients.

**Proposition** (Existence of subgradients)
 \label{prop:existencesubgradients}
Let $\mathcal{X} \subset \R^n$ be convex, and $f : \mathcal{X} \rightarrow \R$. If $\forall x \in \mathcal{X}, \partial f(x) \neq \emptyset$ then $f$ is convex. Conversely if $f$ is convex then for any $x \in \mathrm{int}(\mathcal{X}), \partial f(x) \neq \emptyset$. Furthermore if $f$ is convex and differentiable at $x$ then $\nabla f(x) \in \partial f(x)$. 

Before going to the proof we recall the definition of the epigraph of a function $f : \mathcal{X} \rightarrow \R$:
$$\mathrm{epi}(f) = \{(x,t) \in \mathcal{X} \times \R : t \geq f(x) \} .$$
It is obvious that a function is convex if and only if its epigraph is a convex set.

*Proof.*

The first claim is almost trivial: let $g \in \partial f((1-\gamma) x + \gamma y)$, then by definition one has
\begin{eqnarray*}
& & f((1-\gamma) x + \gamma y) \leq f(x) + \gamma g^{\top} (y - x) , \\
& & f((1-\gamma) x + \gamma y) \leq f(y) + (1-\gamma) g^{\top} (x - y) ,
\end{eqnarray*}
which clearly shows that $f$ is convex by adding the two (appropriately rescaled) inequalities.
\newline

Now let us prove that a convex function $f$ has subgradients in the interior of $\mathcal{X}$. We build a subgradient by using a supporting hyperplane to the epigraph of the function. Let $x \in \mathcal{X}$. Then clearly $(x,f(x)) \in \partial \mathrm{epi}(f)$, and $\mathrm{epi}(f)$ is a convex set. Thus by using the Supporting Hyperplane Theorem, there exists $(a,b) \in \R^n \times \R$ such that
 \label{eq:supphyp}
a^{\top} x + b f(x) \geq a^{\top} y + b t, \forall (y,t) \in \mathrm{epi}(f) .

Clearly, by letting $t$ tend to infinity, one can see that $b \leq 0$. Now let us assume that $x$ is in the interior of $\mathcal{X}$. Then for $\epsilon > 0$ small enough, $y=x + \epsilon a \in \mathcal{X}$, which implies that $b$ cannot be equal to $0$ (recall that if $b=0$ then necessarily $a \neq 0$ which allows to conclude by contradiction). Thus rewriting \eqref{eq:supphyp} for $t=f(y)$ one obtains
$$f(x) - f(y) \leq \frac{1}{|b|} a^{\top} (x - y) .$$
Thus $a / |b| \in \partial f(x)$ which concludes the proof of the second claim.
\newline

Finally let $f$ be a convex and differentiable function. Then by definition:
\begin{eqnarray*}
f(y) & \geq & \frac{f((1-\gamma) x + \gamma y) - (1- \gamma) f(x)}{\gamma} \\
& = & f(x) + \frac{f(x + \gamma (y - x)) - f(x)}{\gamma} \\
& \underset{\gamma \to 0}{\to} & f(x) + \nabla f(x)^{\top} (y-x),
\end{eqnarray*}
which shows that $\nabla f(x) \in \partial f(x)$.

In several cases of interest the set of contraints can have an empty interior, in which case the above proposition does not yield any information. However it is easy to replace $\mathrm{int}(\cX)$ by $\mathrm{ri}(\cX)$ -the relative interior of $\cX$- which is defined as the interior of $\cX$ when we view it as subset of the affine subspace it generates. Other notions of convex analysis will prove to be useful in some parts of this text. In particular the notion of {\em closed convex functions} is convenient to exclude pathological cases: these are the convex functions with closed epigraphs. Sometimes it is also useful to consider the extension of a convex function $f: \cX \rightarrow \R$ to a function from $\R^n$ to $\overline{\R}$ by setting $f(x)= + \infty$ for $x \not\in \cX$. In convex analysis one uses the term {\em proper convex function} to denote a convex function with values in $\R \cup \{+\infty\}$ such that there exists $x \in \R^n$ with $f(x) < +\infty$. **From now on all convex functions will be closed, and if necessary we consider also their proper extension.** We refer the reader to \cite{Roc70} for an extensive discussion of these notions.