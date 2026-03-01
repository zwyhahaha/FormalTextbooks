---
book: Bubeck_convex_optimization
chapter: 2
chapter_title: Convex optimization in finite dimension
section: 2
section_title: The ellipsoid method
subsection: null
subsection_title: null
section_id: '2.2'
tex_label: sec:ellipsoid
theorems:
- id: Lemma 2.3
  label: ''
  tex_label: lem:geomellipsoid
- id: Theorem 2.4
  label: ''
  tex_label: ''
lean_files:
- id: Lemma 2.3
  path: proofs/Bubeck_convex_optimization/Lemma23.lean
  status: pending
- id: Theorem 2.4
  path: proofs/Bubeck_convex_optimization/Theorem24.lean
  status: pending
---

\section{The ellipsoid method} \label{sec:ellipsoid}
Recall that an ellipsoid is a convex set of the form
$$\mathcal{E} = \{x \in \R^n : (x - c)^{\top} H^{-1} (x-c) \leq 1 \} ,$$
where $c \in \R^n$, and $H$ is a symmetric positive definite matrix. Geometrically $c$ is the center of the ellipsoid, and the semi-axes of $\cE$ are given by the eigenvectors of $H$, with lengths given by the square root of the corresponding eigenvalues.

We give now a simple geometric lemma, which is at the heart of the ellipsoid method.

**Lemma**
 \label{lem:geomellipsoid}
Let $\mathcal{E}_0 = \{x \in \R^n : (x - c_0)^{\top} H_0^{-1} (x-c_0) \leq 1 \}$. For any $w \in \R^n$, $w \neq 0$, there exists an ellipsoid $\mathcal{E}$ such that

\mathcal{E} \supset \{x \in \mathcal{E}_0 : w^{\top} (x-c_0) \leq 0\} , \label{eq:ellipsoidlemma1}

and 

\mathrm{vol}(\mathcal{E}) \leq \exp \left(- \frac{1}{2 n} \right) \mathrm{vol}(\mathcal{E}_0) . \label{eq:ellipsoidlemma2}

Furthermore for $n \geq 2$ one can take $\cE = \{x \in \R^n : (x - c)^{\top} H^{-1} (x-c) \leq 1 \}$ where

& c = c_0 - \frac{1}{n+1} \frac{H_0 w}{\sqrt{w^{\top} H_0 w}} , \label{eq:ellipsoidlemma3}\\
& H = \frac{n^2}{n^2-1} \left(H_0 - \frac{2}{n+1} \frac{H_0 w w^{\top} H_0}{w^{\top} H_0 w} \right) . \label{eq:ellipsoidlemma4}

*Proof.*

For $n=1$ the result is obvious, in fact we even have $\mathrm{vol}(\mathcal{E}) \leq \frac12 \mathrm{vol}(\mathcal{E}_0) .$

For $n \geq 2$ one can simply verify that the ellipsoid given by \eqref{eq:ellipsoidlemma3} and \eqref{eq:ellipsoidlemma4} satisfy the required properties \eqref{eq:ellipsoidlemma1} and \eqref{eq:ellipsoidlemma2}. Rather than bluntly doing these computations we will show how to derive \eqref{eq:ellipsoidlemma3} and \eqref{eq:ellipsoidlemma4}. As a by-product this will also show that the ellipsoid defined by \eqref{eq:ellipsoidlemma3} and \eqref{eq:ellipsoidlemma4} is the unique ellipsoid of minimal volume that satisfy \eqref{eq:ellipsoidlemma1}. Let us first focus on the case where $\mathcal{E}_0$ is the Euclidean ball $\cB = \{x \in \R^n : x^{\top} x \leq 1\}$. We momentarily assume that $w$ is a unit norm vector. 

By doing a quick picture, one can see that it makes sense to look for an ellipsoid $\mathcal{E}$ that would be centered at $c= - t w$, with $t \in [0,1]$ (presumably $t$ will be small), and such that one principal direction is $w$ (with inverse squared semi-axis $a>0$), and the other principal directions are all orthogonal to $w$ (with the same inverse squared semi-axes $b>0$). In other words we are looking for $\mathcal{E}= \{x: (x - c)^{\top} H^{-1} (x-c) \leq 1 \}$ with
$$c = - t w, \; \text{and} \; H^{-1} = a w w^{\top} + b (\mI_n - w w^{\top} ) .$$
Now we have to express our constraints on the fact that $\mathcal{E}$ should contain the half Euclidean ball $\{x \in \cB : x^{\top} w \leq 0\}$. Since we are also looking for $\mathcal{E}$ to be as small as possible, it makes sense to ask for $\mathcal{E}$ to "touch" the Euclidean ball, both at $x = - w$, and at the equator $\partial \cB \cap w^{\perp}$. The former condition can be written as:
$$(- w - c)^{\top} H^{-1} (- w - c) = 1 \Leftrightarrow (t-1)^2 a = 1 ,$$
while the latter is expressed as:
$$\forall y \in \partial \cB \cap w^{\perp}, (y - c)^{\top} H^{-1} (y - c) = 1 \Leftrightarrow b + t^2 a = 1 .$$
As one can see from the above two equations, we are still free to choose any value for $t \in [0,1/2)$ (the fact that we need $t<1/2$ comes from $b=1 - \left(\frac{t}{t-1}\right)^2>0$). Quite naturally we take the value that minimizes the volume of the resulting ellipsoid. Note that

$$\frac{\mathrm{vol}(\mathcal{E})}{\mathrm{vol}(\cB)} = \frac{1}{\sqrt{a}} \left(\frac{1}{\sqrt{b}}\right)^{n-1} 
= \frac{1}{\sqrt{\frac{1}{(1-t)^2}\left (1 - \left(\frac{t}{1-t}\right)^2\right)^{n-1}}} \\= \frac{1}{\sqrt{f\left(\frac{1}{1-t}\right)}} ,$$
where $f(h) = h^2 (2 h - h^2)^{n-1}$. Elementary computations show that the maximum of $f$ (on $[1,2]$) is attained at $h = 1+ \frac{1}{n}$ (which corresponds to $t=\frac{1}{n+1}$), and the value is 
$$\left(1+\frac{1}{n}\right)^2 \left(1 - \frac{1}{n^2} \right)^{n-1} \geq \exp \left(\frac{1}{n} \right),$$
where the lower bound follows again from elementary computations. Thus we showed that, for $\cE_0 = \cB$, \eqref{eq:ellipsoidlemma1} and \eqref{eq:ellipsoidlemma2} are satisfied with the ellipsoid given by the set of points $x$ satisfying:
 \label{eq:ellipsoidlemma5}
\left(x + \frac{w/\|w\|_2}{n+1}\right)^{\top} \left(\frac{n^2-1}{n^2} \mI_n + \frac{2(n+1)}{n^2} \frac{w w^{\top}}{\|w\|_2^2} \right) \left(x + \frac{w/\|w\|_2}{n+1} \right) \leq 1 .

We consider now an arbitrary ellipsoid $\cE_0 = \{x \in \R^n : (x - c_0)^{\top} H_0^{-1} (x-c_0) \leq 1 \}$. Let $\Phi(x) = c_0 + H_0^{1/2} x$, then clearly $\cE_0 = \Phi(\cB)$ and $\{x : w^{\top}(x - c_0) \leq 0\} = \Phi(\{x : (H_0^{1/2} w)^{\top} x \leq 0\})$. Thus in this case the image by $\Phi$ of the ellipsoid given in \eqref{eq:ellipsoidlemma5} with $w$ replaced by $H_0^{1/2} w$ will satisfy \eqref{eq:ellipsoidlemma1} and \eqref{eq:ellipsoidlemma2}. It is easy to see that this corresponds to an ellipsoid defined by

& c = c_0 - \frac{1}{n+1} \frac{H_0 w}{\sqrt{w^{\top} H_0 w}} , \notag \\
& H^{-1} = \left(1 - \frac{1}{n^2}\right) H_0^{-1} + \frac{2(n+1)}{n^2} \frac{w w^{\top}}{w^{\top} H_0 w} . \label{eq:ellipsoidlemma6}

Applying Sherman-Morrison formula to \eqref{eq:ellipsoidlemma6} one can recover \eqref{eq:ellipsoidlemma4} which concludes the proof.

We describe now the ellipsoid method, which only assumes a separation oracle for the constraint set $\cX$ (in particular it can be used to solve the feasibility problem mentioned at the beginning of the chapter). 

Let $\cE_0$ be the Euclidean ball of radius $R$ that contains $\cX$, and let $c_0$ be its center. Denote also $H_0=R^2 \mI_n$. For $t \geq 0$ do the following:

\item If $c_t \not\in \cX$ then call the separation oracle to obtain a separating hyperplane $w_t \in \R^n$ such that $\cX \subset \{x : (x- c_t)^{\top} w_t \leq 0\}$, otherwise call the first order oracle at $c_t$ to obtain $w_t \in \partial f (c_t)$. 
\item Let $\cE_{t+1} = \{x : (x - c_{t+1})^{\top} H_{t+1}^{-1} (x-c_{t+1}) \leq 1 \}$ be the ellipsoid given in Lemma \ref{lem:geomellipsoid} that contains $\{x \in \mathcal{E}_t : (x- c_t)^{\top} w_t \leq 0\}$, that is
\begin{align*}
& c_{t+1} = c_{t} - \frac{1}{n+1} \frac{H_t w}{\sqrt{w^{\top} H_t w}} ,\\
& H_{t+1} = \frac{n^2}{n^2-1} \left(H_t - \frac{2}{n+1} \frac{H_t w w^{\top} H_t}{w^{\top} H_t w} \right) .
\end{align*}

If stopped after $t$ iterations and if $\{c_1, \hdots, c_t\} \cap \cX \neq \emptyset$, then we use the zeroth order oracle to output
$$x_t\in \argmin_{c \in \{c_1, \hdots, c_t\} \cap \cX} f(c_r) .$$
The following rate of convergence can be proved with the exact same argument than for Theorem \ref{th:centerofgravity} (observe that at step $t$ one can remove a point in $\cX$ from the current ellipsoid only if $c_t \in \cX$).

**Theorem**

For $t \geq 2n^2 \log(R/r)$ the ellipsoid method satisfies $\{c_1, \hdots, c_t\} \cap \cX \neq \emptyset$ and
$$f(x_t) - \min_{x \in \mathcal{X}} f(x) \leq \frac{2 B R}{r} \exp\left( - \frac{t}{2 n^2}\right) .$$

We observe that the oracle complexity of the ellipsoid method is much worse than the one of the center gravity method, indeed the former needs $O(n^2 \log(1/\epsilon))$ calls to the oracles while the latter requires only $O(n \log(1/\epsilon))$ calls. However from a computational point of view the situation is much better: in many cases one can derive an efficient separation oracle, while the center of gravity method is basically always intractable. This is for instance the case in the context of LPs and SDPs: with the notation of Section \ref{sec:structured} the computational complexity of the separation oracle for LPs is $O(m n)$ while for SDPs it is $O(\max(m,n) n^2)$ (we use the fact that the spectral decomposition of a matrix can be done in $O(n^3)$ operations). This gives an overall complexity of $O(\max(m,n) n^3 \log(1/\epsilon))$ for LPs and $O(\max(m,n^2) n^6 \log(1/\epsilon))$ for SDPs. We note however that the ellipsoid method is almost never used in practice, essentially because the method is too rigid to exploit the potential easiness of real problems (e.g., the volume decrease given by \eqref{eq:ellipsoidlemma2} is essentially always tight).