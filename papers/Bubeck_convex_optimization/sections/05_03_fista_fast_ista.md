---
book: Bubeck_convex_optimization
chapter: 5
chapter_title: Beyond the black-box model
section: 3
section_title: FISTA (Fast ISTA)
subsection: null
subsection_title: null
section_id: '5.3'
tex_label: ''
theorems: []
lean_files: []
---

\section*{FISTA (Fast ISTA)}
An obvious idea is to combine Nesterov's accelerated gradient descent (which results in a $1/t^2$ rate to optimize $f$) with ISTA. This results in FISTA (Fast ISTA) which is described as follows. Let
$$\lambda_0 = 0, \ \lambda_{t} = \frac{1 + \sqrt{1+ 4 \lambda_{t-1}^2}}{2}, \ \text{and} \  \gamma_t = \frac{1 - \lambda_t}{\lambda_{t+1}}.$$
Let $x_1 = y_1$ an arbitrary initial point, and
\begin{eqnarray*}
y_{t+1} & = & \mathrm{argmin}_{x \in \mathbb{R}^n} \ g(x) + \frac{\beta}{2} \|x - (x_t - \frac1{\beta} \nabla f(x_t)) \|_2^2 , \\
x_{t+1} & = & (1 - \gamma_t) y_{t+1} + \gamma_t y_t .
\end{eqnarray*}
Again it is easy show that the rate of convergence of FISTA on $f+g$ is similar to the one of Nesterov's accelerated gradient descent on $f$, more precisely:
$$f(y_t) + g(y_t) - (f(x^*) + g(x^*)) \leq \frac{2 \beta \|x_1 - x^*\|^2}{t^2} .$$