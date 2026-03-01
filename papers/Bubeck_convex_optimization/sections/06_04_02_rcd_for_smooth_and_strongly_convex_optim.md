---
book: Bubeck_convex_optimization
chapter: 6
chapter_title: Convex optimization and randomness
section: 4
section_title: Random coordinate descent
subsection: 2
subsection_title: RCD for smooth and strongly convex optimization
section_id: 6.4.2
tex_label: ''
theorems:
- id: Theorem 6.8
  label: ''
  tex_label: th:linearratercd
- id: Lemma 6.9
  label: ''
  tex_label: lem:tittrucnes
lean_files:
- id: Theorem 6.8
  path: proofs/Bubeck_convex_optimization/Theorem68.lean
  status: pending
- id: Lemma 6.9
  path: proofs/Bubeck_convex_optimization/Lemma69.lean
  status: pending
---

\subsection{RCD for smooth and strongly convex optimization}
If in addition to directional smoothness one also assumes strong convexity, then RCD attains in fact a linear rate.

**Theorem**
 \label{th:linearratercd}
Let $\gamma \geq 0$. Let $f$ be $\alpha$-strongly convex w.r.t. $\|\cdot\|_{[1-\gamma]}$, and such that $u \in \R \mapsto f(x + u e_i)$ is $\beta_i$-smooth for any $i \in [n], x \in \R^n$. Let $\kappa_{\gamma} = \frac{\sum_{i=1}^n \beta_i^{\gamma}}{\alpha}$, then RCD($\gamma$) satisfies
$$\E f(x_{t+1}) - f(x^*) \leq \left(1 - \frac1{\kappa_{\gamma}}\right)^t (f(x_1) - f(x^*)) .$$

We use the following elementary lemma.

**Lemma**
 \label{lem:tittrucnes}
Let $f$ be $\alpha$-strongly convex w.r.t. $\| \cdot\|$ on $\R^n$, then
$$f(x) - f(x^*) \leq \frac1{2\alpha} \|\nabla f(x)\|_*^2 .$$

*Proof.*

By strong convexity, H{\"o}lder's inequality, and an elementary calculation,
\begin{eqnarray*}
f(x) - f(y) & \leq & \nabla f(x)^{\top} (x-y) - \frac{\alpha}{2} \|x-y\|_2^2 \\
& \leq & \|\nabla f(x)\|_* \|x-y\| - \frac{\alpha}{2} \|x-y\|_2^2 \\
& \leq & \frac1{2\alpha} \|\nabla f(x)\|_*^2 ,
\end{eqnarray*}
which concludes the proof by taking $y = x^*$.

We can now prove Theorem \ref{th:linearratercd}.

*Proof.*

In the proof of Theorem \ref{th:rcdgamma} we showed that 
$$\delta_{s+1} \leq \delta_s - \frac{1}{2 \sum_{i=1}^n \beta_i^{\gamma}} \left(\|\nabla f(x_s)\|_{[1-\gamma]}^*\right)^2 .$$
On the other hand Lemma \ref{lem:tittrucnes} shows that 
$$\left(\|\nabla f(x_s)\|_{[1-\gamma]}^*\right)^2 \geq 2 \alpha \delta_s .$$
The proof is concluded with straightforward calculations.