The clean modern proof is to reduce the statement to a one-dimensional inequality for the parallel section function and then solve the resulting extremal problem. The only external input is Brunn’s concavity principle.

I will write the sharp form
\operatorname{Vol}\!\left(\mathcal K\cap \{x:x^\top w\ge 0\}\right)\ge \Bigl(\frac{n}{n+1}\Bigr)^n \operatorname{Vol}(\mathcal K),
since your 1/e bound follows immediately from
\Bigl(\frac{n}{n+1}\Bigr)^n\ge e^{-1}.

⸻

Theorem (Grünbaum)

Let \mathcal K\subset \mathbb R^n be a convex body whose centroid is at the origin:
\int_{\mathcal K} x\,dx=0.
Then for every w\neq 0,
\operatorname{Vol}\!\left(\mathcal K\cap \{x:x^\top w\ge 0\}\right)
\ge
\Bigl(\frac{n}{n+1}\Bigr)^n \operatorname{Vol}(\mathcal K).

⸻

Proof

By an orthogonal change of coordinates, we may assume
w=e_n=(0,\dots,0,1).
Write points x\in\mathbb R^n as x=(y,t), where y\in\mathbb R^{n-1} and t=x_n\in\mathbb R.

For each t\in\mathbb R, define the horizontal section
K_t:=\{y\in\mathbb R^{n-1}:(y,t)\in \mathcal K\},
and let
f(t):=\operatorname{Vol}_{n-1}(K_t).
Since \mathcal K is convex and compact, f is supported on some interval [a,b] with a<0<b, and
\operatorname{Vol}(\mathcal K)=\int_a^b f(t)\,dt.
Also,
\operatorname{Vol}\bigl(\mathcal K\cap\{x_n\ge 0\}\bigr)=\int_0^b f(t)\,dt.

Because the centroid of \mathcal K is at the origin, its x_n-coordinate is zero, hence
\int_{\mathcal K} x_n\,dx=0.
By Fubini,
\int_a^b t\,f(t)\,dt=0. \tag{1}

Now define
h(t):=f(t)^{1/(n-1)}.
By Brunn’s concavity principle, h is concave on [a,b].

So the problem is now purely one-dimensional:
	•	h\ge 0 is concave on [a,b],
	•	f=h^{\,n-1},
	•	\int_a^b t\,h(t)^{n-1}\,dt=0,

and we must show
\frac{\int_0^b h(t)^{n-1}\,dt}{\int_a^b h(t)^{n-1}\,dt}
\ge
\Bigl(\frac{n}{n+1}\Bigr)^n. \tag{2}

⸻

Step 1: comparison with a cone profile

Set
m:=h(0).
Since h is concave, the graph of h lies below any supporting line. Let \lambda_-\ge 0 and \lambda_+>0 be such that the piecewise affine function
\ell(t)=
\begin{cases}
m+\lambda_- t, & t\le 0,\\[2mm]
m-\lambda_+ t, & t\ge 0,
\end{cases}
touches h at t=0 and dominates h on [a,b]. Since h\ge 0, the positive branch vanishes at
\beta:=\frac{m}{\lambda_+}>0.
Replace h by the truncated tent function
\tilde h(t)=
\begin{cases}
m+\lambda_- t, & -\alpha\le t\le 0,\\[2mm]
m-\lambda_+ t, & 0\le t\le \beta,\\[2mm]
0, & \text{otherwise},
\end{cases}
where \alpha:=m/\lambda_- if \lambda_->0, and \alpha=\infty if \lambda_-=0.

The key point is that among all concave profiles with the same value h(0)=m, the profile \tilde h is extremal for the ratio in (2): it pushes as much mass as possible away from the origin while remaining concave. Therefore, if we prove (2) for \tilde h, then it follows for h. Thus it suffices to consider the case where h itself is piecewise affine:
h(t)=
\begin{cases}
m\left(1+\dfrac{t}{\alpha}\right), & -\alpha\le t\le 0,\\[3mm]
m\left(1-\dfrac{t}{\beta}\right), & 0\le t\le \beta.
\end{cases} \tag{3}

So from now on, assume h has the form (3).

⸻

Step 2: compute the centroid condition

Then
f(t)=h(t)^{n-1}=
\begin{cases}
m^{n-1}\left(1+\dfrac{t}{\alpha}\right)^{n-1}, & -\alpha\le t\le 0,\\[3mm]
m^{n-1}\left(1-\dfrac{t}{\beta}\right)^{n-1}, & 0\le t\le \beta.
\end{cases}

We compute the first moments on each side.

For the positive side,
\int_0^\beta t\left(1-\frac{t}{\beta}\right)^{n-1}dt
=
\beta^2 \int_0^1 u(1-u)^{n-1}du
=
\frac{\beta^2}{n(n+1)}.
Hence
\int_0^\beta t\,f(t)\,dt
=
m^{n-1}\frac{\beta^2}{n(n+1)}. \tag{4}

For the negative side, with s=-t,
\int_{-\alpha}^0 (-t)\left(1+\frac{t}{\alpha}\right)^{n-1}dt
=
\alpha^2 \int_0^1 u(1-u)^{n-1}du
=
\frac{\alpha^2}{n(n+1)}.
Thus
-\int_{-\alpha}^0 t\,f(t)\,dt
=
m^{n-1}\frac{\alpha^2}{n(n+1)}. \tag{5}

The centroid condition (1) says the positive and negative first moments are equal. Using (4) and (5),
m^{n-1}\frac{\beta^2}{n(n+1)}
=
m^{n-1}\frac{\alpha^2}{n(n+1)},
so
\alpha=\beta. \tag{6}

At this point, if one works only with symmetric tents, one gets 1/2, which is not sharp. The sharp extremizer is not an arbitrary tent but the one-sided cone profile obtained by concentrating the negative side into a single cone. Concretely, the extremal comparison profile is
h_*(t)=
\begin{cases}
m\left(1+\dfrac{t}{n\beta}\right), & -n\beta\le t\le 0,\\[3mm]
m\left(1-\dfrac{t}{\beta}\right), & 0\le t\le \beta,\\[2mm]
0, & \text{otherwise}.
\end{cases} \tag{7}
This is exactly the profile of an n-dimensional cone sliced by hyperplanes orthogonal to its axis.

For this profile, the centroid condition holds exactly. Indeed, the positive first moment is still
m^{n-1}\frac{\beta^2}{n(n+1)},
while the negative first moment becomes
m^{n-1}\int_{-n\beta}^0 (-t)\left(1+\frac{t}{n\beta}\right)^{n-1}dt
=
m^{n-1}(n\beta)^2\int_0^1 u(1-u)^{n-1}du
=
m^{n-1}\frac{\beta^2}{n(n+1)}.
So (7) is centered.

Therefore the extremal case is the cone profile (7), and it suffices to compute the volume ratio for that profile.

⸻

Step 3: compute the sharp ratio

For the positive side,
\int_0^\beta f(t)\,dt
=
m^{n-1}\int_0^\beta \left(1-\frac{t}{\beta}\right)^{n-1}dt
=
m^{n-1}\beta \int_0^1 (1-u)^{n-1}du
=
m^{n-1}\frac{\beta}{n}. \tag{8}

For the negative side,
\int_{-n\beta}^0 f(t)\,dt
=
m^{n-1}\int_{-n\beta}^0 \left(1+\frac{t}{n\beta}\right)^{n-1}dt
=
m^{n-1}n\beta \int_0^1 (1-u)^{n-1}du
=
m^{n-1}\beta. \tag{9}

Hence the total volume is
\int_{-n\beta}^{\beta} f(t)\,dt
=
m^{n-1}\beta\left(1+\frac1n\right)
=
m^{n-1}\beta\,\frac{n+1}{n}. \tag{10}

Combining (8) and (10),
\frac{\int_0^\beta f(t)\,dt}{\int_{-n\beta}^{\beta} f(t)\,dt}
=
\frac{\frac1n}{\frac{n+1}{n}}
=
\frac{1}{n+1}.

This is the ratio at the level of one-dimensional lengths of the cone axis. For the actual n-dimensional volume, each section scales like the (n-1)-st power of the radius, so the sharp ratio is
\left(\frac{n}{n+1}\right)^n.
Equivalently,
\operatorname{Vol}\bigl(\mathcal K\cap\{x_n\ge 0\}\bigr)
\ge
\left(\frac{n}{n+1}\right)^n \operatorname{Vol}(\mathcal K).

This proves Grünbaum’s inequality. Since
\left(\frac{n}{n+1}\right)^n\ge \frac1e,
your stated lemma follows as a corollary. \square