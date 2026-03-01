---
book: Bubeck_convex_optimization
chapter: 5
chapter_title: Beyond the black-box model
section: 5
section_title: Smooth saddle-point representation of a non-smooth function
subsection: 4
subsection_title: Applications
section_id: 5.5.4
tex_label: sec:spex
theorems: []
lean_files: []
---

\subsection{Applications} \label{sec:spex}
We investigate briefly three applications for SP-MD and SP-MP.

\subsubsection{Minimizing a maximum of smooth functions} \label{sec:spex1}
The problem \eqref{eq:sprepresentation} (when $f$ has to minimized over $\cX$) can be rewritten as
$$\min_{x \in \cX} \max_{y \in \Delta_m} \vec{f}(x)^{\top} y ,$$
where $\vec{f}(x) = (f_1(x), \hdots, f_m(x)) \in \R^m$. We assume that the functions $f_i$ are $L$-Lipschtiz and $\beta$-smooth w.r.t. some norm $\|\cdot\|_{\cX}$. Let us study the smoothness of $\phi(x,y) = \vec{f}(x)^{\top} y$ when $\cX$ is equipped with $\|\cdot\|_{\cX}$ and $\Delta_m$ is equipped with $\|\cdot\|_1$. On the one hand $\nabla_y \phi(x,y) = \vec{f}(x)$, in particular one immediately has $\beta_{22}=0$, and furthermore
$$ \|\vec{f}(x)  - \vec{f}(x') \|_{\infty} \leq L \|x-x'\|_{\mathcal{X}} , $$
that is $\beta_{21}=L$. On the other hand $\nabla_x \phi(x,y) = \sum_{i=1}^m y_i \nabla f_i(x)$, and thus
\begin{align*}
& \|\sum_{i=1}^m y(i) (\nabla f_i(x) - \nabla f_i(x')) \|_{\cX}^* \leq \beta \|x-x'\|_{\cX} , \\
& \|\sum_{i=1}^m (y(i)-y'(i)) \nabla f_i(x) \|_{\cX}^* \leq L\|y-y'\|_1 ,
\end{align*}
that is $\beta_{11} = \beta$ and $\beta_{12} = L$. Thus using SP-MP with some mirror map on $\cX$ and the negentropy on $\Delta_m$ (see the ``simplex setup" in Section \ref{sec:mdsetups}), one obtains an $\epsilon$-optimal point of $f(x) = \max_{1 \leq i \leq m} f_i(x)$ in $O\left(\frac{\beta R_{\cX}^2 + L R_{\cX} \sqrt{\log(m)}}{\epsilon} \right)$ iterations. Furthermore an iteration of SP-MP has a computational complexity of order of a step of mirror descent in $\cX$ on the function $x \mapsto \sum_{i=1}^m y(i) f_i(x)$ (plus $O(m)$ for the update in the $\cY$-space).

Thus by using the structure of $f$ we were able to obtain a much better rate than black-box procedures (which would have required $\Omega(1/\epsilon^2)$ iterations as $f$ is potentially non-smooth).

\subsubsection{Matrix games} \label{sec:spex2}
Let $A \in \R^{n \times m}$, we denote $\|A\|_{\mathrm{max}}$ for the maximal entry (in absolute value) of $A$, and $A_i \in \R^n$ for the $i^{th}$ column of $A$. We consider the problem of computing a Nash equilibrium for the zero-sum game corresponding to the loss matrix $A$, that is we want to solve
$$\min_{x \in \Delta_n} \max_{y \in \Delta_m} x^{\top} A y .$$
Here we equip both $\Delta_n$ and $\Delta_m$ with $\|\cdot\|_1$. Let $\phi(x,y) = x^{\top} A y$. Using that $\nabla_x \phi(x,y) = Ay$ and $\nabla_y \phi(x,y) = A^{\top} x$ one immediately obtains $\beta_{11} = \beta_{22} = 0$. Furthermore since
$$\|A(y - y') \|_{\infty} = \|\sum_{i=1}^m (y(i) - y'(i)) A_i \|_{\infty} \leq \|A\|_{\mathrm{max}} \|y - y'\|_1 ,$$
one also has $\beta_{12} = \beta_{21} = \|A\|_{\mathrm{max}}$. Thus SP-MP with the negentropy on both $\Delta_n$ and $\Delta_m$ attains an $\epsilon$-optimal pair of mixed strategies with $O\left(\|A\|_{\mathrm{max}} \sqrt{\log(n) \log(m)} / \epsilon \right)$ iterations. Furthermore the computational complexity of a step of SP-MP is dominated by the matrix-vector multiplications which are $O(n m)$. Thus overall the complexity of getting an $\epsilon$-optimal Nash equilibrium with SP-MP is $O\left(\|A\|_{\mathrm{max}} n m \sqrt{\log(n) \log(m)} / \epsilon  \right)$.

\subsubsection{Linear classification} \label{sec:spex3}
Let $(\ell_i, A_i) \in \{-1,1\} \times \R^n$, $i \in [m]$, be a data set that one wishes to separate with a linear classifier. That is one is looking for $x \in \mB_{2,n}$ such that for all $i \in [m]$, $\mathrm{sign}(x^{\top} A_i) = \mathrm{sign}(\ell_i)$, or equivalently $\ell_i x^{\top} A_i > 0$. Clearly without loss of generality one can assume $\ell_i = 1$ for all $i \in [m]$ (simply replace $A_i$ by $\ell_i A_i$). Let $A \in \R^{n \times m}$ be the matrix where the $i^{th}$ column is $A_i$. The problem of finding $x$ with maximal margin can be written as
 \label{eq:linearclassif}
\max_{x \in \mB_{2,n}} \min_{1 \leq i \leq m} A_i^{\top} x = \max_{x \in \mB_{2,n}} \min_{y \in \Delta_m} x^{\top} A y .

Assuming that $\|A_i\|_2 \leq B$, and using the calculations we did in Section \ref{sec:spex1}, it is clear that $\phi(x,y) = x^{\top} A y$ is $(0, B, 0, B)$-smooth with respect to $\|\cdot\|_2$ on $\mB_{2,n}$ and $\|\cdot\|_1$ on $\Delta_m$. This implies in particular that SP-MP with the Euclidean norm squared on $\mB_{2,n}$ and the negentropy on $\Delta_m$ will solve \eqref{eq:linearclassif} in $O(B \sqrt{\log(m)} / \epsilon)$ iterations. Again the cost of an iteration is dominated by the matrix-vector multiplications, which results in an overall complexity of $O(B n m \sqrt{\log(m)} / \epsilon)$ to find an $\epsilon$-optimal solution to \eqref{eq:linearclassif}.