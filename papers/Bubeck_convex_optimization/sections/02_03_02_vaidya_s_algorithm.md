---
book: Bubeck_convex_optimization
chapter: 2
chapter_title: Convex optimization in finite dimension
section: 3
section_title: Vaidya's cutting plane method
subsection: 2
subsection_title: Vaidya's algorithm
section_id: 2.3.2
tex_label: ''
theorems: []
lean_files: []
---

\subsection{Vaidya's algorithm}
We fix $\epsilon \leq 0.006$ a small constant to be specified later. Vaidya's algorithm produces a sequence of pairs $(A^{(t)}, b^{(t)}) \in \mathbb{R}^{m_t \times n} \times \mathbb{R}^{m_t}$ such that the corresponding polytope contains the convex set of interest. The initial polytope defined by $(A^{(0)},b^{(0)})$ is a simplex (in particular $m_0=n+1$). For $t\geq0$ we let $x_t$ be the minimizer of the volumetric barrier $v_t$ of the polytope given by $(A^{(t)}, b^{(t)})$, and $(\sigma_i^{(t)})_{i \in [m_t]}$ the leverage scores (associated to $v_t$) at the point $x_t$. We also denote $F_t$ for the logarithmic barrier given by $(A^{(t)}, b^{(t)})$. The next polytope $(A^{(t+1)}, b^{(t+1)})$ is defined by either adding or removing a constraint to the current polytope:

\item If for some $i \in [m_t]$ one has $\sigma_i^{(t)} = \min_{j \in [m_t]} \sigma_j^{(t)} < \epsilon$, then $(A^{(t+1)}, b^{(t+1)})$ is defined by removing the $i^{th}$ row in $(A^{(t)}, b^{(t)})$ (in particular $m_{t+1} = m_t - 1$).
\item Otherwise let $c^{(t)}$ be the vector given by the separation oracle queried at $x_t$, and $\beta^{(t)} \in \mathbb{R}$ be chosen so that 
$$\frac{(\nabla^2 F_t(x_t) )^{-1}[c^{(t)}, c^{(t)}]}{(x_t^{\top} c^{(t)} - \beta^{(t)})^2} = \frac{1}{5} \sqrt{\epsilon} .$$
Then we define $(A^{(t+1)}, b^{(t+1)})$ by adding to $(A^{(t)}, b^{(t)})$ the row given by $(c^{(t)}, \beta^{(t)})$ (in particular $m_{t+1} = m_t + 1$).

It can be shown that the volumetric barrier is a self-concordant barrier, and thus it can be efficiently minimized with Newton's method. In fact it is enough to do {\em one step} of Newton's method on $v_t$ initialized at $x_{t-1}$, see \cite{Vai89, Vai96} for more details on this.