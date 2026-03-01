---
book: Bubeck_convex_optimization
chapter: 6
chapter_title: Convex optimization and randomness
section: 3
section_title: Sum of smooth and strongly convex functions
subsection: null
subsection_title: null
section_id: '6.3'
tex_label: ''
theorems:
- id: Lemma 6.4
  label: ''
  tex_label: lem:SVRG
- id: Theorem 6.5
  label: ''
  tex_label: th:SVRG
lean_files:
- id: Lemma 6.4
  path: proofs/Bubeck_convex_optimization/Lemma64.lean
  status: pending
- id: Theorem 6.5
  path: proofs/Bubeck_convex_optimization/Theorem65.lean
  status: pending
---

\section{Sum of smooth and strongly convex functions}
Let us examine in more details the main example from Section \ref{sec:mlapps}. That is one is interested in the unconstrained minimization of 
$$f(x) = \frac1{m} \sum_{i=1}^m f_i(x) ,$$
where $f_1, \hdots, f_m$ are $\beta$-smooth and convex functions, and $f$ is $\alpha$-strongly convex. Typically in machine learning $\alpha$ can be as small as $1/m$, while $\beta$ is of order of a constant. In other words the condition number $\kappa= \beta / \alpha$ can be as large as $\Omega(m)$. Let us now compare the basic gradient descent, that is
$$x_{t+1} = x_t - \frac{\eta}{m} \sum_{i=1}^m \nabla f_i(x) ,$$
to SGD
$$x_{t+1} = x_t - \eta \nabla f_{i_t}(x) ,$$
where $i_t$ is drawn uniformly at random in $[m]$ (independently of everything else). Theorem \ref{th:gdssc} shows that gradient descent requires $O(m \kappa \log(1/\epsilon))$ gradient computations (which can be improved to $O(m \sqrt{\kappa} \log(1/\epsilon))$ with Nesterov's accelerated gradient descent), while Theorem \ref{th:sgdstrong} shows that SGD (with appropriate averaging) requires $O(1/ (\alpha \epsilon))$ gradient computations. Thus one can obtain a low accuracy solution reasonably fast with SGD, but for high accuracy the basic gradient descent is more suitable. Can we get the best of both worlds? This question was answered positively in \cite{LRSB12} with SAG (Stochastic Averaged Gradient) and in \cite{SSZ13} with SDCA (Stochastic Dual Coordinate Ascent). These methods require only $O((m+\kappa) \log(1/\epsilon))$ gradient computations. We describe below the SVRG (Stochastic Variance Reduced Gradient descent) algorithm from \cite{JZ13} which makes the main ideas of SAG and SDCA more transparent (see also \cite{DBLJ14} for more on the relation between these different methods). We also observe that a natural question is whether one can obtain a Nesterov's accelerated version of these algorithms that would need only $O((m + \sqrt{m \kappa}) \log(1/\epsilon))$, see \cite{SSZ13b, ZX14, AB14} for recent works on this question.

To obtain a linear rate of convergence one needs to make ``big steps", that is the step-size should be of order of a constant. In SGD the step-size is typically of order $1/\sqrt{t}$ because of the variance introduced by the stochastic oracle. The idea of SVRG is to ``center" the output of the stochastic oracle in order to reduce the variance. Precisely instead of feeding $\nabla f_{i}(x)$ into the gradient descent one would use $\nabla f_i(x) - \nabla f_i(y) + \nabla f(y)$ where $y$ is a centering sequence. This is a sensible idea since, when $x$ and $y$ are close to the optimum, one should have that $\nabla f_i(x) - \nabla f_i(y)$ will have a small variance, and of course $\nabla f(y)$ will also be small (note that $\nabla f_i(x)$ by itself is not necessarily small). This intuition is made formal with the following lemma.

**Lemma**
 \label{lem:SVRG}
Let $f_1, \hdots f_m$ be $\beta$-smooth convex functions on $\R^n$, and $i$ be a random variable uniformly distributed in $[m]$. Then
$$\E \| \nabla f_i(x) - \nabla f_i(x^*) \|_2^2 \leq 2 \beta (f(x) - f(x^*)) .$$

*Proof.*

Let $g_i(x) = f_i(x) - f_i(x^*) - \nabla f_i(x^*)^{\top} (x - x^*)$. By convexity of $f_i$ one has $g_i(x) \geq 0$ for any $x$ and in particular using \eqref{eq:onestepofgd} this yields $- g_i(x) \leq - \frac{1}{2\beta} \|\nabla g_i(x)\|_2^2$ which can be equivalently written as
$$\| \nabla f_i(x) - \nabla f_i(x^*) \|_2^2 \leq 2 \beta (f_i(x) - f_i(x^*) - \nabla f_i(x^*)^{\top} (x - x^*)) .$$
Taking expectation with respect to $i$ and observing that $\E \nabla f_i(x^*) = \nabla f(x^*) = 0$ yields the claimed bound.

On the other hand the computation of $\nabla f(y)$ is expensive (it requires $m$ gradient computations), and thus the centering sequence should be updated more rarely than the main sequence. These ideas lead to the following epoch-based algorithm.

Let $y^{(1)} \in \R^n$ be an arbitrary initial point. For $s=1, 2 \ldots$, let $x_1^{(s)}=y^{(s)}$. For $t=1, \hdots, k$ let 
$$x_{t+1}^{(s)} = x_t^{(s)} - \eta \left( \nabla f_{i_t^{(s)}}(x_t^{(s)}) - \nabla f_{i_t^{(s)}} (y^{(s)}) + \nabla f(y^{(s)}) \right) ,$$
where $i_t^{(s)}$ is drawn uniformly at random (and independently of everything else) in $[m]$. Also let
$$y^{(s+1)} = \frac1{k} \sum_{t=1}^k x_t^{(s)} .$$

**Theorem**
 \label{th:SVRG}
Let $f_1, \hdots f_m$ be $\beta$-smooth convex functions on $\R^n$ and $f$ be $\alpha$-strongly convex. Then SVRG with $\eta = \frac{1}{10\beta}$ and $k = 20 \kappa$ satisfies
$$\E f(y^{(s+1)}) - f(x^*) \leq 0.9^s (f(y^{(1)}) - f(x^*)) .$$

*Proof.*

We fix a phase $s \geq 1$ and we denote by $\E$ the expectation taken with respect to $i_1^{(s)}, \hdots, i_k^{(s)}$. We show below that
$$\E f(y^{(s+1)}) - f(x^*) =  \E f\left(\frac1{k} \sum_{t=1}^k x_t^{(s)}\right) - f(x^*)  \leq 0.9 (f(y^{(s)}) - f(x^*)) ,$$
which clearly implies the theorem. To simplify the notation in the following we drop the dependency on $s$, that is we want to show that
 \label{eq:SVRG0}
\E f\left(\frac1{k} \sum_{t=1}^k x_t\right) - f(x^*)  \leq 0.9 (f(y) - f(x^*)) .

We start as for the proof of Theorem \ref{th:gdssc} (analysis of gradient descent for smooth and strongly convex functions) with
 \label{eq:SVRG1}
\|x_{t+1} - x^*\|_2^2 = \|x_t - x^*\|_2^2 - 2 \eta v_t^{\top}(x_t - x^*) + \eta^2 \|v_t\|_2^2 ,

where
$$v_t = \nabla f_{i_t}(x_t) - \nabla f_{i_t} (y) + \nabla f(y) .$$
Using Lemma \ref{lem:SVRG}, we upper bound $\E_{i_t} \|v_t\|_2^2$ as follows (also recall that $\E\|X-\E(X)\|_2^2 \leq \E\|X\|_2^2$, and $\E_{i_t} \nabla f_{i_t}(x^*) = 0$):

& \E_{i_t} \|v_t\|_2^2 \notag \\
& \leq 2 \E_{i_t} \|\nabla f_{i_t}(x_t) - \nabla f_{i_t}(x^*) \|_2^2 + 2 \E_{i_t} \|\nabla f_{i_t}(y) - \nabla f_{i_t}(x^*) - \nabla f(y) \|_2^2 \notag \\
& \leq 2 \E_{i_t} \|\nabla f_{i_t}(x_t) - \nabla f_{i_t}(x^*) \|_2^2 + 2 \E_{i_t} \|\nabla f_{i_t}(y) - \nabla f_{i_t}(x^*) \|_2^2 \notag \\
& \leq 4 \beta (f(x_t) - f(x^*) + f(y) - f(x^*)) . \label{eq:SVRG2}

Also observe that
$$\E_{i_t} v_t^{\top}(x_t - x^*) = \nabla f(x_t)^{\top} (x_t - x^*) \geq f(x_t) - f(x^*) ,$$
and thus plugging this into \eqref{eq:SVRG1} together with \eqref{eq:SVRG2} one obtains
\begin{eqnarray*}
\E_{i_t} \|x_{t+1} - x^*\|_2^2 & \leq & \|x_t - x^*\|_2^2 - 2 \eta (1 - 2 \beta \eta) (f(x_t) - f(x^*)) \\
& & + 4 \beta \eta^2 (f(y) - f(x^*)) .
\end{eqnarray*}
Summing the above inequality over $t=1, \hdots, k$ yields
\begin{eqnarray*} 
\E \|x_{k+1} - x^*\|_2^2 & \leq & \|x_1 - x^*\|_2^2 - 2 \eta (1 - 2 \beta \eta) \E \sum_{t=1}^k (f(x_t) - f(x^*)) \\
& & + 4 \beta \eta^2 k (f(y) - f(x^*)) .
\end{eqnarray*}
Noting that $x_1 = y$ and that by $\alpha$-strong convexity one has $f(x) - f(x^*) \geq \frac{\alpha}{2} \|x - x^*\|_2^2$, one can rearrange the above display to obtain
$$\E f\left(\frac1{k} \sum_{t=1}^k x_t\right) - f(x^*)  \leq \left(\frac{1}{\alpha \eta (1 - 2 \beta \eta) k} + \frac{2 \beta \eta}{1- 2\beta \eta} \right) (f(y) - f(x^*)) .$$
Using that $\eta = \frac{1}{10\beta}$ and $k = 20 \kappa$ finally yields \eqref{eq:SVRG0} which itself concludes the proof.