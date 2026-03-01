---
book: Bubeck_convex_optimization
chapter: 6
chapter_title: Convex optimization and randomness
section: 6
section_title: Convex relaxation and randomized rounding
subsection: null
subsection_title: null
section_id: '6.6'
tex_label: sec:convexrelaxation
theorems:
- id: Theorem 6.11
  label: ''
  tex_label: th:GW
- id: Lemma 6.12
  label: ''
  tex_label: lem:GW
- id: Theorem 6.13
  label: ''
  tex_label: ''
lean_files:
- id: Theorem 6.11
  path: proofs/Bubeck_convex_optimization/Theorem611.lean
  status: pending
- id: Lemma 6.12
  path: proofs/Bubeck_convex_optimization/Lemma612.lean
  status: pending
- id: Theorem 6.13
  path: proofs/Bubeck_convex_optimization/Theorem613.lean
  status: pending
---

\section{Convex relaxation and randomized rounding} \label{sec:convexrelaxation}

In this section we briefly discuss the concept of convex relaxation, and the use of randomization to find approximate solutions. By now there is an enormous literature on these topics, and we refer to \cite{Bar14} for further pointers. 

We study here the seminal example of $\mathrm{MAXCUT}$. This problem can be described as follows. Let $A \in \R_+^{n \times n}$ be a symmetric matrix of non-negative weights. The entry $A_{i,j}$ is interpreted as a measure of the ``dissimilarity" between point $i$ and point $j$. The goal is to find a partition of $[n]$ into two sets, $S \subset [n]$ and $S^c$, so as to maximize the total dissimilarity between the two groups: $\sum_{i \in S, j \in S^c} A_{i,j}$. Equivalently $\mathrm{MAXCUT}$ corresponds to the following optimization problem:
 \label{eq:maxcut1}
\max_{x \in \{-1,1\}^n} \frac12 \sum_{i,j =1}^n A_{i,j} (x_i - x_j)^2 .

Viewing $A$ as the (weighted) adjacency matrix of a graph, one can rewrite \eqref{eq:maxcut1} as follows, using the graph Laplacian $L=D-A$ where $D$ is the diagonal matrix with entries $(\sum_{j=1}^n A_{i,j})_{i \in [n]}$,
 \label{eq:maxcut2}
\max_{x \in \{-1,1\}^n} x^{\top} L x .

It turns out that this optimization problem is $**NP**$-hard, that is the existence of a polynomial time algorithm to solve \eqref{eq:maxcut2} would prove that $**P** = **NP**$. The combinatorial difficulty of this problem stems from the hypercube constraint. Indeed if one replaces $\{-1,1\}^n$ by the Euclidean sphere, then one obtains an efficiently solvable problem (it is the problem of computing the maximal eigenvalue of $L$).

We show now that, while \eqref{eq:maxcut2} is a difficult optimization problem, it is in fact possible to find relatively good {\em approximate} solutions by using the power of randomization. 
Let $\zeta$ be uniformly drawn on the hypercube $\{-1,1\}^n$, then clearly
$$\E \ \zeta^{\top} L \zeta = \sum_{i,j=1, i \neq j}^n A_{i,j} \geq \frac{1}{2} \max_{x \in \{-1,1\}^n} x^{\top} L x .$$
This means that, on average, $\zeta$ is a $1/2$-approximate solution to \eqref{eq:maxcut2}. Furthermore it is immediate that the above expectation bound implies that, with probability at least $\epsilon$, $\zeta$ is a $(1/2-\epsilon)$-approximate solution. Thus by repeatedly sampling uniformly from the hypercube one can get arbitrarily close (with probability approaching $1$) to a $1/2$-approximation of $\mathrm{MAXCUT}$.

Next we show that one can obtain an even better approximation ratio by combining the power of convex optimization and randomization. This approach was pioneered by \cite{GW95}. The Goemans-Williamson algorithm is based on the following inequality
$$\max_{x \in \{-1,1\}^n} x^{\top} L x = \max_{x \in \{-1,1\}^n} \langle L, xx^{\top} \rangle \leq \max_{X \in \mathbb{S}_+^n, X_{i,i}=1, i \in [n]} \langle L, X \rangle .$$ 
The right hand side in the above display is known as the {\em convex (or SDP) relaxation} of $\mathrm{MAXCUT}$. The convex relaxation is an SDP and thus one can find its solution efficiently with Interior Point Methods (see Section \ref{sec:IPM}). The following result states both the Goemans-Williamson strategy and the corresponding approximation ratio.

**Theorem**
 \label{th:GW}
Let $\Sigma$ be the solution to the SDP relaxation of $\mathrm{MAXCUT}$. Let $\xi \sim \cN(0, \Sigma)$ and $\zeta = \mathrm{sign}(\xi) \in \{-1,1\}^n$. Then
$$\E \ \zeta^{\top} L \zeta \geq 0.878 \max_{x \in \{-1,1\}^n} x^{\top} L x .$$

The proof of this result is based on the following elementary geometric lemma.

**Lemma**
 \label{lem:GW}
Let $\xi \sim \mathcal{N}(0,\Sigma)$ with $\Sigma_{i,i}=1$ for $i \in [n]$, and $\zeta = \mathrm{sign}(\xi)$. Then
$$\E \ \zeta_i \zeta_j = \frac{2}{\pi} \mathrm{arcsin} \left(\Sigma_{i,j}\right) .$$

*Proof.*

Let $V \in \R^{n \times n}$ (with $i^{th}$ row $V_i^{\top}$) be such that $\Sigma = V V^{\top}$. Note that since $\Sigma_{i,i}=1$ one has $\|V_i\|_2 = 1$ (remark also that necessarily $|\Sigma_{i,j}| \leq 1$, which will be important in the proof of Theorem \ref{th:GW}). Let $\epsilon \sim \mathcal{N}(0,\mI_n)$ be such that $\xi = V \epsilon$. Then $\zeta_i = \mathrm{sign}(V_i^{\top} \epsilon)$, and in particular
\begin{eqnarray*}
\E \ \zeta_i \zeta_j & = & \P(V_i^{\top} \epsilon \geq 0 \ \text{and} \ V_j^{\top} \epsilon \geq 0) + \P(V_i^{\top} \epsilon \leq 0 \ \text{and} \ V_j^{\top} \epsilon \leq 0 \\
& & - \P(V_i^{\top} \epsilon \geq 0 \ \text{and} \ V_j^{\top} \epsilon < 0) - \P(V_i^{\top} \epsilon < 0 \ \text{and} \ V_j^{\top} \epsilon \geq 0) \\
& = & 2 \P(V_i^{\top} \epsilon \geq 0 \ \text{and} \ V_j^{\top} \epsilon \geq 0) - 2 \P(V_i^{\top} \epsilon \geq 0 \ \text{and} \ V_j^{\top} \epsilon < 0) \\
& = & \P(V_j^{\top} \epsilon \geq 0 | V_i^{\top} \epsilon \geq 0) - \P(V_j^{\top} \epsilon < 0 | V_i^{\top} \epsilon \geq 0) \\
& = & 1 - 2 \P(V_j^{\top} \epsilon < 0 | V_i^{\top} \epsilon \geq 0).
\end{eqnarray*}
Now a quick picture shows that $\P(V_j^{\top} \epsilon < 0 | V_i^{\top} \epsilon \geq 0) = \frac{1}{\pi} \mathrm{arccos}(V_i^{\top} V_j)$ (recall that $\epsilon / \|\epsilon\|_2$ is uniform on the Euclidean sphere). Using the fact that $V_i^{\top} V_j = \Sigma_{i,j}$ and $\mathrm{arccos}(x) = \frac{\pi}{2} - \mathrm{arcsin}(x)$ conclude the proof.

We can now get to the proof of Theorem \ref{th:GW}.

*Proof.*

We shall use the following inequality:
 \label{eq:dependsonL}
1 - \frac{2}{\pi} \mathrm{arcsin}(t) \geq 0.878 (1-t), \ \forall t \in [-1,1] .

Also remark that for $X \in \R^{n \times n}$ such that $X_{i,i}=1$, one has
$$\langle L, X \rangle = \sum_{i,j=1}^n A_{i,j} (1 - X_{i,j}) ,$$
and in particular for $x \in \{-1,1\}^n$, $x^{\top} L x = \sum_{i,j=1}^n A_{i,j} (1 - x_i x_j)$.

Thus, using Lemma \ref{lem:GW}, and the facts that $A_{i,j} \geq 0$ and $|\Sigma_{i,j}| \leq 1$ (see the proof of Lemma \ref{lem:GW}), one has
\begin{eqnarray*}
\E \ \zeta^{\top} L \zeta
& = & \sum_{i,j=1}^n A_{i,j} \left(1- \frac{2}{\pi} \mathrm{arcsin} \left(\Sigma_{i,j}\right)\right)  \\
& \geq & 0.878 \sum_{i,j=1}^n A_{i,j} \left(1- \Sigma_{i,j}\right) \\
& = & 0.878 \ \max_{X \in \mathbb{S}_+^n, X_{i,i}=1, i \in [n]} \langle L, X \rangle \\
& \geq & 0.878 \max_{x \in \{-1,1\}^n} x^{\top} L x .
\end{eqnarray*}

Theorem \ref{th:GW} depends on the form of the Laplacian $L$ (insofar as \eqref{eq:dependsonL} was used). We show next a result from \cite{Nes97} that applies to any positive semi-definite matrix, at the expense of the constant of approximation. Precisely we are now interested in the following optimization problem:
 \label{eq:quad}
\max_{x \in \{-1,1\}^n} x^{\top} B x .

The corresponding SDP relaxation is
$$\max_{X \in \mathbb{S}_+^n, X_{i,i}=1, i \in [n]} \langle B, X \rangle .$$

**Theorem**

Let $\Sigma$ be the solution to the SDP relaxation of \eqref{eq:quad}. Let $\xi \sim \cN(0, \Sigma)$ and $\zeta = \mathrm{sign}(\xi) \in \{-1,1\}^n$. Then
$$\E \ \zeta^{\top} B \zeta \geq \frac{2}{\pi} \max_{x \in \{-1,1\}^n} x^{\top} B x .$$

*Proof.*

Lemma \ref{lem:GW} shows that
$$\E \ \zeta^{\top} B \zeta = \sum_{i,j=1}^n B_{i,j} \frac{2}{\pi} \mathrm{arcsin} \left(X_{i,j}\right) = \frac{2}{\pi} \langle B, \mathrm{arcsin}(X) \rangle .$$
Thus to prove the result it is enough to show that $\langle B, \mathrm{arcsin}(\Sigma) \rangle \geq \langle B, \Sigma \rangle$, which is itself implied by $\mathrm{arcsin}(\Sigma) \succeq \Sigma$ (the implication is true since $B$ is positive semi-definite, just write the eigendecomposition). Now we prove the latter inequality via a Taylor expansion. Indeed recall that $|\Sigma_{i,j}| \leq 1$ and thus denoting by $A^{\circ \alpha}$ the matrix where the entries are raised to the power $\alpha$ one has
$$\mathrm{arcsin}(\Sigma) = \sum_{k=0}^{+\infty} \frac{{2k \choose k}}{4^k (2k +1)} \Sigma^{\circ (2k+1)} = \Sigma + \sum_{k=1}^{+\infty} \frac{{2k \choose k}}{4^k (2k +1)} \Sigma^{\circ (2k+1)}.$$
Finally one can conclude using the fact if $A,B \succeq 0$ then $A \circ B \succeq 0$. This can be seen by writing $A= V V^{\top}$, $B=U U^{\top}$, and thus 
$$(A \circ B)_{i,j} = V_i^{\top} V_j U_i^{\top} U_j = \mathrm{Tr}(U_j V_j^{\top} V_i U_i^{\top}) = \langle V_i U_i^{\top}, V_j U_j^{\top} \rangle .$$ In other words $A \circ B$ is a Gram-matrix and, thus it is positive semi-definite.