---
book: Bubeck_convex_optimization
chapter: 3
chapter_title: Dimension-free convex optimization
section: 3
section_title: Conditional gradient descent, aka Frank-Wolfe
subsection: 1
subsection_title: 'An application of conditional gradient descent: Least-squares regression
  with structured sparsity'
section_id: 3.3.1
tex_label: ''
theorems: []
lean_files: []
---

\subsection*{An application of conditional gradient descent: Least-squares regression with structured sparsity}
This example is inspired by \cite{Lug10} (see also \cite{Jon92}). Consider the problem of approximating a signal $Y \in \mathbb{R}^n$ by a ``small" combination of dictionary elements $d_1, \hdots, d_N \in \mathbb{R}^n$. One way to do this is to consider a LASSO type problem in dimension $N$ of the following form (with $\lambda \in \R$ fixed)
$$\min_{x \in \mathbb{R}^N} \big\| Y - \sum_{i=1}^N x(i) d_i \big\|_2^2 + \lambda \|x\|_1 .$$
Let $D \in \mathbb{R}^{n \times N}$ be the dictionary matrix with $i^{th}$ column given by $d_i$. Instead of considering the penalized version of the problem one could look at the following constrained problem (with $s \in \R$ fixed) on which we will now focus, see e.g. \cite{FT07},

\min_{x \in \mathbb{R}^N} \| Y - D x \|_2^2 
& \qquad \Leftrightarrow \qquad & \min_{x \in \mathbb{R}^N} \| Y / s - D x \|_2^2 \label{eq:structuredsparsity} \\
\text{subject to}  \; \|x\|_1 \leq s
& & \text{subject to} \; \|x\|_1 \leq 1 . \notag

We make some assumptions on the dictionary. We are interested in situations where the size of the dictionary $N$ can be very large, potentially exponential in the ambient dimension $n$. Nonetheless we want to restrict our attention to algorithms that run in reasonable time with respect to the ambient dimension $n$, that is we want polynomial time algorithms in $n$. Of course in general this is impossible, and we need to assume that the dictionary has some structure that can be exploited. Here we make the assumption that one can do {\em linear optimization} over the dictionary in polynomial time in $n$. More precisely we assume that one can solve in time $p(n)$ (where $p$ is polynomial) the following problem for any $y \in \mathbb{R}^n$:
$$\min_{1 \leq i \leq N} y^{\top} d_i .$$
This assumption is met for many {\em combinatorial} dictionaries. For instance the dic­tio­nary ele­ments could be vec­tor of inci­dence of span­ning trees in some fixed graph, in which case the lin­ear opti­miza­tion prob­lem can be solved with a greedy algorithm.

Finally, for normalization issues, we assume that the $\ell_2$-norm of the dictionary elements are controlled by some $m>0$, that is $\|d_i\|_2 \leq m, \forall i \in [N]$.

Our problem of interest \eqref{eq:structuredsparsity} corresponds to minimizing the function $f(x) = \frac{1}{2} \| Y - D x \|^2_2$ on the $\ell_1$-ball of $\mathbb{R}^N$ in polynomial time in $n$. At first sight this task may seem completely impossible, indeed one is not even allowed to write down entirely a vector $x \in \mathbb{R}^N$ (since this would take time linear in $N$). The key property that will save us is that this function admits {\em sparse minimizers} as we discussed in the previous section, and this will be exploited by the conditional gradient descent method. 

First let us study the computational complexity of the $t^{th}$ step of conditional gradient descent. Observe that
$$\nabla f(x) = D^{\top} (D x - Y).$$
Now assume that $z_t = D x_t - Y \in \mathbb{R}^n$ is already computed, then to compute \eqref{eq:FW1} one needs to find the coordinate $i_t \in [N]$ that maximizes $|[\nabla f(x_t)](i)|$ which can be done by maximizing $d_i^{\top} z_t$ and $- d_i^{\top} z_t$. Thus \eqref{eq:FW1} takes time $O(p(n))$. Computing $x_{t+1}$ from $x_t$ and $i_{t}$ takes time $O(t)$ since $\|x_t\|_0 \leq t$, and computing $z_{t+1}$ from $z_t$ and $i_t$ takes time $O(n)$. Thus the overall time complexity of running $t$ steps is (we assume $p(n) = \Omega(n)$) 

O(t p(n) + t^2). \label{eq:structuredsparsity2}
 

To derive a rate of convergence it remains to study the smoothness of $f$. This can be done as follows:
\begin{eqnarray*}
\| \nabla f(x) - \nabla f(y) \|_{\infty} & = & \|D^{\top} D (x-y) \|_{\infty} \\
& = & \max_{1 \leq i \leq N} \bigg| d_i^{\top} \left(\sum_{j=1}^N d_j (x(j) - y(j))\right) \bigg| \\
& \leq & m^2 \|x-y\|_1 ,
\end{eqnarray*}
which means that $f$ is $m^2$-smooth with respect to the $\ell_1$-norm. Thus we get the following rate of convergence:

f(x_t) - f(x^*) \leq \frac{8 m^2}{t+1} . \label{eq:structuredsparsity3}

Putting together \eqref{eq:structuredsparsity2} and \eqref{eq:structuredsparsity3} we proved that one can get an $\epsilon$-optimal solution to \eqref{eq:structuredsparsity} with a computational effort of $O(m^2 p(n)/\epsilon + m^4/\epsilon^2)$ using the conditional gradient descent.