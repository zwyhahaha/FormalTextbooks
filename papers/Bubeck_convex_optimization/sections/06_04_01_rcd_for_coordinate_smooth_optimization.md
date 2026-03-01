---
book: Bubeck_convex_optimization
chapter: 6
chapter_title: Convex optimization and randomness
section: 4
section_title: Random coordinate descent
subsection: 1
subsection_title: RCD for coordinate-smooth optimization
section_id: 6.4.1
tex_label: ''
theorems:
- id: Theorem 6.7
  label: ''
  tex_label: th:rcdgamma
lean_files:
- id: Theorem 6.7
  path: proofs/Bubeck_convex_optimization/Theorem67.lean
  status: pending
---

\subsection{RCD for coordinate-smooth optimization}
We assume now directional smoothness for $f$, that is there exists $\beta_1, \hdots, \beta_n$ such that for any $i \in [n], x \in \R^n$ and $u \in \R$,
$$| \nabla_i f(x+u e_i) - \nabla_i f(x) | \leq \beta_i |u| .$$
If $f$ is twice differentiable then this is equivalent to $(\nabla^2 f(x))_{i,i} \leq \beta_i$. In particular, since the maximal eigenvalue of a matrix is upper bounded by its trace, one can see that the directional smoothness implies that $f$ is $\beta$-smooth with $\beta \leq \sum_{i=1}^n \beta_i$. We now study the following ``aggressive" RCD, where the step-sizes are of order of the inverse smoothness:
$$x_{s+1} = x_s - \frac{1}{\beta_{i_s}} \nabla_{i_s} f(x) e_{i_s} .$$
Furthermore we study a more general sampling distribution than uniform, precisely for $\gamma \geq 0$ we assume that $i_s$ is drawn (independently) from the distribution $p_{\gamma}$ defined by
$$p_{\gamma}(i) = \frac{\beta_i^{\gamma}}{\sum_{j=1}^n \beta_j^{\gamma}}, i \in [n] .$$
This algorithm was proposed in \cite{Nes12}, and we denote it by RCD($\gamma$). Observe that, up to a preprocessing step of complexity $O(n)$, one can sample from $p_{\gamma}$ in time $O(\log(n))$. 

The following rate of convergence is derived in \cite{Nes12}, using the dual norms $\|\cdot\|_{[\gamma]}, \|\cdot\|_{[\gamma]}^*$ defined by
$$\|x\|_{[\gamma]} = \sqrt{\sum_{i=1}^n \beta_i^{\gamma} x_i^2} , \;\; \text{and} \;\; \|x\|_{[\gamma]}^* = \sqrt{\sum_{i=1}^n \frac1{\beta_i^{\gamma}} x_i^2} .$$

**Theorem**
 \label{th:rcdgamma}
Let $f$ be convex and such that $u \in \R \mapsto f(x + u e_i)$ is $\beta_i$-smooth for any $i \in [n], x \in \R^n$. Then RCD($\gamma$) satisfies for $t \geq 2$,
$$\E f(x_{t}) - f(x^*) \leq \frac{2 R_{1 - \gamma}^2(x_1) \sum_{i=1}^n \beta_i^{\gamma}}{t-1} ,$$
where
$$R_{1-\gamma}(x_1) = \sup_{x \in \R^n : f(x) \leq f(x_1)} \|x - x^*\|_{[1-\gamma]} .$$

Recall from Theorem \ref{th:gdsmooth} that in this context the basic gradient descent attains a rate of $\beta \|x_1 - x^*\|_2^2 / t$ where $\beta \leq \sum_{i=1}^n \beta_i$ (see the discussion above). Thus we see that RCD($1$) greatly improves upon gradient descent for functions where $\beta$ is of order of $\sum_{i=1}^n \beta_i$. Indeed in this case both methods attain the same accuracy after a fixed number of iterations, but the iterations of coordinate descent are potentially much cheaper than the iterations of gradient descent. 

*Proof.*

By applying \eqref{eq:onestepofgd} to the $\beta_i$-smooth function $u \in \R \mapsto f(x + u e_i)$ one obtains
$$f\left(x - \frac{1}{\beta_i} \nabla_i f(x) e_i\right) - f(x) \leq - \frac{1}{2 \beta_i} (\nabla_i f(x))^2 .$$
We use this as follows:
\begin{eqnarray*}
\E_{i_s} f(x_{s+1}) - f(x_s)
& = & \sum_{i=1}^n p_{\gamma}(i) \left(f\left(x_s - \frac{1}{\beta_i} \nabla_i f(x_s) e_i\right) - f(x_s) \right) \\
& \leq & - \sum_{i=1}^n \frac{p_{\gamma}(i)}{2 \beta_i} (\nabla_i f(x_s))^2 \\
& = & - \frac{1}{2 \sum_{i=1}^n \beta_i^{\gamma}} \left(\|\nabla f(x_s)\|_{[1-\gamma]}^*\right)^2 .
\end{eqnarray*}
Denote $\delta_s = \E f(x_s) - f(x^*)$. Observe that the above calculation can be used to show that $f(x_{s+1}) \leq f(x_s)$ and thus one has, by definition of $R_{1-\gamma}(x_1)$,
\begin{eqnarray*} 
\delta_s & \leq & \nabla f(x_s)^{\top} (x_s - x^*) \\
& \leq & \|x_s - x^*\|_{[1-\gamma]} \|\nabla f(x_s)\|_{[1-\gamma]}^* \\
& \leq & R_{1-\gamma}(x_1) \|\nabla f(x_s)\|_{[1-\gamma]}^* .
\end{eqnarray*}
Thus putting together the above calculations one obtains
$$\delta_{s+1} \leq \delta_s - \frac{1}{2 R_{1 - \gamma}^2(x_1) \sum_{i=1}^n \beta_i^{\gamma} } \delta_s^2 .$$
The proof can be concluded with similar computations than for Theorem \ref{th:gdsmooth}.

We discussed above the specific case of $\gamma = 1$. Both $\gamma=0$ and $\gamma=1/2$ also have an interesting behavior, and we refer to \cite{Nes12} for more details. The latter paper also contains a discussion of high probability results and potential acceleration \`a la Nesterov. We also refer to \cite{RT12} for a discussion of RCD in a distributed setting.