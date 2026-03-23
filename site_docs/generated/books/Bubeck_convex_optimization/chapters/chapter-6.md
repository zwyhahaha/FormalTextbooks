# Chapter 6 — Convex optimization and randomness

## Section 6.1 — Non-smooth stochastic optimization

### [Theorem 6.1](../results/theorem-6-1.md)

**Theorem**

Let $\Phi$ be a mirror map $1$-strongly convex on $\mathcal{X} \cap \mathcal{D}$ with respect to $\|\cdot\|$, and
let $R^2 = \sup_{x \in \mathcal{X} \cap \mathcal{D}} \Phi(x) - \Phi(x_1)$. Let $f$ be convex. Furthermore assume that the stochastic oracle is such that $\E \|\tg(x)\|_*^2 \leq B^2$. Then S-MD with $\eta = \frac{R}{B} \sqrt{\frac{2}{t}}$ satisfies

\[
\E f\bigg(\frac{1}{t} \sum_{s=1}^t x_s \bigg) - \min_{x \in \mathcal{X}} f(x) \leq R B \sqrt{\frac{2}{t}} .
\]

Similarly, in the Euclidean and strongly convex case, one can directly generalize Theorem \ref{th:LJSB12}. Precisely we consider stochastic gradient descent (SGD), that is S-MD with $\Phi(x) = \frac12 \|x\|_2^2$, with time-varying step size $(\eta_t)_{t \geq 1}$, that is

\[
x_{t+1} = \Pi_{\cX}(x_t - \eta_t \tg(x_t)) .
\]

### [Theorem 6.2](../results/theorem-6-2.md)

**Theorem**

Let $f$ be $\alpha$-strongly convex, and assume that the stochastic oracle is such that $\E \|\tg(x)\|_*^2 \leq B^2$. Then SGD with $\eta_s = \frac{2}{\alpha (s+1)}$ satisfies

\[
f \left(\sum_{s=1}^t \frac{2 s}{t(t+1)} x_s \right) - f(x^*) \leq \frac{2 B^2}{\alpha (t+1)} .
\]

## Section 6.2 — Smooth stochastic optimization and mini-batch SGD

### [Theorem 6.3](../results/theorem-6-3.md)

**Theorem**

Let $\Phi$ be a mirror map $1$-strongly convex on $\mathcal{X} \cap \mathcal{D}$ w.r.t. $\|\cdot\|$, and let $R^2 = \sup_{x \in \mathcal{X} \cap \mathcal{D}} \Phi(x) - \Phi(x_1)$. Let $f$ be convex and $\beta$-smooth w.r.t. $\|\cdot\|$. Furthermore assume that the stochastic oracle is such that $\E \|\nabla f(x) - \tg(x)\|_*^2 \leq \sigma^2$. Then S-MD with stepsize $\frac{1}{\beta + 1/\eta}$ and $\eta = \frac{R}{\sigma} \sqrt{\frac{2}{t}}$ satisfies

\[
\E f\bigg(\frac{1}{t} \sum_{s=1}^t x_{s+1} \bigg) - f(x^*) \leq R \sigma \sqrt{\frac{2}{t}} + \frac{\beta R^2}{t} .
\]

## Section 6.3 — Sum of smooth and strongly convex functions

### [Lemma 6.4](../results/lemma-6-4.md)

**Lemma**

Let $f_1, \hdots f_m$ be $\beta$-smooth convex functions on $\R^n$, and $i$ be a random variable uniformly distributed in $[m]$. Then

\[
\E \| \nabla f_i(x) - \nabla f_i(x^*) \|_2^2 \leq 2 \beta (f(x) - f(x^*)) .
\]

### [Theorem 6.5](../results/theorem-6-5.md)

**Theorem**

Let $f_1, \hdots f_m$ be $\beta$-smooth convex functions on $\R^n$ and $f$ be $\alpha$-strongly convex. Then SVRG with $\eta = \frac{1}{10\beta}$ and $k = 20 \kappa$ satisfies

\[
\E f(y^{(s+1)}) - f(x^*) \leq 0.9^s (f(y^{(1)}) - f(x^*)) .
\]

## Section 6.4 — Random coordinate descent

### [Theorem 6.6](../results/theorem-6-6.md)

**Theorem**

Let $f$ be convex and $L$-Lipschitz on $\R^n$, then RCD with $\eta = \frac{R}{L} \sqrt{\frac{2}{n t}}$ satisfies

\[
\E f\bigg(\frac{1}{t} \sum_{s=1}^t x_s \bigg) - \min_{x \in \mathcal{X}} f(x) \leq R L \sqrt{\frac{2 n}{t}} .
\]

Somewhat unsurprisingly RCD requires $n$ times more iterations than gradient descent to obtain the same accuracy. In the next section, we will see that this statement can be greatly improved by taking into account directional smoothness.

## Section 6.4.1 — RCD for coordinate-smooth optimization

### [Theorem 6.7](../results/theorem-6-7.md)

**Theorem**

Let $f$ be convex and such that $u \in \R \mapsto f(x + u e_i)$ is $\beta_i$-smooth for any $i \in [n], x \in \R^n$. Then RCD($\gamma$) satisfies for $t \geq 2$,

\[
\E f(x_{t}) - f(x^*) \leq \frac{2 R_{1 - \gamma}^2(x_1) \sum_{i=1}^n \beta_i^{\gamma}}{t-1} ,
\]

where

\[
R_{1-\gamma}(x_1) = \sup_{x \in \R^n : f(x) \leq f(x_1)} \|x - x^*\|_{[1-\gamma]} .
\]

Recall from Theorem \ref{th:gdsmooth} that in this context the basic gradient descent attains a rate of $\beta \|x_1 - x^*\|_2^2 / t$ where $\beta \leq \sum_{i=1}^n \beta_i$ (see the discussion above). Thus we see that RCD($1$) greatly improves upon gradient descent for functions where $\beta$ is of order of $\sum_{i=1}^n \beta_i$. Indeed in this case both methods attain the same accuracy after a fixed number of iterations, but the iterations of coordinate descent are potentially much cheaper than the iterations of gradient descent.

## Section 6.4.2 — RCD for smooth and strongly convex optimization

### [Theorem 6.8](../results/theorem-6-8.md)

**Theorem**

Let $\gamma \geq 0$. Let $f$ be $\alpha$-strongly convex w.r.t. $\|\cdot\|_{[1-\gamma]}$, and such that $u \in \R \mapsto f(x + u e_i)$ is $\beta_i$-smooth for any $i \in [n], x \in \R^n$. Let $\kappa_{\gamma} = \frac{\sum_{i=1}^n \beta_i^{\gamma}}{\alpha}$, then RCD($\gamma$) satisfies

\[
\E f(x_{t+1}) - f(x^*) \leq \left(1 - \frac1{\kappa_{\gamma}}\right)^t (f(x_1) - f(x^*)) .
\]

We use the following elementary lemma.

### [Lemma 6.9](../results/lemma-6-9.md)

**Lemma**

Let $f$ be $\alpha$-strongly convex w.r.t. $\| \cdot\|$ on $\R^n$, then

\[
f(x) - f(x^*) \leq \frac1{2\alpha} \|\nabla f(x)\|_*^2 .
\]

## Section 6.5 — Acceleration by randomization for saddle points

### [Theorem 6.10](../results/theorem-6-10.md)

**Theorem**

Assume that the stochastic oracle is such that $\E \left(\|\tg_{\cX}(x,y)\|_{\cX}^* \right)^2 \leq B_{\cX}^2$, and $\E \left(\|\tg_{\cY}(x,y)\|_{\cY}^* \right)^2 \leq B_{\cY}^2$. Then S-SP-MD with $a= \frac{B_{\cX}}{R_{\cX}}$, $b=\frac{B_{\cY}}{R_{\cY}}$, and $\eta=\sqrt{\frac{2}{t}}$ satisfies

\[
\E \left( \max_{y \in \mathcal{Y}} \phi\left( \frac1{t} \sum_{s=1}^t x_s,y \right) - \min_{x \in \mathcal{X}} \phi\left(x, \frac1{t} \sum_{s=1}^t y_s \right) \right) \leq (R_{\cX} B_{\cX} + R_{\cY} B_{\cY}) \sqrt{\frac{2}{t}}.
\]

Using S-SP-MD we revisit the examples of Section \ref{sec:spex2} and Section \ref{sec:spex3}. In both cases one has $\phi(x,y) = x^{\top} A y$ (with $A_i$ being the $i^{th}$ column of $A$), and thus $\nabla_x \phi(x,y) = Ay$ and $\nabla_y \phi(x,y) = A^{\top} x$.
\newline

\noindent
**Matrix games.** Here $x \in \Delta_n$ and $y \in \Delta_m$. Thus there is a quite natural stochastic oracle:

\tg_{\cX}(x,y) = A_I, \; \text{where} \; I \in [m] \; \text{is drawn according to} \; y \in \Delta_m ,

and $\forall i \in [m]$,

\tg_{\cY}(x,y)(i) = A_i(J), \; \text{where} \; J \in [n] \; \text{is drawn according to} \; x \in \Delta_n .

Clearly $\|\tg_{\cX}(x,y)\|_{\infty} \leq \|A\|_{\mathrm{max}}$ and $\|\tg_{\cX}(x,y)\|_{\infty} \leq \|A\|_{\mathrm{max}}$, which implies that S-SP-MD attains an $\epsilon$-optimal pair of points with $O\left(\|A\|_{\mathrm{max}}^2 \log(n+m) / \epsilon^2 \right)$ iterations. Furthermore the computational complexity of a step of S-SP-MD is dominated by drawing the indices $I$ and $J$ which takes $O(n + m)$. Thus overall the complexity of getting an $\epsilon$-optimal Nash equilibrium with S-SP-MD is $O\left(\|A\|_{\mathrm{max}}^2 (n + m) \log(n+m) / \epsilon^2  \right)$. While the dependency on $\epsilon$ is worse than for SP-MP (see Section \ref{sec:spex2}), the dependencies on the dimensions is $\tilde{O}(n+m)$ instead of $\tilde{O}(nm)$. In particular, quite astonishingly, this is {\em sublinear} in the size of the matrix $A$. The possibility of sublinear algorithms for this problem was first observed in \cite{GK95}.
\newline

\noindent
**Linear classification.** Here $x \in \mB_{2,n}$ and $y \in \Delta_m$. Thus the stochastic oracle for the $x$-subgradient can be taken as in \eqref{eq:oraclematrixgame} but for the $y$-subgradient we modify \eqref{eq:oraclematrixgame2} as follows. For a vector $x$ we denote by $x^2$ the vector such that $x^2(i) = x(i)^2$. For all $i \in [m]$,

\[
\tg_{\cY}(x,y)(i) = \frac{\|x\|^2}{x(j)} A_i(J), \; \text{where} \; J \in [n] \; \text{is drawn according to} \; \frac{x^2}{\|x\|_2^2} \in \Delta_n .
\]
 
Note that one indeed has $\E (\tg_{\cY}(x,y)(i) | x,y) = \sum_{j=1}^n x(j) A_i(j) = (A^{\top} x)(i)$.
Furthermore $\|\tg_{\cX}(x,y)\|_2 \leq B$, and

\[
\E (\|\tg_{\cY}(x,y)\|_{\infty}^2 | x,y) = \sum_{j=1}^n \frac{x(j)^2}{\|x\|_2^2} \max_{i \in [m]} \left(\frac{\|x\|^2}{x(j)} A_i(j)\right)^2 \leq \sum_{j=1}^n \max_{i \in [m]} A_i(j)^2 .
\]

Unfortunately this last term can be $O(n)$. However it turns out that one can do a more careful analysis of mirror descent in terms of local norms, which allows to prove that the ``local variance" is dimension-free. We refer to \cite{BC12} for more details on these local norms, and to \cite{CHW12} for the specific details in the linear classification situation.

## Section 6.6 — Convex relaxation and randomized rounding

### [Theorem 6.11](../results/theorem-6-11.md)

**Theorem**

Let $\Sigma$ be the solution to the SDP relaxation of $\mathrm{MAXCUT}$. Let $\xi \sim \cN(0, \Sigma)$ and $\zeta = \mathrm{sign}(\xi) \in \{-1,1\}^n$. Then

\[
\E \ \zeta^{\top} L \zeta \geq 0.878 \max_{x \in \{-1,1\}^n} x^{\top} L x .
\]

The proof of this result is based on the following elementary geometric lemma.

### [Lemma 6.12](../results/lemma-6-12.md)

**Lemma**

Let $\xi \sim \mathcal{N}(0,\Sigma)$ with $\Sigma_{i,i}=1$ for $i \in [n]$, and $\zeta = \mathrm{sign}(\xi)$. Then

\[
\E \ \zeta_i \zeta_j = \frac{2}{\pi} \mathrm{arcsin} \left(\Sigma_{i,j}\right) .
\]

### [Theorem 6.13](../results/theorem-6-13.md)

**Theorem**

Let $\Sigma$ be the solution to the SDP relaxation of \eqref{eq:quad}. Let $\xi \sim \cN(0, \Sigma)$ and $\zeta = \mathrm{sign}(\xi) \in \{-1,1\}^n$. Then

\[
\E \ \zeta^{\top} B \zeta \geq \frac{2}{\pi} \max_{x \in \{-1,1\}^n} x^{\top} B x .
\]

## Section 6.7 — Random walk based methods

### [Lemma 6.14](../results/lemma-6-14.md)

**Lemma**

Let $\cK$ be a convex set in isotropic position. Then for any $w \in \R^n, w \neq 0$, $z \in \R^n$, one has

\[
\mathrm{Vol} \left( \cK \cap \{x \in \R^n : (x-z)^{\top} w \geq 0\} \right) \geq \left(\frac{1}{e} - \|z\|_2\right) \mathrm{Vol} (\cK) .
\]

Thus if one can ensure that $\cS_t$ is in (near) isotropic position, and $\|c_t - \hat{c}_t\|_2$ is small (say smaller than $0.1$), then the randomized center of gravity method (which replaces $c_t$ by $\hat{c}_t$) will converge at the same speed than the original center of gravity method. 

Assuming that $\cS_t$ is in isotropic position one immediately obtains $\E \|c_t - \hat{c}_t\|_2^2 = \frac{n}{N}$, and thus by Chebyshev's inequality one has $\P(\|c_t - \hat{c}_t\|_2 > 0.1) \leq 100 \frac{n}{N}$. In other words with $N = O(n)$ one can ensure that the randomized center of gravity method makes progress on a constant fraction of the iterations (to ensure progress at every step one would need a larger value of $N$ because of an union bound, but this is unnecessary).

Let us now consider the issue of putting $\cS_t$ in near-isotropic position. Let $\hat{\Sigma}_t = \frac1{N} \sum_{i=1}^N (X_i-\hat{c}_t) (X_i-\hat{c}_t)^{\top}$. \cite{Rud99} showed that as long as $N= \tilde{\Omega}(n)$, one has with high probability (say at least probability $1-1/n^2$) that the set $\hat{\Sigma}_t^{-1/2} (\cS_t - \hat{c}_t)$ is in near-isotropic position.

Thus it only remains to explain how to sample from a near-isotropic convex set $\cK$. This is where random walk ideas come into the picture. The hit-and-run walk.} is described as follows: at a point $x \in \cK$, let $\cL$ be a line that goes through $x$ in a direction taken uniformly at random, then move to a point chosen uniformly at random in $\cL \cap \cK$. \cite{Lov98} showed that if the starting point of the hit-and-run walk is chosen from a distribution ``close enough" to the uniform distribution on $\cK$, then after $O(n^3)$ steps the distribution of the last point is $\epsilon$ away (in total variation) from the uniform distribution on $\cK$. In the randomized center of gravity method one can obtain a good initial distribution for $\cS_t$ by using the distribution that was obtained for $\cS_{t-1}$. In order to initialize the entire process correctly we start here with $\cS_1 = [-L, L]^n \supset \cX$ (in Section \ref{sec:gravity} we used $\cS_1 = \cX$), and thus we also have to use a {\em separation oracle} at iterations where $\hat{c}_t \not\in \cX$, just like we did for the ellipsoid method (see Section \ref{sec:ellipsoid}).

Wrapping up the above discussion, we showed (informally) that to attain an $\epsilon$-optimal point with the randomized center of gravity method one needs: $\tilde{O}(n)$ iterations, each iterations requires $\tilde{O}(n)$ random samples from $\cS_t$ (in order to put it in isotropic position) as well as a call to either the separation oracle or the first order oracle, and each sample costs $\tilde{O}(n^3)$ steps of the random walk. Thus overall one needs $\tilde{O}(n)$ calls to the separation oracle and the first order oracle, as well as $\tilde{O}(n^5)$ steps of the random walk.
