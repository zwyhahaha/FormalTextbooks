---
book: Bubeck_convex_optimization
chapter: 3
chapter_title: Dimension-free convex optimization
section: 7
section_title: Nesterov's accelerated gradient descent
subsection: 2
subsection_title: The smooth case
section_id: 3.7.2
tex_label: ''
theorems:
- id: Theorem 3.18
  label: ''
  tex_label: ''
lean_files:
- id: Theorem 3.18
  path: proofs/Bubeck_convex_optimization/Theorem318.lean
  status: pending
---

\subsection{The smooth case}

In this section we show how to adapt Nesterov's accelerated gradient descent for the case $\alpha=0$, using a time-varying combination of the elements in the primary sequence $(y_t)$. First we define the following sequences:
$$\lambda_0 = 0, \ \lambda_{t} = \frac{1 + \sqrt{1+ 4 \lambda_{t-1}^2}}{2}, \ \text{and} \  \gamma_t = \frac{1 - \lambda_t}{\lambda_{t+1}}.$$
(Note that $\gamma_t \leq 0$.) Now the algorithm is simply defined by the following equations, with $x_1 = y_1$ an arbitrary initial point,
\begin{eqnarray*}
y_{t+1} & = & x_t  - \frac{1}{\beta} \nabla f(x_t) , \\
x_{t+1} & = & (1 - \gamma_s) y_{t+1} + \gamma_t y_t .
\end{eqnarray*}

**Theorem**

Let $f$ be a convex and $\beta$-smooth function, then Nesterov's accelerated gradient descent satisfies
$$f(y_t) - f(x^*) \leq \frac{2 \beta \|x_1 - x^*\|^2}{t^2} .$$

We follow here the proof of \cite{BT09}. We also refer to \cite{Tse08} for a proof with simpler step-sizes.

*Proof.*

Using the unconstrained version of Lemma \ref{lem:smoothconst} one obtains

& f(y_{s+1}) - f(y_s) \notag \\
& \leq \nabla f(x_s)^{\top} (x_s-y_s) - \frac{1}{2 \beta} \| \nabla f(x_s) \|^2 \notag \\
& = \beta (x_s - y_{s+1})^{\top} (x_s-y_s) - \frac{\beta}{2} \| x_s - y_{s+1} \|^2 . \label{eq:1}

Similarly we also get
 \label{eq:2}
f(y_{s+1}) - f(x^*) \leq \beta (x_s - y_{s+1})^{\top} (x_s-x^*) - \frac{\beta}{2} \| x_s - y_{s+1} \|^2 .

Now multiplying \eqref{eq:1} by $(\lambda_{s}-1)$ and adding the result to \eqref{eq:2}, one obtains with $\delta_s = f(y_s) - f(x^*)$,
\begin{align*}
& \lambda_{s} \delta_{s+1} - (\lambda_{s} - 1) \delta_s \\
& \leq \beta (x_s - y_{s+1})^{\top} (\lambda_{s} x_{s} - (\lambda_{s} - 1) y_s-x^*) - \frac{\beta}{2} \lambda_{s} \| x_s - y_{s+1} \|^2.
\end{align*}
Multiplying this inequality by $\lambda_{s}$ and using that by definition $\lambda_{s-1}^2 = \lambda_{s}^2 - \lambda_{s}$, as well as the elementary identity $2 a^{\top} b -  \|a\|^2 = \|b\|^2 - \|b-a\|^2$, one obtains

& \lambda_{s}^2 \delta_{s+1} - \lambda_{s-1}^2 \delta_s \notag \\
& \leq \frac{\beta}{2} \bigg( 2 \lambda_{s} (x_s - y_{s+1})^{\top} (\lambda_{s} x_{s} - (\lambda_{s} - 1) y_s-x^*) - \|\lambda_{s}( y_{s+1} - x_s  )\|^2\bigg) \notag \\
& = \frac{\beta}{2} \bigg(\| \lambda_{s} x_{s} - (\lambda_{s} - 1) y_{s}-x^* \|^2 - \| \lambda_{s} y_{s+1} - (\lambda_{s} - 1) y_{s}-x^* \|^2 \bigg). \label{eq:3}

Next remark that, by definition, one has 

& x_{s+1} = y_{s+1} + \gamma_s (y_s - y_{s+1}) \notag \\
& \Leftrightarrow \lambda_{s+1} x_{s+1} = \lambda_{s+1} y_{s+1} + (1-\lambda_{s})(y_s - y_{s+1}) \notag \\
& \Leftrightarrow \lambda_{s+1} x_{s+1} - (\lambda_{s+1} - 1) y_{s+1}= \lambda_{s} y_{s+1} - (\lambda_{s}-1) y_{s} . \label{eq:5}

Putting together \eqref{eq:3} and \eqref{eq:5} one gets with $u_s = \lambda_{s} x_{s} - (\lambda_{s} - 1) y_{s} - x^*$,
$$\lambda_{s}^2 \delta_{s+1} - \lambda_{s-1}^2 \delta_s^2 \leq \frac{\beta}{2} \bigg(\|u_s\|^2 - \|u_{s+1}\|^2 \bigg) .$$
Summing these inequalities from $s=1$ to $s=t-1$ one obtains:
$$\delta_t \leq \frac{\beta}{2 \lambda_{t-1}^2} \|u_1\|^2.$$
By induction it is easy to see that $\lambda_{t-1} \geq \frac{t}{2}$ which concludes the proof.