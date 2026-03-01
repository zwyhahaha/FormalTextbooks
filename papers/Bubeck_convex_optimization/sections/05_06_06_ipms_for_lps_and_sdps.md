---
book: Bubeck_convex_optimization
chapter: 5
chapter_title: Beyond the black-box model
section: 6
section_title: Interior point methods
subsection: 6
subsection_title: IPMs for LPs and SDPs
section_id: 5.6.6
tex_label: ''
theorems: []
lean_files: []
---

\subsection{IPMs for LPs and SDPs}
We have seen that, roughly, the complexity of interior point methods with a $\nu$-self-concordant barrier is $O\left(M \sqrt{\nu} \log \frac{\nu}{\epsilon} \right)$, where $M$ is the complexity of computing a Newton direction (which can be done by computing and inverting the Hessian of the barrier). Thus the efficiency of the method is directly related to the {\em form} of the self-concordant barrier that one can construct for $\mathcal{X}$. It turns out that for LPs and SDPs one has particularly nice self-concordant barriers. Indeed one can show that $F(x) = - \sum_{i=1}^n \log x_i$ is an $n$-self-concordant barrier on $\R_{+}^n$, and $F(x) = - \log \mathrm{det}(X)$ is an $n$-self-concordant barrier on $\mathbb{S}_{+}^n$. See also \cite{LS13} for a recent improvement of the basic logarithmic barrier for LPs.

There is one important issue that we overlooked so far. In most interesting cases LPs and SDPs come with {\em equality constraints}, resulting in a set of constraints $\cX$ with empty interior. From a theoretical point of view there is an easy fix, which is to reparametrize the problem as to enforce the variables to live in the subspace spanned by $\cX$. This modification also has algorithmic consequences, as the evaluation of the Newton direction will now be different. In fact, rather than doing a reparametrization, one can simply search for Newton directions such that the updated point will stay in $\cX$. In other words one has now to solve a convex quadratic optimization problem under linear equality constraints. Luckily using Lagrange multipliers one can find a closed form solution to this problem, and we refer to previous references for more details.