---
book: Bubeck_convex_optimization
chapter: 3
chapter_title: Dimension-free convex optimization
section: 4
section_title: Strong convexity
subsection: null
subsection_title: null
section_id: '3.4'
tex_label: ''
theorems: []
lean_files: []
---

\section{Strong convexity}
We will now discuss another property of convex functions that can significantly speed-up the convergence of first order methods: strong convexity. We say that $f: \cX \rightarrow \mathbb{R}$ is $\alpha$-{\em strongly convex} if it satisfies the following improved subgradient inequality:
 \label{eq:defstrongconv}
f(x) - f(y) \leq \nabla f(x)^{\top} (x - y) - \frac{\alpha}{2} \|x - y \|^2 .

Of course this definition does not require differentiability of the function $f$, and one can replace $\nabla f(x)$ in the inequality above by $g \in \partial f(x)$. It is immediate to verify that a function $f$ is $\alpha$-strongly convex if and only if $x \mapsto f(x) - \frac{\alpha}{2} \|x\|^2$ is convex (in particular if $f$ is twice differentiable then the eigenvalues of the Hessians of $f$ have to be larger than $\alpha$). The strong convexity parameter $\alpha$ is a measure of the {\em curvature} of $f$. For instance a linear function has no curvature and hence $\alpha = 0$. On the other hand one can clearly see why a large value of $\alpha$ would lead to a faster rate: in this case a point far from the optimum will have a large gradient, and thus gradient descent will make very big steps when far from the optimum. Of course if the function is non-smooth one still has to be careful and tune the step-sizes to be relatively small, but nonetheless we will be able to improve the oracle complexity from $O(1/\epsilon^2)$ to $O(1/(\alpha \epsilon))$. On the other hand with the additional assumption of $\beta$-smoothness we will prove that gradient descent with a constant step-size achieves a {\em linear rate of convergence}, precisely the oracle complexity will be $O(\frac{\beta}{\alpha} \log(1/\epsilon))$. This achieves the objective we had set after Theorem \ref{th:pgd}: strongly-convex and smooth functions can be optimized in very large dimension and up to very high accuracy.

Before going into the proofs let us discuss another interpretation of strong-convexity and its relation to smoothness. Equation \eqref{eq:defstrongconv} can be read as follows: at any point $x$ one can find a (convex) quadratic lower bound $q_x^-(y) = f(x) + \nabla f(x)^{\top} (y - x) + \frac{\alpha}{2} \|x - y \|^2$ to the function $f$, i.e. $q_x^-(y) \leq f(y), \forall y \in \cX$ (and $q_x^-(x) = f(x)$). On the other hand for $\beta$-smoothness \eqref{eq:defaltsmooth}

implies that at any point $y$ one can find a (convex) quadratic upper bound $q_y^+(x) = f(y) + \nabla f(y)^{\top} (x - y) + \frac{\beta}{2} \|x - y \|^2$ to the function $f$, i.e. $q_y^+(x) \geq f(x), \forall x \in \cX$ (and $q_y^+(y) = f(y)$). 
Thus in some sense strong convexity is a {\em dual} assumption to smoothness, and in fact this can be made precise within the framework of Fenchel duality. Also remark that clearly one always has $\beta \geq \alpha$.