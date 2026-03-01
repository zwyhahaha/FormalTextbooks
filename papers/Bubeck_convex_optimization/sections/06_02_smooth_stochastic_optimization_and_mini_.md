---
book: Bubeck_convex_optimization
chapter: 6
chapter_title: Convex optimization and randomness
section: 2
section_title: Smooth stochastic optimization and mini-batch SGD
subsection: null
subsection_title: null
section_id: '6.2'
tex_label: ''
theorems:
- id: Theorem 6.3
  label: ''
  tex_label: th:SMDsmooth
lean_files:
- id: Theorem 6.3
  path: proofs/Bubeck_convex_optimization/Theorem63.lean
  status: pending
---

\section{Smooth stochastic optimization and mini-batch SGD}
In the previous section we showed that, for non-smooth optimization, there is basically no cost for having a stochastic oracle instead of an exact oracle. Unfortunately one can show (see e.g. \cite{Tsy03}) that smoothness does not bring any acceleration for a general stochastic oracle that acceleration can be obtained for the square loss and the logistic loss.}. This is in sharp contrast with the exact oracle case where we showed that gradient descent attains a $1/t$ rate (instead of $1/\sqrt{t}$ for non-smooth), and this could even be improved to $1/t^2$ thanks to Nesterov's accelerated gradient descent. 

The next result interpolates between the $1/\sqrt{t}$ for stochastic smooth optimization, and the $1/t$ for deterministic smooth optimization. We will use it to propose a useful modification of SGD in the smooth case. The proof is extracted from \cite{DGBSX12}.

**Theorem**
 \label{th:SMDsmooth}
Let $\Phi$ be a mirror map $1$-strongly convex on $\mathcal{X} \cap \mathcal{D}$ w.r.t. $\|\cdot\|$, and let $R^2 = \sup_{x \in \mathcal{X} \cap \mathcal{D}} \Phi(x) - \Phi(x_1)$. Let $f$ be convex and $\beta$-smooth w.r.t. $\|\cdot\|$. Furthermore assume that the stochastic oracle is such that $\E \|\nabla f(x) - \tg(x)\|_*^2 \leq \sigma^2$. Then S-MD with stepsize $\frac{1}{\beta + 1/\eta}$ and $\eta = \frac{R}{\sigma} \sqrt{\frac{2}{t}}$ satisfies
$$\E f\bigg(\frac{1}{t} \sum_{s=1}^t x_{s+1} \bigg) - f(x^*) \leq R \sigma \sqrt{\frac{2}{t}} + \frac{\beta R^2}{t} .$$

*Proof.*

Using $\beta$-smoothness, Cauchy-Schwarz (with $2 ab \leq x a^2+ b^2 / x$ for any $x >0$), and the 1-strong convexity of $\Phi$, one obtains
\begin{align*}
& f(x_{s+1}) - f(x_s) \\
& \leq \nabla f(x_s)^{\top} (x_{s+1} - x_s) + \frac{\beta}{2} \|x_{s+1} - x_s\|^2 \\
& = \tg_s^{\top} (x_{s+1} - x_s) + (\nabla f(x_s) - \tg_s)^{\top} (x_{s+1} - x_s) + \frac{\beta}{2} \|x_{s+1} - x_s\|^2 \\
& \leq \tg_s^{\top} (x_{s+1} - x_s) + \frac{\eta}{2} \|\nabla f(x_s) - \tg_s\|_*^2 + \frac12 (\beta + 1/\eta) \|x_{s+1} - x_s\|^2 \\
& \leq \tg_s^{\top} (x_{s+1} - x_s) + \frac{\eta}{2} \|\nabla f(x_s) - \tg_s\|_*^2 + (\beta + 1/\eta) D_{\Phi}(x_{s+1}, x_s) .
\end{align*}
Observe that, using the same argument as to derive \eqref{eq:pourplustard1}, one has
$$\frac{1}{\beta + 1/\eta} \tg_s^{\top} (x_{s+1} - x^*) \leq D_{\Phi} (x^*, x_s) - D_{\Phi}(x^*, x_{s+1}) - D_{\Phi}(x_{s+1}, x_s) .$$
Thus
\begin{align*}
& f(x_{s+1}) \\
 & \leq f(x_s) + \tg_s^{\top}(x^* - x_s) + (\beta + 1/\eta) \left(D_{\Phi} (x^*, x_s) - D_{\Phi}(x^*, x_{s+1})\right) \\
& \qquad + \frac{\eta}{2} \|\nabla f(x_s) - \tg_s\|_*^2 \\
& \leq f(x^*) + (\tg_s-\nabla f(x_s))^{\top}(x^* - x_s) \\
& \qquad + (\beta + 1/\eta) \left(D_{\Phi} (x^*, x_s) - D_{\Phi}(x^*, x_{s+1})\right) + \frac{\eta}{2} \|\nabla f(x_s) - \tg_s\|_*^2 .
\end{align*}
In particular this yields
$$\E f(x_{s+1}) - f(x^*) \leq (\beta + 1/\eta) \E \left(D_{\Phi} (x^*, x_s) - D_{\Phi}(x^*, x_{s+1})\right) + \frac{\eta \sigma^2}{2} .$$
By summing this inequality from $s=1$ to $s=t$ one can easily conclude with the standard argument.

We can now propose the following modification of SGD based on the idea of {\em mini-batches}. Let $m \in \N$, then mini-batch SGD iterates the following equation:
$$x_{t+1} = \Pi_{\cX}\left(x_t - \frac{\eta}{m} \sum_{i=1}^m \tg_i(x_t)\right).$$
where $\tg_i(x_t), i=1,\hdots,m$ are independent random variables (conditionally on $x_t$) obtained from repeated queries to the stochastic oracle. Assuming that $f$ is $\beta$-smooth and that the stochastic oracle is such that $\|\tg(x)\|_2 \leq B$, one can obtain a rate of convergence for mini-batch SGD with Theorem \ref{th:SMDsmooth}. Indeed one can apply this result with the modified stochastic oracle that returns $\frac{1}{m} \sum_{i=1}^m \tg_i(x)$, it satisfies
$$\E \| \frac1{m} \sum_{i=1}^m \tg_i(x) - \nabla f(x) \|_2^2 = \frac{1}{m}\E \| \tg_1(x) - \nabla f(x) \|_2^2 \leq \frac{2 B^2}{m} .$$
Thus one obtains that with $t$ calls to the (original) stochastic oracle, that is $t/m$ iterations of the mini-batch SGD, one has a suboptimality gap bounded by
$$R \sqrt{\frac{2 B^2}{m}} \sqrt{\frac{2}{t/m}} + \frac{\beta R^2}{t/m} = 2 \frac{R B}{\sqrt{t}} + \frac{m \beta R^2}{t} .$$
Thus as long as $m \leq \frac{B}{R \beta} \sqrt{t}$ one obtains, with mini-batch SGD and $t$ calls to the oracle, a point which is $3\frac{R B}{\sqrt{t}}$-optimal.

Mini-batch SGD can be a better option than basic SGD in at least two situations: (i) When the computation for an iteration of mini-batch SGD can be distributed between multiple processors. Indeed a central unit can send the message to the processors that estimates of the gradient at point $x_s$ have to be computed, then each processor can work independently and send back the estimate they obtained. (ii) Even in a serial setting mini-batch SGD can sometimes be advantageous, in particular if some calculations can be re-used to compute several estimated gradients at the same point.