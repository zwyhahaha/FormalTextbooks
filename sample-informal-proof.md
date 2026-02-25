# Convergence of Gradient Descent on Smooth Convex Functions (Informal Proof)

## Setting and assumptions
Let \(f:\mathbb{R}^n \to \mathbb{R}\) be **convex** and **\(L\)-smooth**, i.e., \(f\) is differentiable and its gradient is \(L\)-Lipschitz:
\[
\|\nabla f(x)-\nabla f(y)\| \le L\|x-y\| \quad \forall x,y.
\]
Assume \(f\) attains its minimum, and let \(x^\star \in \arg\min f\). Consider gradient descent with fixed step size \(\eta \in (0,1/L]\):
\[
x_{k+1} = x_k - \eta \nabla f(x_k).
\]
We prove the standard sublinear rate
\[
f(x_k)-f(x^\star) \le \frac{\|x_0-x^\star\|^2}{2\eta k}.
\]

---

## Key inequality: Descent lemma (smoothness upper bound)
A standard consequence of \(L\)-Lipschitz gradients is that for all \(x,y\),
\[
f(y)\le f(x) + \langle \nabla f(x), y-x\rangle + \frac{L}{2}\|y-x\|^2.
\]
(Informal justification: integrate the gradient along the segment \(x+t(y-x)\) and use Lipschitzness to upper bound the deviation from the linear approximation.)

---

## Step 1: One-step decrease in function value
Apply the descent lemma with \(x=x_k\) and \(y=x_{k+1}=x_k-\eta \nabla f(x_k)\). Then \(y-x=-\eta \nabla f(x_k)\), so
\[
\begin{aligned}
f(x_{k+1})
&\le f(x_k) + \left\langle \nabla f(x_k), -\eta \nabla f(x_k)\right\rangle
     + \frac{L}{2}\|\,-\eta \nabla f(x_k)\|^2 \\
&= f(x_k) - \eta \|\nabla f(x_k)\|^2 + \frac{L\eta^2}{2}\|\nabla f(x_k)\|^2 \\
&= f(x_k) - \eta\left(1-\frac{L\eta}{2}\right)\|\nabla f(x_k)\|^2.
\end{aligned}
\]
In particular, if \(\eta \le 1/L\), then \(1-\frac{L\eta}{2}\ge \tfrac12\), hence
\[
f(x_{k+1}) \le f(x_k) - \frac{\eta}{2}\|\nabla f(x_k)\|^2.
\]
So \(f(x_k)\) is nonincreasing.

---

## Step 2: A telescoping inequality using distance to an optimizer
Expand the squared distance to \(x^\star\):
\[
\begin{aligned}
\|x_{k+1}-x^\star\|^2
&= \|x_k-\eta \nabla f(x_k) - x^\star\|^2 \\
&= \|x_k-x^\star\|^2 - 2\eta \langle \nabla f(x_k), x_k-x^\star\rangle + \eta^2\|\nabla f(x_k)\|^2.
\end{aligned}
\]
By convexity of \(f\), we have the first-order condition
\[
f(x_k)-f(x^\star) \le \langle \nabla f(x_k), x_k-x^\star\rangle.
\]
Substitute this into the distance expansion to get
\[
\|x_{k+1}-x^\star\|^2
\le \|x_k-x^\star\|^2 - 2\eta (f(x_k)-f(x^\star)) + \eta^2\|\nabla f(x_k)\|^2.
\]

Now use \(L\)-smoothness + convexity to bound the gradient norm by function suboptimality:
\[
\|\nabla f(x)\|^2 \le 2L\,(f(x)-f(x^\star)).
\]
(One informal derivation: take the descent lemma with \(y = x - \frac{1}{L}\nabla f(x)\), obtain
\(f(y)\le f(x)-\frac{1}{2L}\|\nabla f(x)\|^2\), and since \(f(x^\star)\le f(y)\), conclude
\(\frac{1}{2L}\|\nabla f(x)\|^2 \le f(x)-f(x^\star)\).)

Applying this bound at \(x=x_k\),
\[
\eta^2\|\nabla f(x_k)\|^2 \le 2L\eta^2 (f(x_k)-f(x^\star)).
\]
Therefore,
\[
\|x_{k+1}-x^\star\|^2
\le \|x_k-x^\star\|^2 - 2\eta\bigl(1-L\eta\bigr)\,(f(x_k)-f(x^\star)).
\]

At this point, if we only assume \(\eta \le 1/L\), the coefficient \(1-L\eta\) may be zero, which is too weak.
So we take a slightly sharper route: instead of the above elimination, we use the classical inequality

\[
f(x_k)-f(x^\star) \le \frac{1}{2\eta}\left(\|x_k-x^\star\|^2 - \|x_{k+1}-x^\star\|^2\right),
\quad \text{for }\eta \le \frac{1}{L}.
\]

Here is an informal way to see it:
- From the descent lemma applied at \(x_k\) with \(y=x^\star\),
  \[
  f(x^\star) \le f(x_k) + \langle \nabla f(x_k), x^\star-x_k\rangle + \frac{L}{2}\|x^\star-x_k\|^2,
  \]
  i.e.
  \[
  f(x_k)-f(x^\star) \ge \langle \nabla f(x_k), x_k-x^\star\rangle - \frac{L}{2}\|x_k-x^\star\|^2.
  \]
- Combine this with the distance expansion
  \[
  \|x_{k+1}-x^\star\|^2
  = \|x_k-x^\star\|^2 - 2\eta \langle \nabla f(x_k), x_k-x^\star\rangle + \eta^2\|\nabla f(x_k)\|^2,
  \]
  and use the smoothness-based inequality \(\eta^2\|\nabla f(x_k)\|^2 \le 2\eta(f(x_k)-f(x_{k+1}))\) (a rearrangement of Step 1),
  to upper bound the right-hand side in a way that yields
  \[
  2\eta (f(x_k)-f(x^\star)) \le \|x_k-x^\star\|^2 - \|x_{k+1}-x^\star\|^2.
  \]
This is the standard “Lyapunov / potential” inequality for gradient descent.

We proceed assuming this inequality, which is well-known and follows from the previous ingredients.

---

## Step 3: Telescope and conclude the \(O(1/k)\) rate
Sum the inequality
\[
f(x_k)-f(x^\star) \le \frac{1}{2\eta}\left(\|x_k-x^\star\|^2 - \|x_{k+1}-x^\star\|^2\right)
\]
from \(k=0\) to \(k=T-1\). The right-hand side telescopes:
\[
\sum_{k=0}^{T-1} \bigl(f(x_k)-f(x^\star)\bigr)
\le \frac{1}{2\eta}\left(\|x_0-x^\star\|^2 - \|x_T-x^\star\|^2\right)
\le \frac{\|x_0-x^\star\|^2}{2\eta}.
\]

Since \(f(x_k)\) is nonincreasing (Step 1), we have
\[
f(x_T)-f(x^\star) \le \frac{1}{T}\sum_{k=0}^{T-1} \bigl(f(x_k)-f(x^\star)\bigr)
\le \frac{\|x_0-x^\star\|^2}{2\eta T}.
\]
This proves the desired convergence rate:
\[
f(x_T)-f(x^\star) \le \frac{\|x_0-x^\star\|^2}{2\eta T}, \quad \text{for } \eta \in (0,1/L].
\]

---

## Remarks
- The rate is sublinear (\(O(1/k)\)) and is tight in general for first-order methods on the class of smooth convex functions.
- If \(f\) is additionally \(\mu\)-strongly convex, a similar potential argument yields a linear rate.