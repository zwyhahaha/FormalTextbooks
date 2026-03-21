---
book: Bubeck_convex_optimization
chapter: 3
chapter_title: Dimension-free convex optimization
section: 2
section_title: Gradient descent for smooth functions
subsection: 1
subsection_title: The constrained case
section_id: 3.2.1
tex_label: ''
theorems:
- id: Lemma 3.6
  label: ''
  tex_label: lem:smoothconst
- id: Theorem 3.7
  label: ''
  tex_label: th:gdsmoothconstrained
lean_files:
- id: Lemma 3.6
  path: proofs/Bubeck_convex_optimization/Lemma36.lean
  status: proved
- id: Theorem 3.7
  path: proofs/Bubeck_convex_optimization/Theorem37.lean
  status: proved

---

\subsection*{The constrained case}
We now come back to the constrained problem
\begin{align*}
& \mathrm{min.} \; f(x) \\
& \text{s.t.} \; x \in \cX .
\end{align*}
Similarly to what we did in Section \ref{sec:psgd} we consider the projected gradient descent algorithm, which iterates $x_{t+1} = \Pi_{\cX}(x_t - \eta \nabla f(x_t))$. 

The key point in the analysis of gradient descent for unconstrained smooth optimization is that a step of gradient descent started at $x$ will decrease the function value by at least $\frac{1}{2\beta} \|\nabla f(x)\|^2$, see \eqref{eq:onestepofgd}. In the constrained case we cannot expect that this would still hold true as a step may be cut short by the projection. The next lemma defines the ``right" quantity to measure progress in the constrained case.

**Lemma**
 \label{lem:smoothconst}
Let $x, y \in \cX$, $x^+ = \Pi_{\cX}\left(x - \frac{1}{\beta} \nabla f(x)\right)$, and $g_{\cX}(x) = \beta(x - x^+)$. Then the following holds true:
$$f(x^+) - f(y) \leq g_{\cX}(x)^{\top}(x-y) - \frac{1}{2 \beta} \|g_{\cX}(x)\|^2 .$$

*Proof.*

We first observe that 
 \label{eq:chap3eq1}
\nabla f(x)^{\top} (x^+ - y) \leq g_{\cX}(x)^{\top}(x^+ - y) .

Indeed the above inequality is equivalent to
$$\left(x^+- \left(x - \frac{1}{\beta} \nabla f(x) \right)\right)^{\top} (x^+ - y) \leq 0, $$
which follows from Lemma \ref{lem:todonow}. Now we use \eqref{eq:chap3eq1} as follows to prove the lemma (we also use \eqref{eq:defaltsmooth} which still holds true in the constrained case)
\begin{align*}
& f(x^+) - f(y) \\
& = f(x^+) - f(x) + f(x) - f(y) \\
& \leq \nabla f(x)^{\top} (x^+-x) + \frac{\beta}{2} \|x^+-x\|^2 + \nabla f(x)^{\top} (x-y) \\
& = \nabla f(x)^{\top} (x^+ - y) + \frac{1}{2 \beta} \|g_{\cX}(x)\|^2 \\
& \leq g_{\cX}(x)^{\top}(x^+ - y) + \frac{1}{2 \beta} \|g_{\cX}(x)\|^2 \\
& = g_{\cX}(x)^{\top}(x - y) - \frac{1}{2 \beta} \|g_{\cX}(x)\|^2 .
\end{align*}

We can now prove the following result.

**Theorem**
 \label{th:gdsmoothconstrained}
Let $f$ be convex and $\beta$-smooth on $\cX$. Then projected gradient descent with $\eta = \frac{1}{\beta}$ satisfies
$$f(x_t) - f(x^*) \leq \frac{3 \beta \|x_1 - x^*\|^2 + f(x_1) - f(x^*)}{t} .$$

*Proof.*

Lemma \ref{lem:smoothconst} immediately gives
$$f(x_{s+1}) - f(x_s) \leq - \frac{1}{2 \beta} \|g_{\cX}(x_s)\|^2 ,$$
and
$$f(x_{s+1}) - f(x^*) \leq \|g_{\cX}(x_s)\| \cdot \|x_s - x^*\| .$$
We will prove that $\|x_s - x^*\|$ is decreasing with $s$, which with the two above displays will imply
$$\delta_{s+1} \leq \delta_s  - \frac{1}{2 \beta \|x_1 - x^*\|^2} \delta_{s+1}^2.$$
An easy induction shows that
$$\delta_s \leq \frac{3 \beta \|x_1 - x^*\|^2 + f(x_1) - f(x^*)}{s}.$$
Thus it only remains to show that $\|x_s - x^*\|$ is decreasing with $s$. Using Lemma \ref{lem:smoothconst} one can see that $g_{\cX}(x_s)^{\top} (x_s - x^*) \geq \frac{1}{2 \beta} \|g_{\cX}(x_s)\|^2$ which implies
\begin{eqnarray*}
\|x_{s+1} - x^*\|^2& = & \|x_{s} - \frac{1}{\beta} g_{\cX}(x_s) - x^*\|^2 \\
& = & \|x_{s} - x^*\|^2 - \frac{2}{\beta} g_{\cX}(x_s)^{\top} (x_s - x^*) + \frac{1}{\beta^2} \|g_{\cX}(x_s)\|^2 \\
& \leq & \|x_{s} - x^*\|^2 .
\end{eqnarray*}