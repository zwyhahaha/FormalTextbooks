---
book: Bubeck_convex_optimization
chapter: 5
chapter_title: Beyond the black-box model
section: 5
section_title: Smooth saddle-point representation of a non-smooth function
subsection: 3
subsection_title: Saddle Point Mirror Prox (SP-MP)
section_id: 5.5.3
tex_label: ''
theorems:
- id: Theorem 5.2
  label: ''
  tex_label: th:spmp
lean_files:
- id: Theorem 5.2
  path: proofs/Bubeck_convex_optimization/Theorem52.lean
  status: pending
---

\subsection{Saddle Point Mirror Prox (SP-MP)}
We now consider the most interesting situation in the context of this chapter, where the function $\phi$ is smooth. Precisely we say that $\phi$ is $(\beta_{11}, \beta_{12}, \beta_{22}, \beta_{21})$-smooth if for any $x, x' \in \cX, y, y' \in \cY$, 
\begin{align*}
& \|\nabla_x \phi(x,y) - \nabla_x \phi(x',y) \|_{\mathcal{X}}^* \leq \beta_{11} \|x-x'\|_{\mathcal{X}} , \\
& \|\nabla_x \phi(x,y) - \nabla_x \phi(x,y') \|_{\mathcal{X}}^* \leq \beta_{12} \|y-y'\|_{\mathcal{Y}} , \\
& \|\nabla_y \phi(x,y) - \nabla_y \phi(x,y') \|_{\mathcal{Y}}^* \leq \beta_{22} \|y-y'\|_{\mathcal{Y}} , \\
& \|\nabla_y \phi(x,y) - \nabla_y \phi(x',y) \|_{\mathcal{Y}}^* \leq \beta_{21} \|x-x'\|_{\mathcal{X}} ,
\end{align*}
This will imply the Lipschitzness of the vector field $g : \cZ \rightarrow \R^n \times \R^m$ under the appropriate norm. Thus we use here mirror prox on the space $\cZ$ with the mirror map $\Phi(z) = a \Phi_{\cX}(x) + b \Phi_{\cY}(y)$ and the vector field $g$. The resulting algorithm is called SP-MP (Saddle Point Mirror Prox) and we can describe it succintly as follows.

Let $z_1 \in \argmin_{z \in \cZ \cap \cD} \Phi(z)$. Then for $t \geq 1$, let $z_t=(x_t,y_t)$ and $w_t=(u_t, v_t)$ be defined by
\begin{eqnarray*}
w_{t+1} & = & \argmin_{z \in \cZ \cap \cD} \ \eta (\nabla_x \phi(x_t, y_t), - \nabla_y \phi(x_t,y_t))^{\top} z + D_{\Phi}(z,z_t) \\
z_{t+1} & = & \argmin_{z \in \cZ \cap \cD} \ \eta (\nabla_x \phi(u_{t+1}, v_{t+1}), - \nabla_y \phi(u_{t+1},v_{t+1}))^{\top} z + D_{\Phi}(z,z_t) .
\end{eqnarray*}

**Theorem**
 \label{th:spmp}
Assume that $\phi$ is $(\beta_{11}, \beta_{12}, \beta_{22}, \beta_{21})$-smooth. Then SP-MP with $a= \frac{1}{R_{\cX}^2}$, $b=\frac{1}{R_{\cY}^2}$, and 

$\eta= 1 / \left(2 \max \left(\beta_{11} R^2_{\cX}, \beta_{22} R^2_{\cY}, \beta_{12} R_{\cX} R_{\cY}, \beta_{21} R_{\cX} R_{\cY}\right) \right)$
satisfies
\begin{align*}
& \max_{y \in \mathcal{Y}} \phi\left( \frac1{t} \sum_{s=1}^t u_{s+1},y \right) - \min_{x \in \mathcal{X}} \phi\left(x, \frac1{t} \sum_{s=1}^t v_{s+1} \right) \\
& \leq \max \left(\beta_{11} R^2_{\cX}, \beta_{22} R^2_{\cY}, \beta_{12} R_{\cX} R_{\cY}, \beta_{21} R_{\cX} R_{\cY}\right) \frac{4}{t} .
\end{align*}

*Proof.*

In light of the proof of Theorem \ref{th:spmd} and \eqref{eq:vfMP} it clearly suffices to show that the vector field $g(z) = (\nabla_x \phi(x,y), - \nabla_y \phi_(x,y))$ is $\beta$-Lipschitz w.r.t. $\|z\|_{\cZ} = \sqrt{\frac{1}{R_{\cX}^2} \|x\|_{\mathcal{X}}^2 + \frac{1}{R_{\cY}^2} \|y\|_{\mathcal{Y}}^2}$ with $\beta = 2 \max \left(\beta_{11} R^2_{\cX}, \beta_{22} R^2_{\cY}, \beta_{12} R_{\cX} R_{\cY}, \beta_{21} R_{\cX} R_{\cY}\right)$. In other words one needs to show that
$$\|g(z) - g(z')\|_{\cZ}^* \leq \beta \|z - z'\|_{\cZ} ,$$
which can be done with straightforward calculations (by introducing $g(x',y)$ and using the definition of smoothness for $\phi$).