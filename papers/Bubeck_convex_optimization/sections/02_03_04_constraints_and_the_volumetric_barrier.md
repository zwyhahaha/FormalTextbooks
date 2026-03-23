---
book: Bubeck_convex_optimization
chapter: 2
chapter_title: Convex optimization in finite dimension
section: 3
section_title: Vaidya's cutting plane method
subsection: 4
subsection_title: Constraints and the volumetric barrier
section_id: 2.3.4
tex_label: sec:constraintsvolumetric
theorems:
- id: Lemma 2.5
  label: ''
  tex_label: lem:V1
- id: Theorem 2.6
  label: ''
  tex_label: th:V0
- id: Theorem 2.7
  label: ''
  tex_label: th:V1
- id: Lemma 2.8
  label: ''
  tex_label: lem:V2
lean_files:
- id: Lemma 2.5
  path: proofs/Bubeck_convex_optimization/Lemma25.lean
  status: partial
- id: Theorem 2.6
  path: proofs/Bubeck_convex_optimization/Theorem26.lean
  status: pending
- id: Theorem 2.7
  path: proofs/Bubeck_convex_optimization/Theorem27.lean
  status: pending
- id: Lemma 2.8
  path: proofs/Bubeck_convex_optimization/Lemma28.lean
  status: pending
---

\subsection{Constraints and the volumetric barrier} \label{sec:constraintsvolumetric}
We want to understand the effect on the volumetric barrier of addition/deletion of constraints to the polytope. Let $c \in \mathbb{R}^n$, $\beta \in \mathbb{R}$, and consider the logarithmic barrier $\tilde{F}$ and the volumetric barrier $\tilde{v}$ corresponding to the matrix $\tilde{A}\in \mathbb{R}^{(m+1) \times n}$ and the vector $\tilde{b} \in \mathbb{R}^{m+1}$ which are respectively the concatenation of $A$ and $c$, and the concatenation of $b$ and $\beta$. Let $x^*$ and $\tilde{x}^*$ be the minimizer of respectively $v$ and $\tilde{v}$. We recall the definition of leverage scores, for $i \in [m+1]$, where $a_{m+1}=c$ and $b_{m+1}=\beta$,
$$\sigma_i(x) = \frac{(\nabla^2 F(x) )^{-1}[a_i, a_i]}{(a_i^{\top} x - b_i)^2}, \ \text{and} \ \tilde{\sigma}_i(x) = \frac{(\nabla^2 \tilde{F}(x) )^{-1}[a_i, a_i]}{(a_i^{\top} x - b_i)^2}.$$
The leverage scores $\sigma_i$ and $\tilde{\sigma}_i$ are closely related:

**Lemma**
 \label{lem:V1}
One has for any $i \in [m+1]$,
$$\frac{\tilde{\sigma}_{m+1}(x)}{1 - \tilde{\sigma}_{m+1}(x)} \geq \sigma_i(x) \geq \tilde{\sigma}_i(x) \geq (1-\sigma_{m+1}(x)) \sigma_i(x) .$$

*Proof.*

First we observe that by Sherman-Morrison's formula $(A+uv^{\top})^{-1} = A^{-1} - \frac{A^{-1} u v^{\top} A^{-1}}{1+A^{-1}[u,v]}$ one has
 \label{eq:SM}
(\nabla^2 \tilde{F}(x))^{-1} = (\nabla^2 F(x))^{-1} - \frac{(\nabla^2 F(x))^{-1} c c^{\top} (\nabla^2 F(x))^{-1}}{(c^{\top} x - \beta)^2 + (\nabla^2 F(x))^{-1}[c,c]} ,

This immediately proves $\tilde{\sigma}_i(x) \leq \sigma_i(x)$. It also implies the inequality $\tilde{\sigma}_i(x) \geq (1-\sigma_{m+1}(x)) \sigma_i(x)$ thanks the following fact: $A - \frac{A u u^{\top} A}{1+A[u,u]} \succeq (1-A[u,u]) A$. For the last inequality we use that $A + \frac{A u u^{\top} A}{1+A[u,u]} \preceq \frac{1}{1-A[u,u]} A$ together with
$$(\nabla^2 {F}(x))^{-1} = (\nabla^2 \tilde{F}(x))^{-1} + \frac{(\nabla^2 \tilde{F}(x))^{-1} c c^{\top} (\nabla^2 \tilde{F}(x))^{-1}}{(c^{\top} x - \beta)^2 - (\nabla^2 \tilde{F}(x))^{-1}[c,c]} .$$

We now assume the following key result, which was first proven by Vaidya. To put the statement in context recall that for a self-concordant barrier $f$ the suboptimality gap $f(x) - \min f$ is intimately related to the Newton decrement $\|\nabla f(x) \|_{(\nabla^2 f(x))^{-1}}$. Vaidya's inequality gives a similar claim for the volumetric barrier. We use the version given in [Theorem 2.6, \cite{Ans98}] which has slightly better numerical constants than the original bound. Recall also the definition of $Q$ from \eqref{eq:hessianvol}.

**Theorem**
 \label{th:V0}
Let $\lambda(x) = \|\nabla v(x) \|_{Q(x)^{-1}}$ be an approximate Newton decrement, $\epsilon = \min_{i \in [m]} \sigma_i(x)$, and assume that $\lambda(x)^2 \leq \frac{2 \sqrt{\epsilon} - \epsilon}{36}$. Then
$$v(x) - v(x^*) \leq 2 \lambda(x)^2 . $$

We also denote $\tilde{\lambda}$ for the approximate Newton decrement of $\tilde{v}$. The goal for the rest of the section is to prove the following theorem which gives the precise understanding of the volumetric barrier we were looking for.

**Theorem**
 \label{th:V1}
Let $\epsilon := \min_{i \in [m]} \sigma_i(x^*)$, $\delta := \sigma_{m+1}(x^*) / \sqrt{\epsilon}$ and assume that $\frac{\left(\delta \sqrt{\epsilon} + \sqrt{\delta^{3} \sqrt{\epsilon}}\right)^2}{1- \delta \sqrt{\epsilon}} < \frac{2 \sqrt{\epsilon} - \epsilon}{36}$. Then one has
 \label{eq:thV11}
\tilde{v}(\tilde{x}^*) - v(x^*) \geq \frac{1}{2} \log(1+\delta \sqrt{\epsilon}) - 2  \frac{\left(\delta \sqrt{\epsilon} + \sqrt{\delta^{3} \sqrt{\epsilon}}\right)^2}{1- \delta \sqrt{\epsilon}}  .

On the other hand assuming that $\tilde{\sigma}_{m+1}(\tilde{x}^*) = \min_{i \in [m+1]} \tilde{\sigma}_{i}(\tilde{x}^*) =: \epsilon$ and that $\epsilon \leq 1/4$, one has 
 \label{eq:thV12}
\tilde{v}(\tilde{x}^*) - v(x^*) \leq - \frac{1}{2} \log(1 - \epsilon) + \frac{8 \epsilon^2}{(1-\epsilon)^2}.

Before going into the proof let us see briefly how Theorem \ref{th:V1} give the two inequalities stated at the beginning of Section \ref{sec:analysis}. To prove \eqref{eq:analysis2} we use \eqref{eq:thV11} with $\delta=1/5$ and $\epsilon \leq 0.006$, and we observe that in this case the right hand side of \eqref{eq:thV11} is lower bounded by $\frac{1}{20} \sqrt{\epsilon}$. On the other hand to prove \eqref{eq:analysis1} we use \eqref{eq:thV12}, and we observe that for $\epsilon \leq 0.006$ the right hand side of \eqref{eq:thV12} is upper bounded by $\epsilon$.

*Proof.*

We start with the proof of \eqref{eq:thV11}. First observe that by factoring $(\nabla^2 F(x))^{1/2}$ on the left and on the right of $\nabla^2 \tilde{F}(x)$ one obtains
\begin{align*}
& \mathrm{det}(\nabla^2 \tilde{F}(x)) \\
& = \mathrm{det}\left(\nabla^2 {F}(x) + \frac{cc^{\top}}{(c^{\top} x- \beta)^2} \right) \\
& = \mathrm{det}(\nabla^2 {F}(x)) \mathrm{det}\left(\mathrm{I}_n + \frac{(\nabla^2 {F}(x))^{-1/2} c c^{\top} (\nabla^2 {F}(x))^{-1/2}}{(c^{\top} x- \beta)^2}\right) \\
& = \mathrm{det}(\nabla^2 {F}(x)) (1+\sigma_{m+1}(x)) ,
\end{align*}
and thus
$$\tilde{v}(x) = v(x) + \frac{1}{2} \log(1+ \sigma_{m+1}(x)) .$$
In particular we have
$$\tilde{v}(\tilde{x}^*) - v(x^*) = \frac{1}{2} \log(1+ \sigma_{m+1}(x^*)) - (\tilde{v}(x^*) - \tilde{v}(\tilde{x}^*)) .$$
To bound the suboptimality gap of $x^*$ in $\tilde{v}$ we will invoke Theorem \ref{th:V0} and thus we have to upper bound the approximate Newton decrement $\tilde{\lambda}$.
Using [\eqref{eq:V21}, Lemma \ref{lem:V2}] below one has 
$$\tilde{\lambda} (x^*)^2 \leq \frac{\left(\sigma_{m+1}(x^*) + \sqrt{\frac{\sigma_{m+1}^3(x^*)}{\min_{i \in [m]} \sigma_i(x^*)}}\right)^2}{1-\sigma_{m+1}(x^*)} = \frac{\left(\delta \sqrt{\epsilon} + \sqrt{\delta^{3} \sqrt{\epsilon}}\right)^2}{1- \delta \sqrt{\epsilon}}  .$$
This concludes the proof of \eqref{eq:thV11}.
\newline

We now turn to the proof of \eqref{eq:thV12}. Following the same steps as above we immediately obtain
\begin{eqnarray*}
\tilde{v}(\tilde{x}^*) - v(x^*) & = & \tilde{v}(\tilde{x}^*) - v(\tilde{x}^*)+v(\tilde{x}^*)- v(x^*)  \\
& = & - \frac{1}{2} \log(1 - \tilde{\sigma}_{m+1}(\tilde{x}^*)) + v(\tilde{x}^*)- v(x^*).
\end{eqnarray*}
To invoke Theorem \ref{th:V0} it remains to upper bound $\lambda(\tilde{x}^*)$. Using [\eqref{eq:V22}, Lemma \ref{lem:V2}] below one has
$$ \lambda(\tilde{x}^*) \leq \frac{2 \ \tilde{\sigma}_{m+1}(\tilde{x}^*)}{1 - \tilde{\sigma}_{m+1}(\tilde{x}^*)} .$$
We can apply Theorem \ref{th:V0} since the assumption $\epsilon \leq 1/4$ implies that $\left(\frac{2 \epsilon}{1-\epsilon}\right)^2 \leq \frac{2 \sqrt{\epsilon} - \epsilon}{36}$. This concludes the proof of \eqref{eq:thV12}.

**Lemma**
 \label{lem:V2}
One has
 \label{eq:V21}
\sqrt{1- \sigma_{m+1}(x)} \ \tilde{\lambda} (x) \leq \|\nabla {v}(x)\|_{Q(x)^{-1}} + \sigma_{m+1}(x) + \sqrt{\frac{\sigma_{m+1}^3(x)}{\min_{i \in [m]} \sigma_i(x)}} .

Furthermore if $\tilde{\sigma}_{m+1}(x) = \min_{i \in [m+1]} \tilde{\sigma}_{i}(x)$ then one also has
 \label{eq:V22}
\lambda(x) \leq  \|\nabla \tilde{v}(x)\|_{Q(x)^{-1}} + \frac{2 \ \tilde{\sigma}_{m+1}(x)}{1 - \tilde{\sigma}_{m+1}(x)} .

*Proof.*

We start with the proof of \eqref{eq:V21}. First observe that by Lemma \ref{lem:V1} one has $\tilde{Q}(x) \succeq (1-\sigma_{m+1}(x)) Q(x)$ and thus by definition of the Newton decrement
$$\tilde{\lambda} (x) = \|\nabla \tilde{v}(x)\|_{\tilde{Q}(x)^{-1}} \leq \frac{\|\nabla \tilde{v}(x)\|_{Q(x)^{-1}}}{\sqrt{1-\sigma_{m+1}(x)}} .$$
Next observe that (recall \eqref{eq:gradvol})
$$ \nabla \tilde{v}(x) = \nabla v(x) + \sum_{i=1}^m ({\sigma}_i(x) - \tilde{\sigma}_i(x)) \frac{a_i}{a_i^{\top} x - b_i} - \tilde{\sigma}_{m+1}(x) \frac{c}{c^{\top} x - \beta} .$$
We now use that $Q(x) \succeq (\min_{i \in [m]} \sigma_i(x)) \nabla^2 F(x)$ to obtain 
$$\left \| \tilde{\sigma}_{m+1}(x) \frac{c}{c^{\top} x - \beta} \right\|_{Q(x)^{-1}}^2 \leq \frac{\tilde{\sigma}_{m+1}^2(x) \sigma_{m+1}(x)}{\min_{i \in [m]} \sigma_i(x)} .$$
By Lemma \ref{lem:V1} one has $\tilde{\sigma}_{m+1}(x) \leq {\sigma}_{m+1}(x)$ and thus we see that it only remains to prove 
$$\left\|\sum_{i=1}^m ({\sigma}_i(x) - \tilde{\sigma}_i(x)) \frac{a_i}{a_i^{\top}x - b_i} \right\|_{Q(x)^{-1}}^2 \leq \sigma_{m+1}^2(x) .$$
The above inequality follows from a beautiful calculation of Vaidya (see [Lemma 12, \cite{Vai96}]), starting from the identity
$$\sigma_i(x) - \tilde{\sigma}_i(x) = \frac{((\nabla^2 F(x))^{-1}[a_i,c])^2}{((c^{\top} x - \beta)^2 + (\nabla^2 F(x))^{-1}[c,c])(a_i^{\top} x - b_i)^2} ,$$
which itself follows from \eqref{eq:SM}.
\newline

We now turn to the proof of \eqref{eq:V22}. Following the same steps as above we immediately obtain
$$\lambda(x) = \|\nabla v(x)\|_{Q(x)^{-1}} \leq \|\nabla \tilde{v}(x)\|_{Q(x)^{-1}} + \sigma_{m+1}(x) + \sqrt{\frac{\tilde{\sigma}_{m+1}^2(x) \sigma_{m+1}(x)}{\min_{i \in [m]} \sigma_i(x)}} .$$
Using Lemma \ref{lem:V1} together with the assumption $\tilde{\sigma}_{m+1}(x) = \min_{i \in [m+1]} \tilde{\sigma}_{i}(x)$ yields \eqref{eq:V22}, thus concluding the proof.