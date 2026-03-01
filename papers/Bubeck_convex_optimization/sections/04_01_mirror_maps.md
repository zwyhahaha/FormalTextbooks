---
book: Bubeck_convex_optimization
chapter: 4
chapter_title: Almost dimension-free convex optimization in non-Euclidean spaces
section: 1
section_title: Mirror maps
subsection: null
subsection_title: null
section_id: '4.1'
tex_label: sec:mm
theorems:
- id: Lemma 4.1
  label: ''
  tex_label: lem:todonow2
lean_files:
- id: Lemma 4.1
  path: proofs/Bubeck_convex_optimization/Lemma41.lean
  status: pending
---

\section{Mirror maps} \label{sec:mm}
Let $\cD \subset \R^n$ be a convex open set such that $\mathcal{X}$ is included in its closure, that is $\mathcal{X} \subset \overline{\mathcal{D}}$, and $\mathcal{X} \cap \mathcal{D} \neq \emptyset$. We say that $\Phi : \cD \rightarrow \R$ is a mirror map if it safisfies the following properties.}:

\item[(i)] $\Phi$ is strictly convex and differentiable.
\item[(ii)] The gradient of $\Phi$ takes all possible values, that is $\nabla \Phi(\cD) = \R^n$.
\item[(iii)] The gradient of $\Phi$ diverges on the boundary of $\cD$, that is 
$$\lim_{x \rightarrow \partial \mathcal{D}} \|\nabla \Phi(x)\| = + \infty .$$

In mirror descent the gradient of the mirror map $\Phi$ is used to map points from the ``primal" to the ``dual" (note that all points lie in $\R^n$ so the notions of primal and dual spaces only have an intuitive meaning). Precisely a point $x \in \mathcal{X} \cap \mathcal{D}$ is mapped to $\nabla \Phi(x)$, from which one takes a gradient step to get to $\nabla \Phi(x) - \eta \nabla f(x)$. Property (ii) then allows us to write the resulting point as $\nabla \Phi(y) = \nabla \Phi(x) - \eta \nabla f(x)$ for some $y \in \cD$. The primal point $y$ may lie outside of the set of constraints $\cX$, in which case one has to project back onto $\cX$. In mirror descent this projection is done via the Bregman divergence associated to $\Phi$. Precisely one defines
$$\Pi_{\cX}^{\Phi} (y) = \argmin_{x \in \mathcal{X} \cap \mathcal{D}} D_{\Phi}(x,y) .$$
Property (i) and (iii) ensures the existence and uniqueness of this projection (in particular since $x \mapsto D_{\Phi}(x,y)$ is locally increasing on the boundary of $\mathcal{D}$). The following lemma shows that the Bregman divergence essentially behaves as the Euclidean norm squared in terms of projections (recall Lemma \ref{lem:todonow}).

**Lemma**
 \label{lem:todonow2}
Let $x \in \cX \cap \cD$ and $y \in \cD$, then
$$(\nabla \Phi(\Pi_{\cX}^{\Phi}(y)) - \nabla \Phi(y))^{\top} (\Pi^{\Phi}_{\cX}(y) - x) \leq 0 ,$$
which also implies 
$$D_{\Phi}(x, \Pi^{\Phi}_{\cX}(y)) + D_{\Phi}(\Pi^{\Phi}_{\cX}(y), y) \leq D_{\Phi}(x,y) .$$

*Proof.*

The proof is an immediate corollary of Proposition \ref{prop:firstorder} together with the fact that $\nabla_x D_{\Phi}(x,y) = \nabla \Phi(x) - \nabla \Phi(y)$.