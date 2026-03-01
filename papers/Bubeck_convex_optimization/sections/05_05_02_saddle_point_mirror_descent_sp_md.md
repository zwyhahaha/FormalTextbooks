---
book: Bubeck_convex_optimization
chapter: 5
chapter_title: Beyond the black-box model
section: 5
section_title: Smooth saddle-point representation of a non-smooth function
subsection: 2
subsection_title: Saddle Point Mirror Descent (SP-MD)
section_id: 5.5.2
tex_label: sec:spmd
theorems:
- id: Theorem 5.1
  label: ''
  tex_label: th:spmd
lean_files:
- id: Theorem 5.1
  path: proofs/Bubeck_convex_optimization/Theorem51.lean
  status: pending
---

\subsection{Saddle Point Mirror Descent (SP-MD)} \label{sec:spmd}
We consider here mirror descent on the space $\cZ = \cX \times \cY$ with the mirror map $\Phi(z) = a \Phi_{\cX}(x) + b \Phi_{\cY}(y)$ (defined on $\cD = \cD_{\cX} \times \cD_{\cY}$), where $a, b \in \R_+$ are to be defined later, and with the vector field $g : \cZ \rightarrow \R^n \times \R^m$ defined in the previous subsection. We call the resulting algorithm SP-MD (Saddle Point Mirror Descent). It can be described succintly as follows.

Let $z_1 \in \argmin_{z \in \cZ \cap \cD} \Phi(z)$. Then for $t \geq 1$, let
$$z_{t+1} \in \argmin_{z \in \cZ \cap \cD} \ \eta g_t^{\top} z + D_{\Phi}(z,z_t) ,$$
where $g_t = (g_{\cX,t}, g_{\cY,t})$ with $g_{\cX,t} \in \partial_x \phi(x_t,y_t)$ and $g_{\cY,t} \in \partial_y (- \phi(x_t,y_t))$.

**Theorem**
 \label{th:spmd}
Assume that $\phi(\cdot, y)$ is $L_{\cX}$-Lipschitz w.r.t. $\|\cdot\|_{\cX}$, that is $\|g_{\cX}(x,y)\|_{\cX}^* \leq L_{\cX}, \forall (x, y) \in \cX \times \cY$. Similarly assume that $\phi(x, \cdot)$ is $L_{\cY}$-Lipschitz w.r.t. $\|\cdot\|_{\cY}$. Then SP-MD with $a= \frac{L_{\cX}}{R_{\cX}}$, $b=\frac{L_{\cY}}{R_{\cY}}$, and $\eta=\sqrt{\frac{2}{t}}$ satisfies
$$\max_{y \in \mathcal{Y}} \phi\left( \frac1{t} \sum_{s=1}^t x_s,y \right) - \min_{x \in \mathcal{X}} \phi\left(x, \frac1{t} \sum_{s=1}^t y_s \right) \leq (R_{\cX} L_{\cX} + R_{\cY} L_{\cY}) \sqrt{\frac{2}{t}}.$$

*Proof.*

First we endow $\mathcal{Z}$ with the norm $\|\cdot\|_{\cZ}$ defined by
$$\|z\|_{\cZ} = \sqrt{a \|x\|_{\mathcal{X}}^2 + b \|y\|_{\mathcal{Y}}^2} .$$
It is immediate that $\Phi$ is $1$-strongly convex with respect to $\|\cdot\|_{\mathcal{Z}}$ on $\mathcal{Z} \cap \mathcal{D}$. Furthermore one can easily check that
$$\|z\|_{\mathcal{Z}}^* = \sqrt{\frac1{a} \left(\|x\|_{\mathcal{X}}^*\right)^2 + \frac1{b} \left(\|y\|_{\mathcal{Y}}^*\right)^2} ,$$
and thus the vector field $(g_t)$ used in the SP-MD satisfies:
$$\|g_t\|_{\mathcal{Z}}^* \leq \sqrt{\frac{L_{\mathcal{X}}^2}{a} + \frac{L_{\mathcal{Y}}^2}{b}} .$$
Using \eqref{eq:vfMD} together with \eqref{eq:keysp} and the values of $a, b$ and $\eta$ concludes the proof.