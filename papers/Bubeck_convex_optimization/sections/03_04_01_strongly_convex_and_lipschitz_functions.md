---
book: Bubeck_convex_optimization
chapter: 3
chapter_title: Dimension-free convex optimization
section: 4
section_title: Strong convexity
subsection: 1
subsection_title: Strongly convex and Lipschitz functions
section_id: 3.4.1
tex_label: ''
theorems:
- id: Theorem 3.9
  label: ''
  tex_label: th:LJSB12
lean_files:
- id: Theorem 3.9
  path: proofs/Bubeck_convex_optimization/Theorem39.lean
  status: pending
---

\subsection{Strongly convex and Lipschitz functions}

We consider here the projected subgradient descent algorithm with time-varying step size $(\eta_t)_{t \geq 1}$, that is
\begin{align*}
& y_{t+1} = x_t - \eta_t g_t , \ \text{where} \ g_t \in \partial f(x_t) \\
& x_{t+1} = \Pi_{\cX}(y_{t+1}) .
\end{align*}
The following result is extracted from \cite{LJSB12}.

**Theorem**
 \label{th:LJSB12}
Let $f$ be $\alpha$-strongly convex and $L$-Lipschitz on $\cX$. Then projected subgradient descent with $\eta_s = \frac{2}{\alpha (s+1)}$ satisfies
$$f \left(\sum_{s=1}^t \frac{2 s}{t(t+1)} x_s \right) - f(x^*) \leq \frac{2 L^2}{\alpha (t+1)} .$$

*Proof.*

Coming back to our original analysis of projected subgradient descent in Section \ref{sec:psgd} and using the strong convexity assumption one immediately obtains
$$f(x_s) - f(x^*) \leq \frac{\eta_s}{2} L^2 + \left( \frac{1}{2 \eta_s} - \frac{\alpha}{2} \right) \|x_s - x^*\|^2 - \frac{1}{2 \eta_s} \|x_{s+1} - x^*\|^2 .$$
Multiplying this inequality by $s$ yields
$$s( f(x_s) - f(x^*) ) \leq \frac{L^2}{\alpha} + \frac{\alpha}{4} \bigg( s(s-1) \|x_s - x^*\|^2 - s (s+1) \|x_{s+1} - x^*\|^2 \bigg),$$
Now sum the resulting inequality over $s=1$ to $s=t$, and apply Jensen's inequality to obtain the claimed statement.