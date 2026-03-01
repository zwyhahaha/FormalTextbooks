---
book: Bubeck_convex_optimization
chapter: 2
chapter_title: Convex optimization in finite dimension
section: 3
section_title: Vaidya's cutting plane method
subsection: 3
subsection_title: Analysis of Vaidya's method
section_id: 2.3.3
tex_label: sec:analysis
theorems: []
lean_files: []
---

\subsection{Analysis of Vaidya's method} \label{sec:analysis}
The construction of Vaidya's method is based on a precise understanding of how the volumetric barrier changes when one adds or removes a constraint to the polytope. This understanding is derived in Section \ref{sec:constraintsvolumetric}. In particular we obtain the following two key inequalities: If case 1 happens at iteration $t$ then
 \label{eq:analysis1}
v_{t+1}(x_{t+1}) - v_t(x_t) \geq - \epsilon ,

while if case 2 happens then 
 \label{eq:analysis2}
v_{t+1}(x_{t+1}) - v_t(x_t) \geq \frac{1}{20} \sqrt{\epsilon} .

We show now how these inequalities imply that Vaidya's method stops after $O(n \log(n R/r))$ steps. First we claim that after $2t$ iterations, case 2 must have happened at least $t-1$ times. Indeed suppose that at iteration $2t-1$, case 2 has happened $t-2$ times; then $\nabla^2 F(x)$ is singular and the leverage scores are infinite, so case 2 must happen at iteration $2t$. Combining this claim with the two inequalities above we obtain:
$$v_{2t}(x_{2t}) \geq v_0(x_0) + \frac{t-1}{20} \sqrt{\epsilon} - (t+1) \epsilon \geq \frac{t}{50} \epsilon - 1 +v_0(x_0) . $$
The key point now is to recall that by definition one has $v(x) = - \log \mathrm{vol}(\cE(x,1))$ where $\cE(x,r) = \{y : \nabla F^2(x)[y-x,y-x] \leq r^2\}$ is the Dikin ellipsoid centered at $x$ and of radius $r$. Moreover the logarithmic barrier $F$ of a polytope with $m$ constraints is $m$-self-concordant, which implies that the polytope is included in the Dikin ellipsoid $\cE(z, 2m)$ where $z$ is the minimizer of $F$ (see [Theorem 4.2.6., \cite{Nes04}]). The volume of $\cE(z, 2m)$ is equal to $(2m)^n \exp(-v(z))$, which is thus always an upper bound on the volume of the polytope. Combining this with the above display we just proved that at iteration $2k$ the volume of the current polytope is at most
$$\exp \left(n \log(2m_{2t}) + 1 - v_0(x_0) - \frac{t}{50} \epsilon \right) .$$
Since $\cE(x,1)$ is always included in the polytope we have that $- v_0(x_0)$ is at most the logarithm of the volume of the initial polytope which is $O(n \log(R))$. This clearly concludes the proof as the procedure will necessarily stop when the volume is below $\exp(n \log(r))$ (we also used the trivial bound $m_t \leq n+1+t$).