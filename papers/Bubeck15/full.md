Foundations and Trends R(cid:13) in Machine Learning
Vol. 8, No. 3-4 (2015) 231–357
c(cid:13) 2015 S. Bubeck

DOI: 10.1561/2200000050

Convex Optimization: Algorithms and
Complexity

Sébastien Bubeck
Theory Group, Microsoft Research
sebubeck@microsoft.com

Contents

1 Introduction

232
1.1 Some convex optimization problems in machine learning . 233
1.2 Basic properties of convexity . . . . . . . . . . . . . . . . 234
1.3 Why convexity? . . . . . . . . . . . . . . . . . . . . . . . 237
1.4 Black-box model . . . . . . . . . . . . . . . . . . . . . . . 238
1.5 Structured optimization . . . . . . . . . . . . . . . . . . . 240
. . . . . . . . . . . 240
## 1.6 Overview of the results and disclaimer

2 Convex optimization in ﬁnite dimension

244
2.1 The center of gravity method . . . . . . . . . . . . . . . . 245
2.2 The ellipsoid method . . . . . . . . . . . . . . . . . . . . 247
2.3 Vaidya’s cutting plane method . . . . . . . . . . . . . . . 250
. . . . . . . . . . . . . . . . . . . . . 258
## 2.4 Conjugate gradient

3 Dimension-free convex optimization

262
3.1 Projected subgradient descent for Lipschitz functions . . . 263
3.2 Gradient descent for smooth functions . . . . . . . . . . . 266
3.3 Conditional gradient descent, aka Frank-Wolfe . . . . . . . 271
3.4 Strong convexity . . . . . . . . . . . . . . . . . . . . . . . 276
## 3.5 Lower bounds
. . . . . . . . . . . . . . . . . . . . . . . . 279
3.6 Geometric descent . . . . . . . . . . . . . . . . . . . . . . 284

ii

iii

## 3.7 Nesterov’s accelerated gradient descent

. . . . . . . . . . 289

4 Almost dimension-free convex optimization in non-Euclidean

spaces
296
4.1 Mirror maps . . . . . . . . . . . . . . . . . . . . . . . . . 298
4.2 Mirror descent . . . . . . . . . . . . . . . . . . . . . . . . 299
4.3 Standard setups for mirror descent . . . . . . . . . . . . . 301
4.4 Lazy mirror descent, aka Nesterov’s dual averaging . . . . 303
4.5 Mirror prox . . . . . . . . . . . . . . . . . . . . . . . . . . 305
4.6 The vector ﬁeld point of view on MD, DA, and MP . . . . 307

5 Beyond the black-box model

309
5.1 Sum of a smooth and a simple non-smooth term . . . . . 310
5.2 Smooth saddle-point representation of a non-smooth function312
Interior point methods . . . . . . . . . . . . . . . . . . . . 318
5.3

6 Convex optimization and randomness

329
6.1 Non-smooth stochastic optimization . . . . . . . . . . . . 330
6.2 Smooth stochastic optimization and mini-batch SGD . . . 332
6.3 Sum of smooth and strongly convex functions . . . . . . . 334
6.4 Random coordinate descent . . . . . . . . . . . . . . . . . 338
6.5 Acceleration by randomization for saddle points . . . . . . 342
6.6 Convex relaxation and randomized rounding . . . . . . . . 343
6.7 Random walk based methods . . . . . . . . . . . . . . . . 347

Acknowledgements

References

350

351

Abstract

This monograph presents the main complexity theorems in convex op-
timization and their corresponding algorithms. Starting from the fun-
damental theory of black-box optimization, the material progresses to-
wards recent advances in structural optimization and stochastic op-
timization. Our presentation of black-box optimization, strongly in-
ﬂuenced by Nesterov’s seminal book and Nemirovski’s lecture notes,
includes the analysis of cutting plane methods, as well as (acceler-
ated) gradient descent schemes. We also pay special attention to non-
Euclidean settings (relevant algorithms include Frank-Wolfe, mirror
descent, and dual averaging) and discuss their relevance in machine
learning. We provide a gentle introduction to structural optimization
with FISTA (to optimize a sum of a smooth and a simple non-smooth
term), saddle-point mirror prox (Nemirovski’s alternative to Nesterov’s
smoothing), and a concise description of interior point methods. In
stochastic optimization we discuss stochastic gradient descent, mini-
batches, random coordinate descent, and sublinear algorithms. We also
brieﬂy touch upon convex relaxation of combinatorial problems and the
use of randomness to round solutions, as well as random walks based
methods.

S. Bubeck. Convex Optimization: Algorithms and Complexity. Foundations and
Trends R(cid:13) in Machine Learning, vol. 8, no. 3-4, pp. 231–357, 2015.
DOI: 10.1561/2200000050.

1

Introduction

The central objects of our study are convex functions and convex sets
in Rn.

Deﬁnition 1.1 (Convex sets and convex functions). A set X ⊂ Rn is
said to be convex if it contains all of its segments, that is

∀(x, y, γ) ∈ X × X × [0, 1], (1 − γ)x + γy ∈ X .

A function f : X → R is said to be convex if it always lies below its
chords, that is

∀(x, y, γ) ∈ X × X × [0, 1], f ((1 − γ)x + γy) ≤ (1 − γ)f (x) + γf (y).

We are interested in algorithms that take as input a convex set X
and a convex function f and output an approximate minimum of f
over X . We write compactly the problem of ﬁnding the minimum of f
over X as

min. f (x)

s.t. x ∈ X .

In the following we will make more precise how the set of constraints X
and the objective function f are speciﬁed to the algorithm. Before that

232

## 1.1 Some convex optimization problems in machine learning


we proceed to give a few important examples of convex optimization
problems in machine learning.

## 1.1 Some convex optimization problems in machine learning

Many fundamental convex optimization problems in machine learning
take the following form:

min.
x∈Rn

m
X

i=1

fi(x) + λR(x),

(1.1)

where the functions f1, . . . , fm, R are convex and λ ≥ 0 is a ﬁxed
parameter. The interpretation is that fi(x) represents the cost of using
x on the ith element of some data set, and R(x) is a regularization term
which enforces some “simplicity” in x. We discuss now major instances
of (1.1). In all cases one has a data set of the form (wi, yi) ∈ Rn ×Y, i =
1, . . . , m and the cost function fi depends only on the pair (wi, yi). We
refer to Hastie et al. [2001], Schölkopf and Smola [2002], Shalev-Shwartz
and Ben-David [2014] for more details on the origin of these important
problems. The mere objective of this section is to expose the reader to a
few concrete convex optimization problems which are routinely solved.
In classiﬁcation one has Y = {−1, 1}. Taking fi(x) = max(0, 1 −
yix>wi) (the so-called hinge loss) and R(x) = kxk2
2 one obtains the
SVM problem. On the other hand taking fi(x) = log(1+exp(−yix>wi))
(the logistic loss) and again R(x) = kxk2
2 one obtains the (regularized)
logistic regression problem.

In regression one has Y = R. Taking fi(x) = (x>wi − yi)2 and
R(x) = 0 one obtains the vanilla least-squares problem which can be
rewritten in vector notation as

min.
x∈Rn

kW x − Y k2
2,

where W ∈ Rm×n is the matrix with w>
i on the ith row and Y =
(y1, . . . , yn)>. With R(x) = kxk2
2 one obtains the ridge regression prob-
lem, while with R(x) = kxk1 this is the LASSO problem Tibshirani
[1996].

Our last two examples are of a slightly diﬀerent ﬂavor. In particular
the design variable x is now best viewed as a matrix, and thus we

234

Introduction

denote it by a capital letter X. The sparse inverse covariance estimation
problem can be written as follows, given some empirical covariance
matrix Y ,

min. Tr(XY ) − logdet(X) + λkXk1
s.t. X ∈ Rn×n, X > = X, X (cid:23) 0.

Intuitively the above problem is simply a regularized maximum likeli-
hood estimator (under a Gaussian assumption).

Finally we introduce the convex version of the matrix completion
problem. Here our data set consists of observations of some of the
entries of an unknown matrix Y , and we want to “complete" the unob-
served entries of Y in such a way that the resulting matrix is “simple"
(in the sense that it has low rank). After some massaging (see Can-
dès and Recht [2009]) the (convex) matrix completion problem can be
formulated as follows:

min. Tr(X)
s.t. X ∈ Rn×n, X > = X, X (cid:23) 0, Xi,j = Yi,j for (i, j) ∈ Ω,

where Ω ⊂ [n]2 and (Yi,j)(i,j)∈Ω are given.

## 1.2 Basic properties of convexity

A basic result about convex sets that we shall use extensively is the
Separation Theorem.

Theorem 1.1 (Separation Theorem). Let X ⊂ Rn be a closed convex
set, and x0 ∈ Rn \ X . Then, there exists w ∈ Rn and t ∈ R such that
w>x0 < t, and ∀x ∈ X , w>x ≥ t.

Note that if X is not closed then one can only guarantee that
w>x0 ≤ w>x, ∀x ∈ X (and w 6= 0). This immediately implies the Sup-
porting Hyperplane Theorem (∂X denotes the boundary of X , that is
the closure without the interior):

Theorem 1.2 (Supporting Hyperplane Theorem). Let X ⊂ Rn be a con-
vex set, and x0 ∈ ∂X . Then, there exists w ∈ Rn, w 6= 0 such that

∀x ∈ X , w>x ≥ w>x0.

## 1.2 Basic properties of convexity


We introduce now the key notion of subgradients.

Deﬁnition 1.2 (Subgradients). Let X ⊂ Rn, and f : X → R. Then
g ∈ Rn is a subgradient of f at x ∈ X if for any y ∈ X one has

f (x) − f (y) ≤ g>(x − y).

The set of subgradients of f at x is denoted ∂f (x).

To put it diﬀerently, for any x ∈ X and g ∈ ∂f (x), f is above the
linear function y 7→ f (x)+g>(y−x). The next result shows (essentially)
that a convex functions always admit subgradients.

Proposition 1.1 (Existence of subgradients). Let X ⊂ Rn be convex,
and f : X → R. If ∀x ∈ X , ∂f (x) 6= ∅ then f is convex. Conversely
if f is convex then for any x ∈ int(X ), ∂f (x) 6= ∅. Furthermore if f is
convex and diﬀerentiable at x then ∇f (x) ∈ ∂f (x).

Before going to the proof we recall the deﬁnition of the epigraph of

a function f : X → R:

epi(f ) = {(x, t) ∈ X × R : t ≥ f (x)}.

It is obvious that a function is convex if and only if its epigraph is a
convex set.

Proof. The ﬁrst claim is almost trivial: let g ∈ ∂f ((1 − γ)x + γy), then
by deﬁnition one has

f ((1 − γ)x + γy) ≤ f (x) + γg>(y − x),
f ((1 − γ)x + γy) ≤ f (y) + (1 − γ)g>(x − y),

which clearly shows that f is convex by adding the two (appropriately
rescaled) inequalities.

Now let us prove that a convex function f has subgradients in the
interior of X . We build a subgradient by using a supporting hyperplane
to the epigraph of the function. Let x ∈ X . Then clearly (x, f (x)) ∈
∂epi(f ), and epi(f ) is a convex set. Thus by using the Supporting
Hyperplane Theorem, there exists (a, b) ∈ Rn × R such that

a>x + bf (x) ≥ a>y + bt, ∀(y, t) ∈ epi(f ).

(1.2)

236

Introduction

Clearly, by letting t tend to inﬁnity, one can see that b ≤ 0. Now let
us assume that x is in the interior of X . Then for ε > 0 small enough,
y = x+εa ∈ X , which implies that b cannot be equal to 0 (recall that if
b = 0 then necessarily a 6= 0 which allows to conclude by contradiction).
Thus rewriting (1.2) for t = f (y) one obtains

f (x) − f (y) ≤

1
|b|

a>(x − y).

Thus a/|b| ∈ ∂f (x) which concludes the proof of the second claim.

Finally let f be a convex and diﬀerentiable function. Then by deﬁ-

nition:

f (y) ≥

f ((1 − γ)x + γy) − (1 − γ)f (x)
γ

= f (x) +

f (x + γ(y − x)) − f (x)
γ

→
γ→0

f (x) + ∇f (x)>(y − x),

which shows that ∇f (x) ∈ ∂f (x).

In several cases of interest the set of contraints can have an empty
interior, in which case the above proposition does not yield any informa-
tion. However it is easy to replace int(X ) by ri(X ) -the relative interior
of X - which is deﬁned as the interior of X when we view it as subset of
the aﬃne subspace it generates. Other notions of convex analysis will
prove to be useful in some parts of this text. In particular the notion
of closed convex functions is convenient to exclude pathological cases:
these are the convex functions with closed epigraphs. Sometimes it is
also useful to consider the extension of a convex function f : X → R to
a function from Rn to R by setting f (x) = +∞ for x 6∈ X . In convex
analysis one uses the term proper convex function to denote a convex
function with values in R ∪ {+∞} such that there exists x ∈ Rn with
f (x) < +∞. From now on all convex functions will be closed,
and if necessary we consider also their proper extension. We
refer the reader to Rockafellar [1970] for an extensive discussion of these
notions.

## 1.3 Why convexity?


## 1.3 Why convexity?

The key to the algorithmic success in minimizing convex functions is
that these functions exhibit a local to global phenomenon. We have
already seen one instance of this in Proposition 1.1, where we showed
that ∇f (x) ∈ ∂f (x): the gradient ∇f (x) contains a priori only local
information about the function f around x while the subdiﬀerential
∂f (x) gives a global information in the form of a linear lower bound on
the entire function. Another instance of this local to global phenomenon
is that local minima of convex functions are in fact global minima:

Proposition 1.2 (Local minima are global minima). Let f be convex. If x
is a local minimum of f then x is a global minimum of f . Furthermore
this happens if and only if 0 ∈ ∂f (x).

Proof. Clearly 0 ∈ ∂f (x) if and only if x is a global minimum of f .
Now assume that x is local minimum of f . Then for γ small enough
one has for any y,

f (x) ≤ f ((1 − γ)x + γy) ≤ (1 − γ)f (x) + γf (y),

which implies f (x) ≤ f (y) and thus x is a global minimum of f .

The nice behavior of convex functions will allow for very fast algo-
rithms to optimize them. This alone would not be suﬃcient to justify
the importance of this class of functions (after all constant functions
are pretty easy to optimize). However it turns out that surprisingly
many optimization problems admit a convex (re)formulation. The ex-
cellent book Boyd and Vandenberghe [2004] describes in great details
the various methods that one can employ to uncover the convex aspects
of an optimization problem. We will not repeat these arguments here,
but we have already seen that many famous machine learning problems
(SVM, ridge regression, logistic regression, LASSO, sparse covariance
estimation, and matrix completion) are formulated as convex problems.
We conclude this section with a simple extension of the optimality
condition “0 ∈ ∂f (x)” to the case of constrained optimization. We state
this result in the case of a diﬀerentiable function for sake of simplicity.

238

Introduction

Proposition 1.3 (First order optimality condition). Let f be convex and
X a closed convex set on which f is diﬀerentiable. Then

x∗ ∈ argmin

f (x),

x∈X

if and only if one has

∇f (x∗)>(x∗ − y) ≤ 0, ∀y ∈ X .

Proof. The “if" direction is trivial by using that a gradient is also
a subgradient. For the “only if" direction it suﬃces to note that if
∇f (x)>(y − x) < 0, then f is locally decreasing around x on the
line to y (simply consider h(t) = f (x + t(y − x)) and note that
h0(0) = ∇f (x)>(y − x)).

## 1.4 Black-box model

We now describe our ﬁrst model of “input" for the objective function
and the set of constraints. In the black-box model we assume that
we have unlimited computational resources, the set of constraint X is
known, and the objective function f : X → R is unknown but can be
accessed through queries to oracles:

• A zeroth order oracle takes as input a point x ∈ X and outputs

the value of f at x.

• A ﬁrst order oracle takes as input a point x ∈ X and outputs a

subgradient of f at x.

In this context we are interested in understanding the oracle complexity
of convex optimization, that is how many queries to the oracles are
necessary and suﬃcient to ﬁnd an ε-approximate minima of a convex
function. To show an upper bound on the sample complexity we need to
propose an algorithm, while lower bounds are obtained by information
theoretic reasoning (we need to argue that if the number of queries is
“too small" then we don’t have enough information about the function
to identify an ε-approximate solution).

## 1.4 Black-box model


From a mathematical point of view, the strength of the black-box
model is that it will allow us to derive a complete theory of convex op-
timization, in the sense that we will obtain matching upper and lower
bounds on the oracle complexity for various subclasses of interesting
convex functions. While the model by itself does not limit our compu-
tational resources (for instance any operation on the constraint set X is
allowed) we will of course pay special attention to the algorithms’ com-
putational complexity (i.e., the number of elementary operations that
the algorithm needs to do). We will also be interested in the situation
where the set of constraint X is unknown and can only be accessed
through a separation oracle: given x ∈ Rn, it outputs either that x is
in X , or if x 6∈ X then it outputs a separating hyperplane between x
and X .

The black-box model was essentially developed in the early days
of convex optimization (in the Seventies) with Nemirovski and Yudin
[1983] being still an important reference for this theory (see also Ne-
mirovski [1995]). In the recent years this model and the corresponding
algorithms have regained a lot of popularity, essentially for two reasons:

• It is possible to develop algorithms with dimension-free oracle
complexity which is quite attractive for optimization problems in
very high dimension.

• Many algorithms developed in this model are robust to noise
in the output of the oracles. This is especially interesting for
stochastic optimization, and very relevant to machine learning
applications. We will explore this in details in Chapter 6.

Chapter 2, Chapter 3 and Chapter 4 are dedicated to the study of
the black-box model (noisy oracles are discussed in Chapter 6). We do
not cover the setting where only a zeroth order oracle is available, also
called derivative free optimization, and we refer to Conn et al. [2009],
Audibert et al. [2011] for further references on this.

240

Introduction

## 1.5 Structured optimization

The black-box model described in the previous section seems extremely
wasteful for the applications we discussed in Section 1.1. Consider for
instance the LASSO objective: x 7→ kW x − yk2
2 + kxk1. We know this
function globally, and assuming that we can only make local queries
through oracles seem like an artiﬁcial constraint for the design of al-
gorithms. Structured optimization tries to address this observation.
Ultimately one would like to take into account the global structure of
both f and X in order to propose the most eﬃcient optimization pro-
cedure. An extremely powerful hammer for this task are the Interior
Point Methods. We will describe this technique in Chapter 5 alongside
with other more recent techniques such as FISTA or Mirror Prox.

We brieﬂy describe now two classes of optimization problems for
which we will be able to exploit the structure very eﬃciently, these
are the LPs (Linear Programs) and SDPs (Semi-Deﬁnite Programs).
Ben-Tal and Nemirovski [2001] describe a more general class of Conic
Programs but we will not go in that direction here.

The class LP consists of problems where f (x) = c>x for some c ∈

Rn, and X = {x ∈ Rn : Ax ≤ b} for some A ∈ Rm×n and b ∈ Rm.

The class SDP consists of problems where the optimization vari-
able is a symmetric matrix X ∈ Rn×n. Let Sn be the space of n × n
symmetric matrices (respectively Sn
+ is the space of positive semi-
deﬁnite matrices), and let h·, ·i be the Frobenius inner product (re-
call that it can be written as hA, Bi = Tr(A>B)). In the class SDP
the problems are of the following form: f (x) = hX, Ci for some
C ∈ Rn×n, and X = {X ∈ Sn
+ : hX, Aii ≤ bi, i ∈ {1, . . . , m}} for
some A1, . . . , Am ∈ Rn×n and b ∈ Rm. Note that the matrix comple-
tion problem described in Section 1.1 is an example of an SDP.

## 1.6 Overview of the results and disclaimer

The overarching aim of this monograph is to present the main complex-
ity theorems in convex optimization and the corresponding algorithms.
We focus on ﬁve major results in convex optimization which give the
overall structure of the text: the existence of eﬃcient cutting-plane

## 1.6 Overview of the results and disclaimer


methods with optimal oracle complexity (Chapter 2), a complete char-
acterization of the relation between ﬁrst order oracle complexity and
curvature in the objective function (Chapter 3), ﬁrst order methods
beyond Euclidean spaces (Chapter 4), non-black box methods (such as
interior point methods) can give a quadratic improvement in the num-
ber of iterations with respect to optimal black-box methods (Chapter
5), and ﬁnally noise robustness of ﬁrst order methods (Chapter 6). Ta-
ble 1.1 can be used as a quick reference to the results proved in Chapter
2 to Chapter 5, as well as some of the results of Chapter 6 (this last
chapter is the most relevant to machine learning but the results are
also slightly more speciﬁc which make them harder to summarize).

An important disclaimer is that the above selection leaves out meth-
ods derived from duality arguments, as well as the two most popular
research avenues in convex optimization: (i) using convex optimization
in non-convex settings, and (ii) practical large-scale algorithms. Entire
books have been written on these topics, and new books have yet to be
written on the impressive collection of new results obtained for both
(i) and (ii) in the past ﬁve years.

A few of the blatant omissions regarding (i) include (a) the theory
of submodular optimization (see Bach [2013]), (b) convex relaxations of
combinatorial problems (a short example is given in Section 6.6), and
(c) methods inspired from convex optimization for non-convex prob-
lems such as low-rank matrix factorization (see e.g. Jain et al. [2013]
and references therein), neural networks optimization, etc.

With respect to (ii) the most glaring omissions include (a) heuris-
tics (the only heuristic brieﬂy discussed here is the non-linear conjugate
gradient in Section 2.4), (b) methods for distributed systems, and (c)
adaptivity to unknown parameters. Regarding (a) we refer to Nocedal
and Wright [2006] where the most practical algorithms are discussed in
great details (e.g., quasi-newton methods such as BFGS and L-BFGS,
primal-dual
interior point methods, etc.). The recent survey Boyd
et al. [2011] discusses the alternating direction method of multipliers
(ADMM) which is a popular method to address (b). Finally (c) is a
subtle and important issue. In the entire monograph the emphasis
is on presenting the algorithms and proofs in the simplest way, and

242

Introduction

thus for sake of convenience we assume that the relevant parameters
describing the regularity and curvature of the objective function
(Lipschitz constant, smoothness constant, strong convexity parameter)
are known and can be used to tune the algorithm’s own parameters.
Line search is a powerful technique to replace the knowledge of these
parameters and it is heavily used in practice, see again Nocedal and
Wright [2006]. We observe however that from a theoretical point of
view (c) is only a matter of logarithmic factors as one can always
run in parallel several copies of the algorithm with diﬀerent guesses
for the values of the parameters1. Overall the attitude of this text
with respect to (ii) is best summarized by a quote of Thomas Cover:
“theory is the ﬁrst term in the Taylor series of practice”, Cover [1992].

Notation. We always denote by x∗ a point in X such that f (x∗) =
minx∈X f (x) (note that the optimization problem under consideration
will always be clear from the context). In particular we always assume
that x∗ exists. For a vector x ∈ Rn we denote by x(i) its ith coordinate.
The dual of a norm k · k (deﬁned later) will be denoted either k · k∗ or
k · k∗ (depending on whether the norm already comes with a subscript).
Other notation are standard (e.g., In for the n × n identity matrix, (cid:23)
for the positive semi-deﬁnite order on matrices, etc).

1Note that this trick does not work in the context of Chapter 6.

## 1.6 Overview of the results and disclaimer


f

Algorithm

Rate

# Iter

Cost/iter

non-smooth

non-smooth

center of
gravity

ellipsoid
method

non-smooth

Vaidya

quadratic

CG

exp (cid:0)− t

n

(cid:1)

R

r exp (cid:0)− t

n2

Rn

n

r exp (cid:0)− t
exact
exp (cid:0)− t
κ
√
t

RL/

(cid:1)

βR2/t

βR2/t2

βR2/t

(cid:1)

(cid:1)

n log (cid:0) 1

ε

(cid:1)

n2 log (cid:0) R

rε

(cid:1)

n log (cid:0) Rn

rε

(cid:1)

n
κ log (cid:0) 1

ε

(cid:1)

R2L2/ε2

βR2/ε

Rpβ/ε

βR2/ε

L2/(αt)

L2/(αε)

R2 exp (cid:0)− t

κ

(cid:1)

κ log

(cid:16) R2

(cid:17)

ε

R2 exp

(cid:17)

(cid:16)

− t√
κ

√

κ log

(cid:16) R2

(cid:17)

ε

PGD

PGD

AGD

FW

PGD

PGD

AGD

FISTA

βR2/t2

Rpβ/ε

SP-MP

βR2/t

βR2/ε

IPM

ν exp

(cid:17)

(cid:16)

− t√
ν

√

ν log (cid:0) ν

(cid:1)

ε

non-smooth

SGD

√
t

BL/

B2L2/ε2

non-smooth,
strong. conv.
P fi
f = 1
m
fi smooth
strong. conv.

SGD

B2/(αt)

B2/(αε)

SVRG

–

(m + κ) log (cid:0) 1

ε

(cid:1)

non-smooth,
Lipschitz

smooth

smooth

smooth
(any norm)
strong.
conv.,
Lipschitz
strong.
conv.,
smooth
strong.
conv.,
smooth
f + g,
f smooth,
g simple

ϕ(x, y),

max
y∈Y
ϕ smooth
linear,
X with F
ν-self-conc.

1 ∇,
1 n-dim R
1 ∇,
mat-vec ×

1 ∇,
mat-mat ×

1 ∇

1 ∇,
1 proj.

1 ∇,
1 proj.

1 ∇

1 ∇,
1 LP
1 ∇ ,
1 proj.

1 ∇ ,
1 proj.

1 ∇

1 ∇ of f
Prox of g

MD on X
MD on Y

Newton
step on F

1 stoch. ∇,
1 proj.

1 stoch. ∇,
1 proj.

1 stoch. ∇

Table 1.1: Summary of the results proved in Chapter 2 to Chapter 5 and some of
the results in Chapter 6.

2

Convex optimization in ﬁnite dimension

Let X ⊂ Rn be a convex body (that is a compact convex set with
non-empty interior), and f : X → [−B, B] be a continuous and convex
function. Let r, R > 0 be such that X is contained in an Euclidean ball
of radius R (respectively it contains an Euclidean ball of radius r). In
this chapter we give several black-box algorithms to solve

min. f (x)

s.t. x ∈ X .

As we will see these algorithms have an oracle complexity which is
linear (or quadratic) in the dimension, hence the title of the chapter
(in the next chapter the oracle complexity will be independent of the
dimension). An interesting feature of the methods discussed here is
that they only need a separation oracle for the constraint set X . In the
literature such algorithms are often referred to as cutting plane methods.
In particular these methods can be used to ﬁnd a point x ∈ X given
only a separating oracle for X (this is also known as the feasibility
problem).

244

## 2.1 The center of gravity method


## 2.1 The center of gravity method

We consider the following simple iterative algorithm1: let S1 = X , and
for t ≥ 1 do the following:

1. Compute

ct =

# 1 vol(St)

Z

x∈St

xdx.

(2.1)

2. Query the ﬁrst order oracle at ct and obtain wt ∈ ∂f (ct). Let

St+1 = St ∩ {x ∈ Rn : (x − ct)>wt ≤ 0}.

If stopped after t queries to the ﬁrst order oracle then we use t queries
to a zeroth order oracle to output

xt ∈ argmin
1≤r≤t

f (cr).

This procedure is known as the center of gravity method, it was dis-
covered independently on both sides of the Wall by Levin [1965] and
Newman [1965].

Theorem 2.1. The center of gravity method satisﬁes

f (xt) − min
x∈X

f (x) ≤ 2B

(cid:18)

1 −

(cid:19)t/n

.

1
e

Before proving this result a few comments are in order.
To attain an ε-optimal point the center of gravity method requires
O(n log(2B/ε)) queries to both the ﬁrst and zeroth order oracles. It can
be shown that this is the best one can hope for, in the sense that for
ε small enough one needs Ω(n log(1/ε)) calls to the oracle in order to
ﬁnd an ε-optimal point, see Nemirovski and Yudin [1983] for a formal
proof.

The rate of convergence given by Theorem 2.1 is exponentially fast.
In the optimization literature this is called a linear rate as the (esti-
mated) error at iteration t+1 is linearly related to the error at iteration
t.

1As a warm-up we assume in this section that X is known. It should be clear
from the arguments in the next section that in fact the same algorithm would work
if initialized with S1 ⊃ X .

246

Convex optimization in ﬁnite dimension

The last and most important comment concerns the computational
complexity of the method. It turns out that ﬁnding the center of gravity
ct is a very diﬃcult problem by itself, and we do not have computa-
tionally eﬃcient procedure to carry out this computation in general. In
Section 6.7 we will discuss a relatively recent (compared to the 50 years
old center of gravity method!) randomized algorithm to approximately
compute the center of gravity. This will in turn give a randomized
center of gravity method which we will describe in detail.

We now turn to the proof of Theorem 2.1. We will use the following

elementary result from convex geometry:

Lemma 2.2 (Grünbaum [1960]). Let K be a centered convex set, i.e.,
R
x∈K xdx = 0, then for any w ∈ Rn, w 6= 0, one has

(cid:16)

Vol

K ∩ {x ∈ Rn : x>w ≥ 0}

(cid:17)

≥

1
e

Vol(K).

We now prove Theorem 2.1.

Proof. Let x∗ be such that f (x∗) = minx∈X f (x). Since wt ∈ ∂f (ct)
one has

f (ct) − f (x) ≤ w>

t (ct − x).

and thus

St \ St+1 ⊂ {x ∈ X : (x − ct)>wt > 0} ⊂ {x ∈ X : f (x) > f (ct)}, (2.2)

which clearly implies that one can never remove the optimal point
from our sets in consideration, that is x∗ ∈ St for any t. Without loss
of generality we can assume that we always have wt 6= 0, for otherwise
one would have f (ct) = f (x∗) which immediately conludes the proof.
Now using that wt 6= 0 for any t and Lemma 2.2 one clearly obtains

vol(St+1) ≤

(cid:18)

1 −

(cid:19)t

1
e

vol(X ).

For ε ∈ [0, 1], let Xε = {(1 − ε)x∗ + εx, x ∈ X }. Note that vol(Xε) =
(cid:17)t/n
εnvol(X ). These volume computations show that for ε >
one has vol(Xε) > vol(St+1). In particular this implies that for ε >
(cid:16)
1 − 1
e

, there must exist a time r ∈ {1, . . . , t}, and xε ∈ Xε, such

1 − 1
e

(cid:17)t/n

(cid:16)

## 2.2 The ellipsoid method


that xε ∈ Sr and xε 6∈ Sr+1. In particular by (2.2) one has f (cr) <
f (xε). On the other hand by convexity of f one clearly has f (xε) ≤
f (x∗) + 2εB. This concludes the proof.

## 2.2 The ellipsoid method

Recall that an ellipsoid is a convex set of the form

E = {x ∈ Rn : (x − c)>H −1(x − c) ≤ 1},

where c ∈ Rn, and H is a symmetric positive deﬁnite matrix. Geomet-
rically c is the center of the ellipsoid, and the semi-axes of E are given
by the eigenvectors of H, with lengths given by the square root of the
corresponding eigenvalues.

We give now a simple geometric lemma, which is at the heart of the

ellipsoid method.

Lemma 2.3. Let E0 = {x ∈ Rn : (x − c0)>H −1
w ∈ Rn, w 6= 0, there exists an ellipsoid E such that

0 (x − c0) ≤ 1}. For any

and

E ⊃ {x ∈ E0 : w>(x − c0) ≤ 0},

vol(E) ≤ exp

(cid:19)

(cid:18)

−

1
2n

vol(E0).

(2.3)

(2.4)

Furthermore for n ≥ 2 one can take E = {x ∈ Rn : (x−c)>H −1(x−c) ≤
1} where

c = c0 −

# 1 n + 1

H =

n2
n2 − 1

,

H0w
pw>H0w
# 2 n + 1

H0 −

H0ww>H0
w>H0w

!

.

(2.5)

(2.6)

Proof. For n = 1 the result is obvious, in fact we even have vol(E) ≤
1
2 vol(E0).

For n ≥ 2 one can simply verify that the ellipsoid given by (2.5)
and (2.6) satisfy the required properties (2.3) and (2.4). Rather than
bluntly doing these computations we will show how to derive (2.5) and
(2.6). As a by-product this will also show that the ellipsoid deﬁned by


248

Convex optimization in ﬁnite dimension

(2.5) and (2.6) is the unique ellipsoid of minimal volume that satisfy
(2.3). Let us ﬁrst focus on the case where E0 is the Euclidean ball
B = {x ∈ Rn : x>x ≤ 1}. We momentarily assume that w is a unit
norm vector.

By doing a quick picture, one can see that it makes sense to look
for an ellipsoid E that would be centered at c = −tw, with t ∈ [0, 1]
(presumably t will be small), and such that one principal direction
is w (with inverse squared semi-axis a > 0), and the other principal
directions are all orthogonal to w (with the same inverse squared semi-
axes b > 0). In other words we are looking for E = {x : (x−c)>H −1(x−
c) ≤ 1} with

c = −tw, and H −1 = aww> + b(In − ww>).

Now we have to express our constraints on the fact that E should
contain the half Euclidean ball {x ∈ B : x>w ≤ 0}. Since we are also
looking for E to be as small as possible, it makes sense to ask for E
to "touch" the Euclidean ball, both at x = −w, and at the equator
∂B ∩ w⊥. The former condition can be written as:

(−w − c)>H −1(−w − c) = 1 ⇔ (t − 1)2a = 1,

while the latter is expressed as:

∀y ∈ ∂B ∩ w⊥, (y − c)>H −1(y − c) = 1 ⇔ b + t2a = 1.

As one can see from the above two equations, we are still free to choose
any value for t ∈ [0, 1/2) (the fact that we need t < 1/2 comes from

> 0). Quite naturally we take the value that minimizes

(cid:17)2

(cid:16) t
t−1

b = 1 −
the volume of the resulting ellipsoid. Note that
(cid:19)n−1

1

vol(E)
vol(B)

=

1
√
a

(cid:18) 1
√
b

=

s

# 1 (1−t)2

(cid:18)

1 −

(cid:16) t
1−t

(cid:17)2(cid:19)n−1

=

r

# 1 (cid:16) 1
1−t

,

(cid:17)

f

where f (h) = h2(2h − h2)n−1. Elementary computations show that the
maximum of f (on [1, 2]) is attained at h = 1 + 1
n (which corresponds
to t = 1

n+1 ), and the value is
(cid:19)2 (cid:18)
(cid:18)

1 +

1
n

1 −

(cid:19)n−1

1
n2

≥ exp

(cid:19)

,

(cid:18) 1
n

## 2.2 The ellipsoid method


where the lower bound follows again from elementary computations.
Thus we showed that, for E0 = B, (2.3) and (2.4) are satisﬁed with the
ellipsoid given by the set of points x satisfying:
ww>
n2 − 1
kwk2
n2
2

2(n + 1)
n2

w/kwk2
n + 1

w/kwk2
n + 1

(cid:19)>

In +

! (cid:18)

≤ 1.

x +

x +

(cid:18)

(cid:19)

0 (x − c0) ≤ 1}. Let Φ(x) = c0 + H 1/2

(2.7)
We consider now an arbitrary ellipsoid E0 = {x ∈ Rn : (x −
c0)>H −1
0 x, then clearly E0 = Φ(B)
and {x : w>(x − c0) ≤ 0} = Φ({x : (H 1/2
0 w)>x ≤ 0}). Thus in this case
the image by Φ of the ellipsoid given in (2.7) with w replaced by H 1/2
0 w
will satisfy (2.3) and (2.4). It is easy to see that this corresponds to an
ellipsoid deﬁned by

c = c0 −

H −1 =

(cid:18)

1 −

# 1 n + 1

H0w
pw>H0w
(cid:19)
1
n2

0 +

H −1

,

2(n + 1)
n2

ww>
w>H0w

.

(2.8)

Applying Sherman-Morrison formula to (2.8) one can recover (2.6)
which concludes the proof.

We describe now the ellipsoid method, which only assumes a sepa-
ration oracle for the constraint set X (in particular it can be used to
solve the feasibility problem mentioned at the beginning of the chap-
ter). Let E0 be the Euclidean ball of radius R that contains X , and let
c0 be its center. Denote also H0 = R2In. For t ≥ 0 do the following:

1. If ct 6∈ X then call the separation oracle to obtain a separating
hyperplane wt ∈ Rn such that X ⊂ {x : (x − ct)>wt ≤ 0},
otherwise call the ﬁrst order oracle at ct to obtain wt ∈ ∂f (ct).

2. Let Et+1 = {x : (x − ct+1)>H −1

t+1(x − ct+1) ≤ 1} be the ellipsoid
given in Lemma 2.3 that contains {x ∈ Et : (x − ct)>wt ≤ 0},
that is

ct+1 = ct −

# 1 n + 1

Ht+1 =

n2
n2 − 1

,

Htw
pw>Htw
# 2 n + 1

Ht −

Htww>Ht
w>Htw

!

.


250

Convex optimization in ﬁnite dimension

If stopped after t iterations and if {c1, . . . , ct} ∩ X 6= ∅, then we use the
zeroth order oracle to output

xt ∈

argmin
c∈{c1,...,ct}∩X

f (cr).

The following rate of convergence can be proved with the exact same
argument than for Theorem 2.1 (observe that at step t one can remove
a point in X from the current ellipsoid only if ct ∈ X ).

Theorem 2.4. For t ≥ 2n2 log(R/r) the ellipsoid method satisﬁes
{c1, . . . , ct} ∩ X 6= ∅ and

f (xt) − min
x∈X

f (x) ≤

2BR
r

exp

(cid:18)

−

(cid:19)

.

t
2n2

We observe that the oracle complexity of the ellipsoid method is
much worse than the one of the center gravity method, indeed the for-
mer needs O(n2 log(1/ε)) calls to the oracles while the latter requires
only O(n log(1/ε)) calls. However from a computational point of view
the situation is much better: in many cases one can derive an eﬃcient
separation oracle, while the center of gravity method is basically al-
ways intractable. This is for instance the case in the context of LPs
and SDPs: with the notation of Section 1.5 the computational com-
plexity of the separation oracle for LPs is O(mn) while for SDPs it is
O(max(m, n)n2) (we use the fact that the spectral decomposition of a
matrix can be done in O(n3) operations). This gives an overall complex-
ity of O(max(m, n)n3 log(1/ε)) for LPs and O(max(m, n2)n6 log(1/ε))
for SDPs. We note however that the ellipsoid method is almost never
used in practice, essentially because the method is too rigid to exploit
the potential easiness of real problems (e.g., the volume decrease given
by (2.4) is essentially always tight).

## 2.3 Vaidya’s cutting plane method

We focus here on the feasibility problem (it should be clear from the
previous sections how to adapt the argument for optimization). We
have seen that for the feasibility problem the center of gravity has
a O(n) oracle complexity and unclear computational complexity (see

## 2.3 Vaidya’s cutting plane method


Section 6.7 for more on this), while the ellipsoid method has oracle
complexity O(n2) and computational complexity O(n4). We describe
here the beautiful algorithm of Vaidya [1989, 1996] which has oracle
complexity O(n log(n)) and computational complexity O(n4), thus get-
ting the best of both the center of gravity and the ellipsoid method. In
fact the computational complexity can even be improved further, and
the recent breakthrough Lee et al. [2015] shows that it can essentially
(up to logarithmic factors) be brought down to O(n3).

This section, while giving a fundamental algorithm, should probably
be skipped on a ﬁrst reading. In particular we use several concepts from
the theory of interior point methods which are described in Section 5.3.

2.3.1 The volumetric barrier

Let A ∈ Rm×n where the ith row is ai ∈ Rn, and let b ∈ Rm. We
consider the logarithmic barrier F for the polytope {x ∈ Rn : Ax > b}
deﬁned by

m
X

F (x) = −

log(a>

i x − bi).

We also consider the volumetric barrier v deﬁned by

i=1

v(x) =

1
2

logdet(∇2F (x)).

The intuition is clear: v(x) is equal to the logarithm of the inverse
volume of the Dikin ellipsoid (for the logarithmic barrier) at x. It will
be useful to spell out the hessian of the logarithmic barrier:

∇2F (x) =

m
X

i=1

aia>
i
i x − bi)2

(a>

.

Introducing the leverage score

σi(x) =

(∇2F (x))−1[ai, ai]
i x − bi)2

(a>

,

one can easily verify that

∇v(x) = −

m
X

i=1

σi(x)

ai
a>
i x − bi

,

(2.9)

252

and

Convex optimization in ﬁnite dimension

∇2v(x) (cid:23)

m
X

i=1

σi(x)

aia>
i
i x − bi)2

(a>

=: Q(x).

(2.10)

2.3.2 Vaidya’s algorithm

We ﬁx ε ≤ 0.006 a small constant to be speciﬁed later. Vaidya’s al-
gorithm produces a sequence of pairs (A(t), b(t)) ∈ Rmt×n × Rmt such
that the corresponding polytope contains the convex set of interest.
The initial polytope deﬁned by (A(0), b(0)) is a simplex (in particular
m0 = n+1). For t ≥ 0 we let xt be the minimizer of the volumetric bar-
rier vt of the polytope given by (A(t), b(t)), and (σ(t)
i )i∈[mt] the leverage
scores (associated to vt) at the point xt. We also denote Ft for the log-
arithmic barrier given by (A(t), b(t)). The next polytope (A(t+1), b(t+1))
is deﬁned by either adding or removing a constraint to the current
polytope:

1. If for some i ∈ [mt] one has σ(t)

j < ε, then
(A(t+1), b(t+1)) is deﬁned by removing the ith row in (A(t), b(t))
(in particular mt+1 = mt − 1).

i = minj∈[mt] σ(t)

2. Otherwise let c(t) be the vector given by the separation oracle

queried at xt, and β(t) ∈ R be chosen so that

(∇2Ft(xt))−1[c(t), c(t)]
t c(t) − β(t))2

(x>

=

√

ε.

1
5

Then we deﬁne (A(t+1), b(t+1)) by adding to (A(t), b(t)) the row
given by (c(t), β(t)) (in particular mt+1 = mt + 1).

It can be shown that the volumetric barrier is a self-concordant barrier,
and thus it can be eﬃciently minimized with Newton’s method. In fact
it is enough to do one step of Newton’s method on vt initialized at xt−1,
see Vaidya [1989, 1996] for more details on this.

2.3.3 Analysis of Vaidya’s method

The construction of Vaidya’s method is based on a precise understand-
ing of how the volumetric barrier changes when one adds or removes

## 2.3 Vaidya’s cutting plane method


a constraint to the polytope. This understanding is derived in Section
2.3.4. In particular we obtain the following two key inequalities: If case
1 happens at iteration t then

vt+1(xt+1) − vt(xt) ≥ −ε,

(2.11)

while if case 2 happens then

vt+1(xt+1) − vt(xt) ≥

√

ε.

1
20

(2.12)

We show now how these inequalities imply that Vaidya’s method stops
after O(n log(nR/r)) steps. First we claim that after 2t iterations, case
2 must have happened at least t − 1 times. Indeed suppose that at
iteration 2t − 1, case 2 has happened t − 2 times; then ∇2F (x) is
singular and the leverage scores are inﬁnite, so case 2 must happen at
iteration 2t. Combining this claim with the two inequalities above we
obtain:

v2t(x2t) ≥ v0(x0) +

√

t − 1
20

ε − (t + 1)ε ≥

t
50

ε − 1 + v0(x0).

The key point now is to recall that by deﬁnition one has v(x) =
− log vol(E(x, 1)) where E(x, r) = {y : ∇F 2(x)[y − x, y − x] ≤ r2} is the
Dikin ellipsoid centered at x and of radius r. Moreover the logarithmic
barrier F of a polytope with m constraints is m-self-concordant, which
implies that the polytope is included in the Dikin ellipsoid E(z, 2m)
where z is the minimizer of F (see [Theorem 4.2.6., Nesterov [2004a]]).
The volume of E(z, 2m) is equal to (2m)n exp(−v(z)), which is thus
always an upper bound on the volume of the polytope. Combining this
with the above display we just proved that at iteration 2k the volume
of the current polytope is at most

(cid:18)

exp

n log(2m2t) + 1 − v0(x0) −

(cid:19)

.

t
50

ε

Since E(x, 1) is always included in the polytope we have that −v0(x0)
is at most the logarithm of the volume of the initial polytope which
is O(n log(R)). This clearly concludes the proof as the procedure will
necessarily stop when the volume is below exp(n log(r)) (we also used
the trivial bound mt ≤ n + 1 + t).

254

Convex optimization in ﬁnite dimension

2.3.4 Constraints and the volumetric barrier

We want to understand the eﬀect on the volumetric barrier of addi-
tion/deletion of constraints to the polytope. Let c ∈ Rn, β ∈ R, and
consider the logarithmic barrier eF and the volumetric barrier ev corre-
sponding to the matrix eA ∈ R(m+1)×n and the vector eb ∈ Rm+1 which
are respectively the concatenation of A and c, and the concatenation
of b and β. Let x∗ and ex∗ be the minimizer of respectively v and ev. We
recall the deﬁnition of leverage scores, for i ∈ [m + 1], where am+1 = c
and bm+1 = β,

σi(x) =

(∇2F (x))−1[ai, ai]
i x − bi)2
The leverage scores σi and eσi are closely related:

, and eσi(x) =

(a>

(∇2 eF (x))−1[ai, ai]
i x − bi)2

(a>

.

Lemma 2.5. One has for any i ∈ [m + 1],

eσm+1(x)
1 − eσm+1(x)

≥ σi(x) ≥ eσi(x) ≥ (1 − σm+1(x))σi(x).

Proof. First we observe that by Sherman-Morrison’s formula (A +
uv>)−1 = A−1 − A−1uv>A−1

1+A−1[u,v] one has

(∇2 eF (x))−1 = (∇2F (x))−1 −

(∇2F (x))−1cc>(∇2F (x))−1
(c>x − β)2 + (∇2F (x))−1[c, c]

,

(2.13)

This immediately proves eσi(x) ≤ σi(x). It also implies the inequality
eσi(x) ≥ (1−σm+1(x))σi(x) thanks the following fact: A− Auu>A
1+A[u,u] (cid:23) (1−
A[u, u])A. For the last inequality we use that A + Auu>A
1
1−A[u,u] A
together with

1+A[u,u] (cid:22)

(∇2F (x))−1 = (∇2 eF (x))−1 +

(∇2 eF (x))−1cc>(∇2 eF (x))−1
(c>x − β)2 − (∇2 eF (x))−1[c, c]

.

We now assume the following key result, which was ﬁrst proven by
Vaidya. To put the statement in context recall that for a self-concordant
barrier f the suboptimality gap f (x) − min f is intimately related to
the Newton decrement k∇f (x)k(∇2f (x))−1. Vaidya’s inequality gives a

## 2.3 Vaidya’s cutting plane method


similar claim for the volumetric barrier. We use the version given in
[Theorem 2.6, Anstreicher [1998]] which has slightly better numerical
constants than the original bound. Recall also the deﬁnition of Q from
(2.10).

Theorem 2.6. Let λ(x) = k∇v(x)kQ(x)−1 be an approximate Newton
√
decrement, ε = mini∈[m] σi(x), and assume that λ(x)2 ≤ 2
. Then

ε−ε
36

v(x) − v(x∗) ≤ 2λ(x)2.

We also denote eλ for the approximate Newton decrement of ev. The
goal for the rest of the section is to prove the following theorem which
gives the precise understanding of the volumetric barrier we were look-
ing for.

Theorem 2.7. Let ε := mini∈[m] σi(x∗), δ := σm+1(x∗)/

ε and assume

√

√

(cid:16)

√

δ

ε+

(cid:17)2

√
ε

δ3
√

1−δ

ε

that

√

< 2

ε−ε
36

. Then one has

ev(ex∗) − v(x∗) ≥

log(1 + δ

√

ε) − 2

1
2

(cid:18)

√

δ

ε +

q

(cid:19)2

√

ε

δ3
√

1 − δ

ε

.

(2.14)

On the other hand assuming that eσm+1(ex∗) = mini∈[m+1] eσi(ex∗) =: ε
and that ε ≤ 1/4, one has

ev(ex∗) − v(x∗) ≤ −

1
2

log(1 − ε) +

8ε2
(1 − ε)2 .

(2.15)

Before going into the proof let us see brieﬂy how Theorem 2.7 give
the two inequalities stated at the beginning of Section 2.3.3. To prove
(2.12) we use (2.14) with δ = 1/5 and ε ≤ 0.006, and we observe that
in this case the right hand side of (2.14) is lower bounded by 1
ε. On
# 20 the other hand to prove (2.11) we use (2.15), and we observe that for
ε ≤ 0.006 the right hand side of (2.15) is upper bounded by ε.

√

Proof. We start with the proof of (2.14). First observe that by factoring

256

Convex optimization in ﬁnite dimension

(∇2F (x))1/2 on the left and on the right of ∇2 eF (x) one obtains

det(∇2 eF (x))

= det

∇2F (x) +

!

cc>
(c>x − β)2

= det(∇2F (x))det

In +

(∇2F (x))−1/2cc>(∇2F (x))−1/2
(c>x − β)2

!

= det(∇2F (x))(1 + σm+1(x)),

and thus

ev(x) = v(x) +

1
2

log(1 + σm+1(x)).

In particular we have

ev(ex∗) − v(x∗) =

1
2

log(1 + σm+1(x∗)) − (ev(x∗) − ev(ex∗)).

To bound the suboptimality gap of x∗ in ev we will invoke Theorem 2.6
and thus we have to upper bound the approximate Newton decrement
eλ. Using [(2.16), Lemma 2.8] below one has

eλ(x∗)2 ≤

(cid:18)

σm+1(x∗) +

r σ3

m+1(x∗)
mini∈[m] σi(x∗)

(cid:19)2

1 − σm+1(x∗)

This concludes the proof of (2.14).

√

(cid:18)
δ

ε +

q

√

(cid:19)2

ε

.

δ3
√
ε

=

1 − δ

We now turn to the proof of (2.15). Following the same steps as

above we immediately obtain

ev(ex∗) − v(x∗) = ev(ex∗) − v(ex∗) + v(ex∗) − v(x∗)

= −

log(1 − eσm+1(ex∗)) + v(ex∗) − v(x∗).

1
2

To invoke Theorem 2.6 it remains to upper bound λ(ex∗). Using [(2.17),
Lemma 2.8] below one has

λ(ex∗) ≤

2 eσm+1(ex∗)
1 − eσm+1(ex∗)

.

We can apply Theorem 2.6 since the assumption ε ≤ 1/4 implies that
(cid:16) 2ε
1−ε

. This concludes the proof of (2.15).

ε−ε
36

≤ 2

(cid:17)2

√



## 2.3 Vaidya’s cutting plane method


Lemma 2.8. One has

q

1 − σm+1(x) eλ(x) ≤ k∇v(x)kQ(x)−1 + σm+1(x) +

v
u
u
t

σ3
m+1(x)
mini∈[m] σi(x)

.

Furthermore if eσm+1(x) = mini∈[m+1] eσi(x) then one also has

λ(x) ≤ k∇ev(x)kQ(x)−1 +

2 eσm+1(x)
1 − eσm+1(x)

.

(2.16)

(2.17)

Proof. We start with the proof of (2.16). First observe that by Lemma
## 2.5 one has eQ(x) (cid:23) (1 − σm+1(x))Q(x) and thus by deﬁnition of the
Newton decrement

eλ(x) = k∇ev(x)k

eQ(x)−1 ≤

k∇ev(x)kQ(x)−1
p1 − σm+1(x)

.

Next observe that (recall (2.9))

∇ev(x) = ∇v(x) +

m
X

i=1

(σi(x) − eσi(x))

ai
a>
i x − bi

− eσm+1(x)

c
c>x − β

.

We now use that Q(x) (cid:23) (mini∈[m] σi(x))∇2F (x) to obtain

(cid:13)
(cid:13)
(cid:13)eσm+1(x)
(cid:13)

c
c>x − β

(cid:13)
# 2 (cid:13)
(cid:13)
(cid:13)

Q(x)−1

≤ eσ2

m+1(x)σm+1(x)
mini∈[m] σi(x)

.

By Lemma 2.5 one has eσm+1(x) ≤ σm+1(x) and thus we see that it
only remains to prove

(cid:13)
(cid:13)
(cid:13)
(cid:13)
(cid:13)

m
X

i=1

(σi(x) − eσi(x))

ai
a>
i x − bi

(cid:13)
# 2 (cid:13)
(cid:13)
(cid:13)
(cid:13)

Q(x)−1

≤ σ2

m+1(x).

The above inequality follows from a beautiful calculation of Vaidya (see
[Lemma 12, Vaidya [1996]]), starting from the identity

σi(x) − eσi(x) =

((∇2F (x))−1[ai, c])2

((c>x − β)2 + (∇2F (x))−1[c, c])(a>

i x − bi)2

,

which itself follows from (2.13).

258

Convex optimization in ﬁnite dimension

We now turn to the proof of (2.17). Following the same steps as

above we immediately obtain

λ(x) = k∇v(x)kQ(x)−1 ≤ k∇ev(x)kQ(x)−1+σm+1(x)+

v
u
u

t eσ2

m+1(x)σm+1(x)
mini∈[m] σi(x)

.

Using Lemma 2.5 together with the assumption eσm+1(x) =
mini∈[m+1] eσi(x) yields (2.17), thus concluding the proof.

## 2.4 Conjugate gradient

We conclude this chapter with the special case of unconstrained opti-
mization of a convex quadratic function f (x) = 1
2 x>Ax − b>x, where
A ∈ Rn×n is a positive deﬁnite matrix and b ∈ Rn. This problem, of
paramount importance in practice (it is equivalent to solving the lin-
ear system Ax = b), admits a simple ﬁrst-order black-box procedure
which attains the exact optimum x∗ in at most n steps. This method,
called the conjugate gradient, is described and analyzed below. What
is written below is taken from [Chapter 5, Nocedal and Wright [2006]].
Let h·, ·iA be the inner product on Rn deﬁned by the positive def-
inite matrix A, that is hx, yiA = x>Ay (we also denote by k · kA the
corresponding norm). For sake of clarity we denote here h·, ·i for the
standard inner product in Rn. Given an orthogonal set {p0, . . . , pn−1}
for h·, ·iA we will minimize f by sequentially minimizing it along the
directions given by this orthogonal set. That is, given x0 ∈ Rn, for t ≥ 0
let

xt+1 :=

argmin
x∈{xt+λpt, λ∈R}

f (x).

Equivalently one can write

xt+1 = xt − h∇f (xt), pti

pt
kptk2
A

.

(2.18)

(2.19)

The latter identity follows by diﬀerentiating λ 7→ f (x + λpt), and using
that ∇f (x) = Ax − b. We also make an observation that will be useful
later, namely that xt+1 is the minimizer of f on x0 + span{p0, . . . , pt},
or equivalently

h∇f (xt+1), pii = 0, ∀ 0 ≤ i ≤ t.

(2.20)

## 2.4 Conjugate gradient


Equation (2.20) is true by construction for i = t, and for i ≤ t − 1 it
follows by induction, assuming (2.20) at t = 1 and using the following
formula:

∇f (xt+1) = ∇f (xt) − h∇f (xt), pti

.

(2.21)

Apt
kptk2
A

We now claim that xn = x∗ = argminx∈Rn f (x). It suﬃces to show
that hxn − x0, ptiA = hx∗ − x0, ptiA for any t ∈ {0, . . . , n − 1}. Note that
xn − x0 = − Pn−1

, and thus using that x∗ = A−1b,

t=0 h∇f (xt), pti pt
kptk2
A

hxn − x0, ptiA = −h∇f (xt), pti = hb − Axt, pti = hx∗ − xt, ptiA
= hx∗ − x0, ptiA,

which concludes the proof of xn = x∗.

In order to have a proper black-box method it remains to describe
how to build iteratively the orthogonal set {p0, . . . , pn−1} based only on
gradient evaluations of f . A natural guess to obtain a set of orthogonal
directions (w.r.t. h·, ·iA) is to take p0 = ∇f (x0) and for t ≥ 1,

pt = ∇f (xt) − h∇f (xt), pt−1iA

pt−1
kpt−1k2
A

.

(2.22)

Let us ﬁrst verify by induction on t ∈ [n − 1] that for any i ∈ {0, . . . , t −
2}, hpt, piiA = 0 (observe that for i = t−1 this is true by construction of
pt). Using the induction hypothesis one can see that it is enough to show
h∇f (xt), piiA = 0 for any i ∈ {0, . . . , t − 2}, which we prove now. First
observe that by induction one easily obtains Api ∈ span{p0, . . . , pi+1}
from (2.21) and (2.22). Using this fact together with h∇f (xt), piiA =
h∇f (xt), Apii and (2.20) thus concludes the proof of orthogonality of
the set {p0, . . . , pn−1}.

We still have to show that (2.22) can be written by making
only reference to the gradients of f at previous points. Recall that
xt+1 is the minimizer of f on x0 + span{p0, . . . , pt}, and thus given
the form of pt we also have that xt+1 is the minimizer of f on
x0 + span{∇f (x0), . . . , ∇f (xt)} (in some sense the conjugate gradi-
ent is the optimal ﬁrst order method for convex quadratic functions).
In particular one has h∇f (xt+1), ∇f (xt)i = 0. This fact, together with

260

Convex optimization in ﬁnite dimension

the orthogonality of the set {pt} and (2.21), imply that

h∇f (xt+1), ptiA
kptk2
A

= h∇f (xt+1),

Apt
kptk2
A

i = −

h∇f (xt+1), ∇f (xt+1)i
h∇f (xt), pti

.

Furthermore using the deﬁnition (2.22) and h∇f (xt), pt−1i = 0 one also
has

h∇f (xt), pti = h∇f (xt), ∇f (xt)i.

Thus we arrive at the following rewriting of the (linear) conjugate gra-
dient algorithm, where we recall that x0 is some ﬁxed starting point
and p0 = ∇f (x0),

xt+1 =

argmin
x∈{xt+λpt, λ∈R}

f (x),

pt+1 = ∇f (xt+1) +

h∇f (xt+1), ∇f (xt+1)i
h∇f (xt), ∇f (xt)i

pt.

(2.23)

(2.24)

Observe that the algorithm deﬁned by (2.23) and (2.24) makes sense
for an arbitary convex function, in which case it is called the non-
linear conjugate gradient. There are many variants of the non-linear
conjugate gradient, and the above form is known as the Fletcher-
âĂŞReeves method. Another popular version in practice is the Polak-
Ribière method which is based on the fact that for the general non-
quadratic case one does not necessarily have h∇f (xt+1), ∇f (xt)i = 0,
and thus one replaces (2.24) by

pt+1 = ∇f (xt+1) +

h∇f (xt+1) − ∇f (xt), ∇f (xt+1)i
h∇f (xt), ∇f (xt)i

pt.

We refer to Nocedal and Wright [2006] for more details about these
algorithms, as well as for advices on how to deal with the line search
in (2.23).

Finally we also note that the linear conjugate gradient method can
often attain an approximate solution in much fewer than n steps. More
precisely, denoting κ for the condition number of A (that is the ratio
of the largest eigenvalue to the smallest eigenvalue of A), one can show
that linear conjugate gradient attains an ε optimal point in a number
κ log(1/ε). The next chapter will demistify this
of iterations of order

√

## 2.4 Conjugate gradient


convergence rate, and in particular we will see that (i) this is the opti-
mal rate among ﬁrst order methods, and (ii) there is a way to generalize
this rate to non-quadratic convex functions (though the algorithm will
have to be modiﬁed).

3

Dimension-free convex optimization

We investigate here variants of the gradient descent scheme. This it-
erative algorithm, which can be traced back to Cauchy [1847], is the
simplest strategy to minimize a diﬀerentiable function f on Rn. Start-
ing at some initial point x1 ∈ Rn it iterates the following equation:

xt+1 = xt − η∇f (xt),

(3.1)

where η > 0 is a ﬁxed step-size parameter. The rationale behind (3.1)
is to make a small step in the direction that minimizes the local ﬁrst
order Taylor approximation of f (also known as the steepest descent
direction).

As we shall see, methods of the type (3.1) can obtain an oracle
complexity independent of the dimension1. This feature makes them
particularly attractive for optimization in very high dimension.

Apart from Section 3.3, in this chapter k · k denotes the Euclidean
norm. The set of constraints X ⊂ Rn is assumed to be compact and

1Of course the computational complexity remains at least linear in the dimension

since one needs to manipulate gradients.

262

## 3.1 Projected subgradient descent for Lipschitz functions


y

ky − ΠX (y)k

ΠX (y)

ky − xk

kΠX (y) − xk

x

X

Figure 3.1: Illustration of Lemma 3.1.

convex. We deﬁne the projection operator ΠX on X by

ΠX (x) = argmin

y∈X

kx − yk.

The following lemma will prove to be useful in our study. It is an easy
corollary of Proposition 1.3, see also Figure 3.1.

Lemma 3.1. Let x ∈ X and y ∈ Rn, then

(ΠX (y) − x)>(ΠX (y) − y) ≤ 0,

which also implies kΠX (y) − xk2 + ky − ΠX (y)k2 ≤ ky − xk2.

Unless speciﬁed otherwise all the proofs in this chapter are taken

from Nesterov [2004a] (with slight simpliﬁcation in some cases).

## 3.1 Projected subgradient descent for Lipschitz functions

In this section we assume that X is contained in an Euclidean ball
centered at x1 ∈ X and of radius R. Furthermore we assume that f is
such that for any x ∈ X and any g ∈ ∂f (x) (we assume ∂f (x) 6= ∅),

264

Dimension-free convex optimization

yt+1

gradient step
(3.2)

projection (3.3)

xt+1

xt

X

Figure 3.2: Illustration of the projected subgradient descent method.

one has kgk ≤ L. Note that by the subgradient inequality and Cauchy-
Schwarz this implies that f is L-Lipschitz on X , that is |f (x) − f (y)| ≤
Lkx − yk.

In this context we make two modiﬁcations to the basic gradient
descent (3.1). First, obviously, we replace the gradient ∇f (x) (which
may not exist) by a subgradient g ∈ ∂f (x). Secondly, and more impor-
tantly, we make sure that the updated point lies in X by projecting
back (if necessary) onto it. This gives the projected subgradient descent
algorithm2 which iterates the following equations for t ≥ 1:

yt+1 = xt − ηgt, where gt ∈ ∂f (xt),
xt+1 = ΠX (yt+1).

(3.2)

(3.3)

This procedure is illustrated in Figure 3.2. We prove now a rate of
convergence for this method under the above assumptions.

Theorem 3.2. The projected subgradient descent method with η =

2In the optimization literature the term “descent" is reserved for methods such
that f (xt+1) ≤ f (xt). In that sense the projected subgradient descent is not a
descent method.

## 3.1 Projected subgradient descent for Lipschitz functions


R
√

L

t

satisﬁes

f

1
t

t
X

s=1

!

xs

− f (x∗) ≤

RL
√
t

.

Proof. Using the deﬁnition of subgradients, the deﬁnition of the
method, and the elementary identity 2a>b = kak2 + kbk2 − ka − bk2,
one obtains

=

s (xs − x∗)
f (xs) − f (x∗) ≤ g>
# 1 (xs − ys+1)>(xs − x∗)
η
1
2η
1
2η

=

=

(cid:16)

(cid:16)

kxs − x∗k2 + kxs − ys+1k2 − kys+1 − x∗k2(cid:17)

kxs − x∗k2 − kys+1 − x∗k2(cid:17)

+

η
2

kgsk2.

Now note that kgsk ≤ L, and furthermore by Lemma 3.1

kys+1 − x∗k ≥ kxs+1 − x∗k.

Summing the resulting inequality over s, and using that kx1 − x∗k ≤ R
yield

t
X

s=1

(f (xs) − f (x∗)) ≤

R2
2η

+

ηL2t
2

.

Plugging in the value of η directly gives the statement (recall that by
convexity f ((1/t) Pt

Pt

s=1 f (xs)).

s=1 xs) ≤ 1
t

We will show in Section 3.5 that the rate given in Theorem 3.2
is unimprovable from a black-box perspective. Thus to reach an ε-
optimal point one needs Θ(1/ε2) calls to the oracle. In some sense
this is an astonishing result as this complexity is independent3 of the
ambient dimension n. On the other hand this is also quite disappointing
compared to the scaling in log(1/ε) of the center of gravity and ellipsoid
method of Chapter 2. To put it diﬀerently with gradient descent one
could hope to reach a reasonable accuracy in very high dimension,
while with the ellipsoid method one can reach very high accuracy in

3Observe however that the quantities R and L may dependent on the dimension,

see Chapter 4 for more on this.


266

Dimension-free convex optimization

reasonably small dimension. A major task in the following sections
will be to explore more restrictive assumptions on the function to be
optimized in order to have the best of both worlds, that is an oracle
complexity independent of the dimension and with a scaling in log(1/ε).
The computational bottleneck of the projected subgradient descent
is often the projection step (3.3) which is a convex optimization problem
by itself. In some cases this problem may admit an analytical solution
(think of X being an Euclidean ball), or an easy and fast combinatorial
algorithm to solve it (this is the case for X being an ‘1-ball, see Mac-
ulan and de Paula [1989]). We will see in Section 3.3 a projection-free
algorithm which operates under an extra assumption of smoothness on
the function to be optimized.

Finally we observe that the step-size recommended by Theorem 3.2
depends on the number of iterations to be performed. In practice this
may be an undesirable feature. However using a time-varying step size
of the form ηs = R
s one can prove the same rate up to a log t factor.
√
L
In any case these step sizes are very small, which is the reason for
the slow convergence. In the next section we will see that by assuming
smoothness in the function f one can aﬀord to be much more aggressive.
Indeed in this case, as one approaches the optimum the size of the
gradients themselves will go to 0, resulting in a sort of “auto-tuning" of
the step sizes which does not happen for an arbitrary convex function.

## 3.2 Gradient descent for smooth functions

We say that a continuously diﬀerentiable function f is β-smooth if the
gradient ∇f is β-Lipschitz, that is

k∇f (x) − ∇f (y)k ≤ βkx − yk.

Note that if f is twice diﬀerentiable then this is equivalent to the eigen-
values of the Hessians being smaller than β. In this section we explore
potential improvements in the rate of convergence under such a smooth-
ness assumption. In order to avoid technicalities we consider ﬁrst the
unconstrained situation, where f is a convex and β-smooth function
on Rn. The next theorem shows that gradient descent, which iterates

## 3.2 Gradient descent for smooth functions


xt+1 = xt − η∇f (xt), attains a much faster rate in this situation than
in the non-smooth case of the previous section.

Theorem 3.3. Let f be convex and β-smooth on Rn. Then gradient
descent with η = 1

β satisﬁes

f (xt) − f (x∗) ≤

2βkx1 − x∗k2
t − 1

.

Before embarking on the proof we state a few properties of smooth

convex functions.

Lemma 3.4. Let f be a β-smooth function on Rn. Then for any x, y ∈
Rn, one has

|f (x) − f (y) − ∇f (y)>(x − y)| ≤

β
2

kx − yk2.

Proof. We represent f (x) − f (y) as an integral, apply Cauchy-Schwarz
and then β-smoothness:

|f (x) − f (y) − ∇f (y)>(x − y)|

(cid:12)
(cid:12)
∇f (y + t(x − y))>(x − y)dt − ∇f (y)>(x − y)
(cid:12)
(cid:12)

k∇f (y + t(x − y)) − ∇f (y)k · kx − ykdt

Z 1

(cid:12)
(cid:12)
(cid:12)
(cid:12)
0
Z 1

=

≤

≤

=

0
Z 1

βtkx − yk2dt

0
β
kx − yk2.
2

In particular this lemma shows that if f is convex and β-smooth,

then for any x, y ∈ Rn, one has

0 ≤ f (x) − f (y) − ∇f (y)>(x − y) ≤

β
2

kx − yk2.

(3.4)

This gives in particular the following important inequality to evaluate
the improvement in one step of gradient descent:

(cid:18)

f

x −

1
β

(cid:19)

∇f (x)

− f (x) ≤ −

1
2β

k∇f (x)k2.

(3.5)

268

Dimension-free convex optimization

The next lemma, which improves the basic inequality for subgradients
under the smoothness assumption, shows that in fact f is convex and
β-smooth if and only if (3.4) holds true. In the literature (3.4) is often
used as a deﬁnition of smooth convex functions.

Lemma 3.5. Let f be such that (3.4) holds true. Then for any x, y ∈
Rn, one has

f (x) − f (y) ≤ ∇f (x)>(x − y) −

1
2β

k∇f (x) − ∇f (y)k2.

Proof. Let z = y − 1

β (∇f (y) − ∇f (x)). Then one has

f (x) − f (y)

= f (x) − f (z) + f (z) − f (y)

≤ ∇f (x)>(x − z) + ∇f (y)>(z − y) +

β
2

kz − yk2

= ∇f (x)>(x − y) + (∇f (x) − ∇f (y))>(y − z) +

= ∇f (x)>(x − y) −

1
2β

k∇f (x) − ∇f (y)k2.

1
2β

k∇f (x) − ∇f (y)k2

We can now prove Theorem 3.3

Proof. Using (3.5) and the deﬁnition of the method one has

f (xs+1) − f (xs) ≤ −

1
2β

k∇f (xs)k2.

In particular, denoting δs = f (xs) − f (x∗), this shows:

δs+1 ≤ δs −

1
2β

k∇f (xs)k2.

One also has by convexity

δs ≤ ∇f (xs)>(xs − x∗) ≤ kxs − x∗k · k∇f (xs)k.

We will prove that kxs − x∗k is decreasing with s, which with the two
above displays will imply

δs+1 ≤ δs −

1
2βkx1 − x∗k2 δ2
s .

## 3.2 Gradient descent for smooth functions


Let us see how to use this last inequality to conclude the proof. Let
ω =

1

2βkx1−x∗k2 , then4
δs
δs+1

ωδ2

s +δs+1 ≤ δs ⇔ ω

# 1 δs+1
Thus it only remains to show that kxs − x∗k is decreasing with s. Using
Lemma 3.5 one immediately gets

≥ ω(t−1).

# 1 δs+1

≥ ω ⇒

1
δs

1
δs

1
δt

⇒

≤

+

−

(∇f (x) − ∇f (y))>(x − y) ≥

1
β

k∇f (x) − ∇f (y)k2.

(3.6)

We use this as follows (together with ∇f (x∗) = 0)

kxs+1 − x∗k2 = kxs −

1
β

∇f (xs) − x∗k2

= kxs − x∗k2 −

≤ kxs − x∗k2 −

≤ kxs − x∗k2,

∇f (xs)>(xs − x∗) +

2
β
# 1 β2 k∇f (xs)k2

β2 k∇f (xs)k2

which concludes the proof.

The constrained case

We now come back to the constrained problem

min. f (x)

s.t. x ∈ X .

Similarly to what we did in Section 3.1 we consider the projected gra-
dient descent algorithm, which iterates xt+1 = ΠX (xt − η∇f (xt)).

The key point in the analysis of gradient descent for unconstrained
smooth optimization is that a step of gradient descent started at x will
decrease the function value by at least 1
2β k∇f (x)k2, see (3.5). In the
constrained case we cannot expect that this would still hold true as a
step may be cut short by the projection. The next lemma deﬁnes the
“right" quantity to measure progress in the constrained case.

4The last step in the sequence of implications can be improved by taking δ1 into
4ω . This improves the rate

account. Indeed one can easily show with (3.4) that δ1 ≤ 1
of Theorem 3.3 from 2βkx1−x∗k2

to 2βkx1−x∗k2

.

t−1

t+3

270

Dimension-free convex optimization

Lemma 3.6. Let x, y ∈ X , x+ = ΠX
β(x − x+). Then the following holds true:

(cid:16)

x − 1

β ∇f (x)

(cid:17)

, and gX (x) =

f (x+) − f (y) ≤ gX (x)>(x − y) −

1
2β

kgX (x)k2.

Proof. We ﬁrst observe that

∇f (x)>(x+ − y) ≤ gX (x)>(x+ − y).

(3.7)

Indeed the above inequality is equivalent to

(cid:18)

x+ −

(cid:18)

x −

(cid:19)(cid:19)>

1
β

∇f (x)

(x+ − y) ≤ 0,

which follows from Lemma 3.1. Now we use (3.7) as follows to prove
the lemma (we also use (3.4) which still holds true in the constrained
case)

f (x+) − f (y)
= f (x+) − f (x) + f (x) − f (y)

≤ ∇f (x)>(x+ − x) +

kx+ − xk2 + ∇f (x)>(x − y)

= ∇f (x)>(x+ − y) +

kgX (x)k2

≤ gX (x)>(x+ − y) +

kgX (x)k2

= gX (x)>(x − y) −

kgX (x)k2.

β
2
1
2β
1
2β
1
2β

We can now prove the following result.

Theorem 3.7. Let f be convex and β-smooth on X . Then projected
gradient descent with η = 1

f (xt) − f (x∗) ≤

β satisﬁes
3βkx1 − x∗k2 + f (x1) − f (x∗)
t

.

Proof. Lemma 3.6 immediately gives

f (xs+1) − f (xs) ≤ −

1
2β

kgX (xs)k2,

## 3.3 Conditional gradient descent, aka Frank-Wolfe


and

f (xs+1) − f (x∗) ≤ kgX (xs)k · kxs − x∗k.
We will prove that kxs − x∗k is decreasing with s, which with the two
above displays will imply

δs+1 ≤ δs −

1
2βkx1 − x∗k2 δ2

s+1.

An easy induction shows that

δs ≤

3βkx1 − x∗k2 + f (x1) − f (x∗)
s

.

Thus it only remains to show that kxs − x∗k is decreasing with s. Using
Lemma 3.6 one can see that gX (xs)>(xs − x∗) ≥ 1
2β kgX (xs)k2 which
implies

kxs+1 − x∗k2 = kxs −

1
β

gX (xs) − x∗k2

= kxs − x∗k2 −

≤ kxs − x∗k2.

2
β

gX (xs)>(xs − x∗) +

# 1 β2 kgX (xs)k2

## 3.3 Conditional gradient descent, aka Frank-Wolfe

We describe now an alternative algorithm to minimize a smooth con-
vex function f over a compact convex set X . The conditional gradient
descent, introduced in Frank and Wolfe [1956], performs the following
update for t ≥ 1, where (γs)s≥1 is a ﬁxed sequence,

yt ∈ argminy∈X ∇f (xt)>y
xt+1 = (1 − γt)xt + γtyt.

(3.8)

(3.9)

In words conditional gradient descent makes a step in the steepest
descent direction given the constraint set X , see Figure 3.3 for an il-
lustration. From a computational perspective, a key property of this

272

Dimension-free convex optimization

yt

−∇f (xt)

xt+1

xt

X

Figure 3.3: Illustration of conditional gradient descent.

scheme is that it replaces the projection step of projected gradient de-
scent by a linear optimization over X , which in some cases can be a
much simpler problem.

We now turn to the analysis of this method. A major advantage of
conditional gradient descent over projected gradient descent is that the
former can adapt to smoothness in an arbitrary norm. Precisely let f
be β-smooth in some norm k · k, that is k∇f (x) − ∇f (y)k∗ ≤ βkx − yk
where the dual norm k · k∗ is deﬁned as kgk∗ = supx∈Rn:kxk≤1 g>x.
The following result is extracted from Jaggi [2013] (see also Dunn and
Harshbarger [1978]).

Theorem 3.8. Let f be a convex and β-smooth function w.r.t. some
norm k · k, R = supx,y∈X kx − yk, and γs = 2
s+1 for s ≥ 1. Then for any
t ≥ 2, one has

f (xt) − f (x∗) ≤

2βR2
t + 1

.

Proof. The following inequalities hold true, using respectively β-
smoothness (it can easily be seen that (3.4) holds true for smoothness
in an arbitrary norm), the deﬁnition of xs+1, the deﬁnition of ys, and

## 3.3 Conditional gradient descent, aka Frank-Wolfe


the convexity of f :

f (xs+1) − f (xs) ≤ ∇f (xs)>(xs+1 − xs) +

kxs+1 − xsk2

≤ γs∇f (xs)>(ys − xs) +

s R2
γ2

≤ γs∇f (xs)>(x∗ − xs) +

s R2
γ2

≤ γs(f (x∗) − f (xs)) +

β
2

β
2
β
2
β
# 2 s R2.
γ2

Rewriting this inequality in terms of δs = f (xs) − f (x∗) one obtains

δs+1 ≤ (1 − γs)δs +

β
2

s R2.
γ2

A simple induction using that γs = 2
s+1 ﬁnishes the proof (note that
the initialization is done at step 2 with the above inequality yielding
δ2 ≤ β

2 R2).

In addition to being projection-free and “norm-free", the conditional
gradient descent satisﬁes a perhaps even more important property: it
produces sparse iterates. More precisely consider the situation where
X ⊂ Rn is a polytope, that is the convex hull of a ﬁnite set of points
(these points are called the vertices of X ). Then Carathéodory’s theo-
rem states that any point x ∈ X can be written as a convex combination
of at most n + 1 vertices of X . On the other hand, by deﬁnition of the
conditional gradient descent, one knows that the tth iterate xt can be
written as a convex combination of t vertices (assuming that x1 is a
vertex). Thanks to the dimension-free rate of convergence one is usu-
ally interested in the regime where t (cid:28) n, and thus we see that the
iterates of conditional gradient descent are very sparse in their vertex
representation.

We note an interesting corollary of the sparsity property together
with the rate of convergence we proved: smooth functions on the sim-
plex {x ∈ Rn
i=1 xi = 1} always admit sparse approximate mini-
mizers. More precisely there must exist a point x with only t non-zero
coordinates and such that f (x) − f (x∗) = O(1/t). Clearly this is the
best one can hope for in general, as it can be seen with the function

+ : Pn

274

Dimension-free convex optimization

f (x) = kxk2
which implies on the simplex kxk2

2 since by Cauchy-Schwarz one has kxk1 ≤ pkxk0kxk2

2 ≥ 1/kxk0.

Next we describe an application where the three properties of condi-
tional gradient descent (projection-free, norm-free, and sparse iterates)
are critical to develop a computationally eﬃcient procedure.

An application of conditional gradient descent: Least-squares re-
gression with structured sparsity

This example is inspired by Lugosi [2010] (see also Jones [1992]). Con-
sider the problem of approximating a signal Y ∈ Rn by a “small" com-
bination of dictionary elements d1, . . . , dN ∈ Rn. One way to do this
is to consider a LASSO type problem in dimension N of the following
form (with λ ∈ R ﬁxed)

(cid:13)
(cid:13)Y −

min
x∈RN

N
X

i=1

x(i)di

(cid:13)
2
2 + λkxk1.
(cid:13)

Let D ∈ Rn×N be the dictionary matrix with ith column given by di.
Instead of considering the penalized version of the problem one could
look at the following constrained problem (with s ∈ R ﬁxed) on which
we will now focus, see e.g. Friedlander and Tseng [2007],

min
x∈RN

kY − Dxk2
2

subject to kxk1 ≤ s

⇔

kY /s − Dxk2
2

min
x∈RN
subject to kxk1 ≤ 1.

(3.10)

We make some assumptions on the dictionary. We are interested in
situations where the size of the dictionary N can be very large, poten-
tially exponential in the ambient dimension n. Nonetheless we want to
restrict our attention to algorithms that run in reasonable time with
respect to the ambient dimension n, that is we want polynomial time
algorithms in n. Of course in general this is impossible, and we need to
assume that the dictionary has some structure that can be exploited.
Here we make the assumption that one can do linear optimization over
the dictionary in polynomial time in n. More precisely we assume that
one can solve in time p(n) (where p is polynomial) the following prob-
lem for any y ∈ Rn:

min
1≤i≤N

y>di.

## 3.3 Conditional gradient descent, aka Frank-Wolfe


This assumption is met for many combinatorial dictionaries. For in-
stance the dicÂŋtioÂŋnary eleÂŋments could be vecÂŋtor of inciÂŋ-
dence of spanÂŋning trees in some ﬁxed graph, in which case the
linÂŋear optiÂŋmizaÂŋtion probÂŋlem can be solved with a greedy
algorithm.

Finally, for normalization issues, we assume that the ‘2-norm of
the dictionary elements are controlled by some m > 0, that is kdik2 ≤
m, ∀i ∈ [N ].

2 kY − Dxk2

Our problem of interest (3.10) corresponds to minimizing the func-
2 on the ‘1-ball of RN in polynomial time in
tion f (x) = 1
n. At ﬁrst sight this task may seem completely impossible, indeed one
is not even allowed to write down entirely a vector x ∈ RN (since this
would take time linear in N ). The key property that will save us is that
this function admits sparse minimizers as we discussed in the previous
section, and this will be exploited by the conditional gradient descent
method.

First let us study the computational complexity of the tth step of

conditional gradient descent. Observe that

∇f (x) = D>(Dx − Y ).

Now assume that zt = Dxt − Y ∈ Rn is already computed, then to
compute (3.8) one needs to ﬁnd the coordinate it ∈ [N ] that maximizes
|[∇f (xt)](i)| which can be done by maximizing d>
i zt. Thus
(3.8) takes time O(p(n)). Computing xt+1 from xt and it takes time
O(t) since kxtk0 ≤ t, and computing zt+1 from zt and it takes time
O(n). Thus the overall time complexity of running t steps is (we assume
p(n) = Ω(n))

i zt and −d>

O(tp(n) + t2).

(3.11)

To derive a rate of convergence it remains to study the smoothness

of f . This can be done as follows:

k∇f (x) − ∇f (y)k∞ = kD>D(x − y)k∞

= max
1≤i≤N

(cid:12)
(cid:12)
(cid:12)
(cid:12)



d>
i



N
X

j=1

≤ m2kx − yk1,

dj(x(j) − y(j))





(cid:12)
(cid:12)
(cid:12)
(cid:12)

276

Dimension-free convex optimization

which means that f is m2-smooth with respect to the ‘1-norm. Thus
we get the following rate of convergence:

f (xt) − f (x∗) ≤

8m2
t + 1

.

(3.12)

Putting together (3.11) and (3.12) we proved that one can get an ε-
optimal solution to (3.10) with a computational eﬀort of O(m2p(n)/ε+
m4/ε2) using the conditional gradient descent.

## 3.4 Strong convexity

We will now discuss another property of convex functions that can
signiﬁcantly speed-up the convergence of ﬁrst order methods: strong
convexity. We say that f : X → R is α-strongly convex if it satisﬁes the
following improved subgradient inequality:

f (x) − f (y) ≤ ∇f (x)>(x − y) −

α
2

kx − yk2.

(3.13)

Of course this deﬁnition does not require diﬀerentiability of the function
f , and one can replace ∇f (x) in the inequality above by g ∈ ∂f (x). It
is immediate to verify that a function f is α-strongly convex if and only
if x 7→ f (x) − α
2 kxk2 is convex (in particular if f is twice diﬀerentiable
then the eigenvalues of the Hessians of f have to be larger than α).
The strong convexity parameter α is a measure of the curvature of
f . For instance a linear function has no curvature and hence α = 0.
On the other hand one can clearly see why a large value of α would
lead to a faster rate: in this case a point far from the optimum will
have a large gradient, and thus gradient descent will make very big
steps when far from the optimum. Of course if the function is non-
smooth one still has to be careful and tune the step-sizes to be relatively
small, but nonetheless we will be able to improve the oracle complexity
from O(1/ε2) to O(1/(αε)). On the other hand with the additional
assumption of β-smoothness we will prove that gradient descent with
a constant step-size achieves a linear rate of convergence, precisely the
oracle complexity will be O( β
α log(1/ε)). This achieves the objective we
had set after Theorem 3.2: strongly-convex and smooth functions can
be optimized in very large dimension and up to very high accuracy.

## 3.4 Strong convexity


x (y) ≤ f (y), ∀y ∈ X (and q−

x (y) = f (x) + ∇f (x)>(y − x) + α

Before going into the proofs let us discuss another interpretation of
strong-convexity and its relation to smoothness. Equation (3.13) can
be read as follows: at any point x one can ﬁnd a (convex) quadratic
2 kx − yk2 to the function
lower bound q−
f , i.e. q−
x (x) = f (x)). On the other hand for
β-smoothness (3.4) implies that at any point y one can ﬁnd a (convex)
quadratic upper bound q+
2 kx − yk2 to
y (x) ≥ f (x), ∀x ∈ X (and q+
the function f , i.e. q+
y (y) = f (y)). Thus in
some sense strong convexity is a dual assumption to smoothness, and in
fact this can be made precise within the framework of Fenchel duality.
Also remark that clearly one always has β ≥ α.

y (x) = f (y) + ∇f (y)>(x − y) + β

3.4.1 Strongly convex and Lipschitz functions

We consider here the projected subgradient descent algorithm with
time-varying step size (ηt)t≥1, that is

yt+1 = xt − ηtgt, where gt ∈ ∂f (xt)
xt+1 = ΠX (yt+1).

The following result is extracted from Lacoste-Julien et al. [2012].

Theorem 3.9. Let f be α-strongly convex and L-Lipschitz on X . Then
projected subgradient descent with ηs = 2

α(s+1) satisﬁes

  t

X

f

s=1

!

2s
t(t + 1)

xs

− f (x∗) ≤

2L2
α(t + 1)

.

Proof. Coming back to our original analysis of projected subgradient
descent in Section 3.1 and using the strong convexity assumption one
immediately obtains
ηs
# 2 Multiplying this inequality by s yields

f (xs) − f (x∗) ≤

kxs+1 − x∗k2.

kxs − x∗k2 −

(cid:18) 1
2ηs

1
2ηs

L2 +

α
2

−

(cid:19)

s(f (xs) − f (x∗)) ≤

L2
α

+

(cid:18)

α
4

s(s − 1)kxs − x∗k2 − s(s + 1)kxs+1 − x∗k2

(cid:19)

,

Now sum the resulting inequality over s = 1 to s = t, and apply
Jensen’s inequality to obtain the claimed statement.

278

Dimension-free convex optimization

3.4.2 Strongly convex and smooth functions

As we will see now, having both strong convexity and smoothness allows
for a drastic improvement in the convergence rate. We denote κ = β
α
for the condition number of f . The key observation is that Lemma 3.6
can be improved to (with the notation of the lemma):

f (x+) − f (y) ≤ gX (x)>(x − y) −

1
2β

kgX (x)k2 −

α
2

kx − yk2.

(3.14)

Theorem 3.10. Let f be α-strongly convex and β-smooth on X . Then
projected gradient descent with η = 1
β satisﬁes for t ≥ 0,
(cid:18)

(cid:19)

kxt+1 − x∗k2 ≤ exp

−

kx1 − x∗k2.

t
κ

Proof. Using (3.14) with y = x∗ one directly obtains
1
β

kxt+1 − x∗k2 = kxt −

gX (xt) − x∗k2

= kxt − x∗k2 −

2
β

gX (xt)>(xt − x∗) +

# 1 β2 kgX (xt)k2

(cid:19)

kxt − x∗k2

≤

≤

(cid:18)

1 −

(cid:18)

1 −

α
β
α
β

(cid:19)t

kx1 − x∗k2
(cid:19)

kx1 − x∗k2,

≤ exp

(cid:18)

−

t
κ

which concludes the proof.

We now show that in the unconstrained case one can improve the
rate by a constant factor, precisely one can replace κ by (κ + 1)/4 in
the oracle complexity bound by using a larger step size. This is not a
spectacular gain but the reasoning is based on an improvement of (3.6)
which can be of interest by itself. Note that (3.6) and the lemma to
follow are sometimes referred to as coercivity of the gradient.

Lemma 3.11. Let f be β-smooth and α-strongly convex on Rn. Then
for all x, y ∈ Rn, one has

(∇f (x) − ∇f (y))>(x − y) ≥

αβ
β + α

kx − yk2 +

# 1 β + α

k∇f (x) − ∇f (y)k2.

## 3.5 Lower bounds


Proof. Let ϕ(x) = f (x) − α
2 kxk2. By deﬁnition of α-strong convexity
one has that ϕ is convex. Furthermore one can show that ϕ is (β − α)-
smooth by proving (3.4) (and using that it implies smoothness). Thus
using (3.6) one gets

(∇ϕ(x) − ∇ϕ(y))>(x − y) ≥

# 1 β − α

k∇ϕ(x) − ∇ϕ(y)k2,

which gives the claimed result with straightforward computations.
(Note that if α = β the smoothness of ϕ directly implies that
∇f (x) − ∇f (y) = α(x − y) which proves the lemma in this case.)

Theorem 3.12. Let f be β-smooth and α-strongly convex on Rn. Then
gradient descent with η = 2

α+β satisﬁes

f (xt+1) − f (x∗) ≤

β
2

(cid:18)

−

exp

(cid:19)

4t
κ + 1

kx1 − x∗k2.

Proof. First note that by β-smoothness (since ∇f (x∗) = 0) one has

f (xt) − f (x∗) ≤

β
2

kxt − x∗k2.

Now using Lemma 3.11 one obtains

kxt+1 − x∗k2 = kxt − η∇f (xt) − x∗k2

= kxt − x∗k2 − 2η∇f (xt)>(xt − x∗) + η2k∇f (xt)k2

(cid:19)

kxt − x∗k2 +

(cid:18)

η2 − 2

(cid:19)

η
β + α

k∇f (xt)k2

≤

=

ηαβ
β + α
(cid:19)2

(cid:18)

1 − 2

(cid:18) κ − 1
κ + 1
(cid:18)

≤ exp

−

kxt − x∗k2

(cid:19)

4t
κ + 1

kx1 − x∗k2,

which concludes the proof.

## 3.5 Lower bounds

We prove here various oracle complexity lower bounds. These results
ﬁrst appeared in Nemirovski and Yudin [1983] but we follow here the

280

Dimension-free convex optimization

simpliﬁed presentation of Nesterov [2004a]. In general a black-box pro-
cedure is a mapping from “history" to the next query point, that is it
maps (x1, g1, . . . , xt, gt) (with gs ∈ ∂f (xs)) to xt+1. In order to simplify
the notation and the argument, throughout the section we make the
following assumption on the black-box procedure: x1 = 0 and for any
t ≥ 0, xt+1 is in the linear span of g1, . . . , gt, that is

xt+1 ∈ Span(g1, . . . , gt).

(3.15)

Let e1, . . . , en be the canonical basis of Rn, and B2(R) = {x ∈ Rn :
kxk ≤ R}. We start with a theorem for the two non-smooth cases
(convex and strongly convex).

Theorem 3.13. Let t ≤ n, L, R > 0. There exists a convex and L-
Lipschitz function f such that for any black-box procedure satisfying
(3.15),

min
1≤s≤t

f (xs) − min

x∈B2(R)

f (x) ≥

RL
2(1 +

√

.

t)

There also exists an α-strongly convex and L-lipschitz function f such
that for any black-box procedure satisfying (3.15),

min
1≤s≤t

f (xs) − min
x∈B2( L

2α )

f (x) ≥

L2
8αt

.

Note that the above result is restricted to a number of iterations
smaller than the dimension, that is t ≤ n. This restriction is of course
necessary to obtain lower bounds polynomial in 1/t: as we saw in Chap-
ter 2 one can always obtain an exponential rate of convergence when
the number of calls to the oracle is larger than the dimension.

Proof. We consider the following α-strongly convex function:

f (x) = γ max
1≤i≤t

x(i) +

α
2

kxk2.

It is easy to see that

∂f (x) = αx + γconv

(cid:18)

ei, i : x(i) = max
1≤j≤t

(cid:19)

.

x(j)

In particular if kxk ≤ R then for any g ∈ ∂f (x) one has kgk ≤ αR + γ.
In other words f is (αR + γ)-Lipschitz on B2(R).

## 3.5 Lower bounds


Next we describe the ﬁrst order oracle for this function: when asked
for a subgradient at x, it returns αx+γei where i is the ﬁrst coordinate
that satisﬁes x(i) = max1≤j≤t x(j). In particular when asked for a
subgradient at x1 = 0 it returns e1. Thus x2 must lie on the line
generated by e1. It is easy to see by induction that in fact xs must lie
in the linear span of e1, . . . , es−1. In particular for s ≤ t we necessarily
have xs(t) = 0 and thus f (xs) ≥ 0.

It remains to compute the minimal value of f . Let y be such that
αt for 1 ≤ i ≤ t and y(i) = 0 for t + 1 ≤ i ≤ n. It is clear that

y(i) = − γ
0 ∈ ∂f (y) and thus the minimal value of f is

f (y) = −

γ2
αt

+

α
2

γ2
α2t

= −

γ2
2αt

.

Wrapping up, we proved that for any s ≤ t one must have

f (xs) − f (x∗) ≥

γ2
2αt

.

Taking γ = L/2 and R = L
2α we proved the lower bound for α-strongly
convex functions (note in particular that kyk2 = γ2
4α2t ≤ R2 with
t
these parameters). On the other taking α = L
# 1 and γ = L
√
√
R
1+
t
concludes the proof for convex functions (note in particular that kyk2 =
γ2
α2t = R2 with these parameters).

α2t = L2

1+

√

t

We proceed now to the smooth case. As we will see in the following
proofs we restrict our attention to quadratic functions, and it might
be useful to recall that in this case one can attain the exact optimum
in n calls to the oracle (see Section 2.4). We also recall that for a
twice diﬀerentiable function f , β-smoothness is equivalent to the largest
eigenvalue of the Hessians of f being smaller than β at any point, which
we write

∇2f (x) (cid:22) βIn, ∀x.

Furthermore α-strong convexity is equivalent to

∇2f (x) (cid:23) αIn, ∀x.

282

Dimension-free convex optimization

Theorem 3.14. Let t ≤ (n − 1)/2, β > 0. There exists a β-smooth
convex function f such that for any black-box procedure satisfying
(3.15),

min
1≤s≤t

f (xs) − f (x∗) ≥

3β
32

kx1 − x∗k2
(t + 1)2

.

Proof. In this proof for h : Rn → R we denote h∗ = inf x∈Rn h(x). For
k ≤ n let Ak ∈ Rn×n be the symmetric and tridiagonal matrix deﬁned
by




(Ak)i,j =

2,
−1,
0,
It is easy to verify that 0 (cid:22) Ak (cid:22) 4In since

i = j, i ≤ k
j ∈ {i − 1, i + 1}, i ≤ k, j 6= k + 1
otherwise.



x>Akx = 2

k
X

i=1

x(i)2−2

k−1
X

i=1

x(i)x(i+1) = x(1)2+x(k)2+

(x(i)−x(i+1))2.

k−1
X

i=1

We consider now the following β-smooth convex function:

f (x) =

β
8

x>A2t+1x −

β
4

x>e1.

Similarly to what happened in the proof Theorem 3.13, one can see
here too that xs must lie in the linear span of e1, . . . , es−1 (because of
our assumption on the black-box procedure). In particular for s ≤ t we
necessarily have xs(i) = 0 for i = s, . . . , n, which implies x>
s A2t+1xs =
x>
s Asxs. In other words, if we denote

fk(x) =

β
8

x>Akx −

β
4

x>e1,

then we just proved that

f (xs) − f ∗ = fs(xs) − f ∗

2t+1 ≥ f ∗
Thus it simply remains to compute the minimizer x∗
and the corresponding function value f ∗
k .

2t+1 ≥ f ∗

s − f ∗

t − f ∗

2t+1.

k of fk, its norm,

The point x∗

Akx = e1. It is easy to verify that it is deﬁned by x∗
i = 1, . . . , k. Thus we immediately have:

k is the unique solution in the span of e1, . . . , ek of
k+1 for

k(i) = 1 − i

f ∗
k =

β
8

(x∗

k)>Akx∗

k −

β
4

(x∗

k)>e1 = −

β
8

(x∗

k)>e1 = −

β
8

(cid:18)

1 −

(cid:19)

.

# 1 k + 1

## 3.5 Lower bounds


Furthermore note that

kx∗

kk2 =

k
X

(cid:18)

i=1

1 −

(cid:19)2

=

i
k + 1

k
X

(cid:18) i

(cid:19)2

k + 1

i=1

≤

k + 1
3

.

Thus one obtains:

t − f ∗
f ∗

2t+1 =

β
8

(cid:18) 1

t + 1

−

1
2t + 2

(cid:19)

≥

3β
32

kx∗
2t+1k2
(t + 1)2 ,

which concludes the proof.

To simplify the proof of the next theorem we will consider the lim-
iting situation n → +∞. More precisely we assume now that we are
working in ‘2 = {x = (x(n))n∈N : P+∞
i=1 x(i)2 < +∞} rather than in
Rn. Note that all the theorems we proved in this chapter are in fact
valid in an arbitrary Hilbert space H. We chose to work in Rn only for
clarity of the exposition.

Theorem 3.15. Let κ > 1. There exists a β-smooth and α-strongly
convex function f : ‘2 → R with κ = β/α such that for any t ≥ 1 and
any black-box procedure satisfying (3.15) one has

f (xt) − f (x∗) ≥

  √
√

α
2

κ − 1
κ + 1

!2(t−1)

kx1 − x∗k2.

Note that for large values of the condition number κ one has

!2(t−1)

  √
√

κ − 1
κ + 1

≈ exp

(cid:18)

−

4(t − 1)
√
κ

(cid:19)

.

Proof. The overall argument is similar to the proof of Theorem 3.14.
Let A : ‘2 → ‘2 be the linear operator that corresponds to the inﬁnite
tridiagonal matrix with 2 on the diagonal and −1 on the upper and
lower diagonals. We consider now the following function:

f (x) =

α(κ − 1)
8

(hAx, xi − 2he1, xi) +

α
2

kxk2.

We already proved that 0 (cid:22) A (cid:22) 4I which easily implies that f is α-
strongly convex and β-smooth. Now as always the key observation is

284

Dimension-free convex optimization

that for this function, thanks to our assumption on the black-box pro-
cedure, one necessarily has xt(i) = 0, ∀i ≥ t. This implies in particular:

kxt − x∗k2 ≥

+∞
X

i=t

x∗(i)2.

Furthermore since f is α-strongly convex, one has

f (xt) − f (x∗) ≥

α
2

kxt − x∗k2.

Thus it only remains to compute x∗. This can be done by diﬀerentiating
f and setting the gradient to 0, which gives the following inﬁnite set
of equations

x∗(1) + x∗(2) = 0,

1 − 2

κ + 1
κ − 1
x∗(k − 1) − 2

κ + 1
κ − 1

x∗(k) + x∗(k + 1) = 0, ∀k ≥ 2.

It is easy to verify that x∗ deﬁned by x∗(i) =
satisfy this
inﬁnite set of equations, and the conclusion of the theorem then follows
by straightforward computations.

κ−1√
κ+1

(cid:16) √

(cid:17)i

## 3.6 Geometric descent

√

√

ε) (respectively Ω(

So far our results leave a gap in the case of smooth optimization: gra-
dient descent achieves an oracle complexity of O(1/ε) (respectively
O(κ log(1/ε)) in the strongly convex case) while we proved a lower
κ log(1/ε))). In this section we
bound of Ω(1/
close these gaps with the geometric descent method which was re-
cently introduced in Bubeck et al. [2015b]. Historically the ﬁrst method
with optimal oracle complexity was proposed in Nemirovski and Yudin
[1983]. This method, inspired by the conjugate gradient (see Section
2.4), assumes an oracle to compute plane searches. In Nemirovski [1982]
this assumption was relaxed to a line search oracle (the geometric de-
scent method also requires a line search oracle). Finally in Nesterov
[1983] an optimal method requiring only a ﬁrst order oracle was in-
troduced. The latter algorithm, called Nesterov’s accelerated gradient

## 3.6 Geometric descent


descent, has been the most inﬂuential optimal method for smooth opti-
mization up to this day. We describe and analyze this method in Section
## 3.7 As we shall see the intuition behind Nesterov’s accelerated gradient
descent (both for the derivation of the algorithm and its analysis) is
not quite transparent, which motivates the present section as geometric
descent has a simple geometric interpretation loosely inspired from the
ellipsoid method (see Section 2.2).

√

√

We focus here on the unconstrained optimization of a smooth and
strongly convex function, and we prove that geometric descent achieves
the oracle complexity of O(
κ log(1/ε)), thus reducing the complex-
κ. We note that this
ity of the basic gradient descent by a factor
improvement is quite relevant for machine learning applications. Con-
sider for example the logistic regression problem described in Section
1.1: this is a smooth and strongly convex problem, with a smoothness
of order of a numerical constant, but with strong convexity equal to the
regularization parameter whose inverse can be as large as the sample
size. Thus in this case κ can be of order of the sample size, and a faster
κ is quite signiﬁcant. We also observe that this
rate by a factor of
improved rate for smooth and strongly convex objectives also implies
an almost optimal rate of O(log(1/ε)/
ε) for the smooth case, as one
can simply run geometric descent on the function x 7→ f (x) + εkxk2.

√

√

In Section 3.6.1 we describe the basic idea of geometric descent, and
we show how to obtain eﬀortlessly a geometric method with an oracle
complexity of O(κ log(1/ε)) (i.e., similar to gradient descent). Then we
explain why one should expect to be able to accelerate this method in
Section 3.6.2. The geometric descent method is described precisely and
analyzed in Section 3.6.3.

3.6.1 Warm-up: a geometric alternative to gradient descent

We start with some notation. Let B(x, r2) := {y ∈ Rn : ky − xk2 ≤ r2}
(note that the second argument is the radius squared), and

x+ = x −

1
β

∇f (x), and x++ = x −

1
α

∇f (x).

286

Dimension-free convex optimization

|g|

1

√

1 − ε

√

1 − ε |g|

Figure 3.4: One ball shrinks.

Rewriting the deﬁnition of strong convexity (3.13) as

⇔ α

f (y) ≥ f (x) + ∇f (x)>(y − x) + α
2 ky − x + 1

2 ky − xk2
2α − (f (x) − f (y)),

α ∇f (x)k2 ≤ k∇f (x)k2
one obtains an enclosing ball for the minimizer of f with the 0th and
1st order information at x:

x∗ ∈ B

x++,

k∇f (x)k2
α2

−

2
α

!

(f (x) − f (x∗))

.

Furthermore recall that by smoothness (see (3.5)) one has f (x+) ≤
f (x) − 1
2β k∇f (x)k2 which allows to shrink the above ball by a factor
of 1 − 1
κ and obtain the following:

x∗ ∈ B

x++,

k∇f (x)k2
α2

(cid:18)

1 −

(cid:19)

1
κ

−

2
α

(f (x+) − f (x∗))

(3.16)

!

This suggests a natural strategy: assuming that one has an enclosing
ball A := B(x, R2) for x∗ (obtained from previous steps of the strat-
egy), one can then enclose x∗ in a ball B containing the intersection
x++, k∇f (x)k2
of B(x, R2) and the ball B
obtained by (3.16).
Provided that the radius of B is a fraction of the radius of A, one can

1 − 1
κ

(cid:17)(cid:17)

α2

(cid:16)

(cid:16)



## 3.6 Geometric descent


p

√

ε

1 −

√

1 − ε |g|

p1 − ε|g|2

Figure 3.5: Two balls shrink.

then iterate the procedure by replacing A by B, leading to a linear
convergence rate. Evaluating the rate at which the radius shrinks is an
elementary calculation: for any g ∈ Rn, ε ∈ (0, 1), there exists x ∈ Rn
such that

B(0, 1) ∩ B(g, kgk2(1 − ε)) ⊂ B(x, 1 − ε).

(Figure 3.4)

Thus we see that in the strategy described above, the radius squared
of the enclosing ball for x∗ shrinks by a factor 1 − 1
κ at each iteration,
thus matching the rate of convergence of gradient descent (see Theorem
3.10).

3.6.2 Acceleration

In the argument from the previous section we missed the following
opportunity: observe that the ball A = B(x, R2) was obtained by inter-
sections of previous balls of the form given by (3.16), and thus the
new value f (x) could be used to reduce the radius of those previ-
ous balls too (an important caveat is that the value f (x) should be
smaller than the values used to build those previous balls). Poten-
tially this could show that the optimum is in fact contained in the
ball B
. By taking the intersection with the ball

x, R2 − 1

κ k∇f (x)k2(cid:17)

(cid:16)

288

Dimension-free convex optimization

(cid:16)

x++, k∇f (x)k2

(cid:16)

1 − 1
κ

(cid:17)(cid:17)

α2

B
radius shrunk by a factor 1 − 1√
g ∈ Rn, ε ∈ (0, 1), there exists x ∈ Rn such that

this would allow to obtain a new ball with
κ ): indeed for any

κ (instead of 1 − 1

B(0, 1 − εkgk2) ∩ B(g, kgk2(1 − ε)) ⊂ B(x, 1 −

√

ε).

(Figure 3.5)

Thus it only remains to deal with the caveat noted above, which we
do via a line search. In turns this line search might shift the new ball
(3.16), and to deal with this we shall need the following strengthening
of the above set inclusion (we refer to Bubeck et al. [2015b] for a simple
proof of this result):

Lemma 3.16. Let a ∈ Rn and ε ∈ (0, 1), g ∈ R+. Assume that kak ≥ g.
Then there exists c ∈ Rn such that for any δ ≥ 0,

B(0, 1 − εg2 − δ) ∩ B(a, g2(1 − ε) − δ) ⊂ B (cid:0)c, 1 −

√

ε − δ(cid:1) .

3.6.3 The geometric descent method

Let x0 ∈ Rn, c0 = x++

0

, and R2

0 =

(cid:16)

1 − 1
κ

(cid:17) k∇f (x0)k2
α2

. For any t ≥ 0 let

xt+1 =

argmin
x∈{(1−λ)ct+λx+

t , λ∈R}

f (x),

and ct+1 (respectively R2
t+1) be the center (respectively the squared
radius) of the ball given by (the proof of) Lemma 3.16 which contains

B

ct, R2

t −

!

k∇f (xt+1)k2
α2κ

∩ B

x++
t+1,

k∇f (xt+1)k2
α2

(cid:18)

1 −

(cid:19)!

.

1
κ

Formulas for ct+1 and R2

Theorem 3.17. For any t ≥ 0, one has x∗ ∈ B(ct, R2
(cid:16)
1 − 1√
κ

t , and thus

R2

(cid:17)

t+1 are given at the end of this section.
t ), R2

t+1 ≤

kx∗ − ctk2 ≤

(cid:18)

1 −

(cid:19)t

1
√
κ

R2
0.

Proof. We will prove a stronger claim by induction that for each t ≥ 0,
one has

(cid:18)

x∗ ∈ B

ct, R2

t −

f (x+

t ) − f (x∗)

(cid:17)(cid:19)

.

(cid:16)

2
α



## 3.7 Nesterov’s accelerated gradient descent


The case t = 0 follows immediately by (3.16). Let us assume that the
above display is true for some t ≥ 0. Then using f (x+
t+1) ≤ f (xt+1) −
2β k∇f (xt+1)k2 ≤ f (x+
1

2β k∇f (xt+1)k2, one gets

t ) − 1

x∗ ∈ B

ct, R2

t −

k∇f (xt+1)k2
α2κ

−

2
α

(cid:16)

f (x+

(cid:17)
t+1) − f (x∗)

!

.

Furthermore by (3.16) one also has

B

x++
t+1,

k∇f (xt+1)k2
α2

(cid:18)

1 −

(cid:19)

1
κ

−

2
α

(cid:16)

f (x+

(cid:17)
t+1) − f (x∗)

!

.

(cid:17)

(cid:16)

R2

t − 2

1 − 1√
κ

α (f (x+

Thus it only remains to observe that the squared radius of the ball given
by Lemma 3.16 which encloses the intersection of the two above balls is
t+1) − f (x∗)). We apply Lemma 3.16
smaller than
after moving ct to the origin and scaling distances by Rt. We set ε = 1
κ ,
(cid:17)
g = k∇f (xt+1)k
t+1) − f (x∗)
t+1 − ct. The line
search step of the algorithm implies that ∇f (xt+1)>(xt+1 − ct) = 0 and
therefore, kak = kx++
t+1 − ctk ≥ k∇f (xt+1)k/α = g and Lemma 3.16
applies to give the result.

and a = x++

, δ = 2
α

f (x+

(cid:16)

α

One can use the following formulas for ct+1 and R2

derived from the proof of Lemma 3.16). If |∇f (xt+1)|2/α2 < R2
then one can tate ct+1 = x++
t+1 and R2
other hand if |∇f (xt+1)|2/α2 ≥ R2

t+1 = |∇f (xt+1)|2
t /2 then one can tate

1 − 1
κ

α2

(cid:16)

(cid:17)

t+1 (they are
t /2
. On the

ct+1 = ct +

R2

t + |xt+1 − ct|2
2|x++
t+1 − ct|2

(x++

t+1 − ct),

R2

t+1 = R2

t −

|∇f (xt+1)|2
α2κ

−

R2

t + kxt+1 − ctk2
2kx++
t+1 − ctk

!2

.

## 3.7 Nesterov’s accelerated gradient descent

We describe here the original Nesterov’s method which attains the op-
timal oracle complexity for smooth convex optimization. We give the
details of the method both for the strongly convex and non-strongly
convex case. We refer to Su et al. [2014] for a recent interpretation of




290

Dimension-free convex optimization

xs+1

xs+2

ys+2

− 1

β ∇f (xs)

ys+1

xs

ys

Figure 3.6: Illustration of Nesterov’s accelerated gradient descent.

the method in terms of diﬀerential equations, and to Allen-Zhu and
Orecchia [2014] for its relation to mirror descent (see Chapter 4).

3.7.1 The smooth and strongly convex case

Nesterov’s accelerated gradient descent, illustrated in Figure 3.6, can
be described as follows: Start at an arbitrary initial point x1 = y1 and
then iterate the following equations for t ≥ 1,

yt+1 = xt −

xt+1 =

1 +

# 1 ∇f (xt),
β
√
√

κ − 1
κ + 1

!

yt+1 −

√
√

κ − 1
κ + 1

yt.

Theorem 3.18. Let f be α-strongly convex and β-smooth, then Nes-
terov’s accelerated gradient descent satisﬁes

f (yt) − f (x∗) ≤

α + β
2

kx1 − x∗k2 exp

(cid:18)

−

(cid:19)

.

t − 1
√
κ

Proof. We deﬁne α-strongly convex quadratic functions Φs, s ≥ 1 by


## 3.7 Nesterov’s accelerated gradient descent


induction as follows:

Φ1(x) = f (x1) +

Φs+1(x) =

(cid:18)

1 −

α
2
1
√
κ

kx − x1k2,
(cid:19)

Φs(x)

+

1
√
κ

(cid:18)

f (xs) + ∇f (xs)>(x − xs) +

kx − xsk2

(cid:19)

.

α
2

(3.17)

Intuitively Φs becomes a ﬁner and ﬁner approximation (from below) to
f in the following sense:

Φs+1(x) ≤ f (x) +

(cid:18)

1 −

(cid:19)s

1
√
κ

(Φ1(x) − f (x)).

(3.18)

The above inequality can be proved immediately by induction, using
the fact that by α-strong convexity one has

f (xs) + ∇f (xs)>(x − xs) +

α
2

kx − xsk2 ≤ f (x).

Equation (3.18) by itself does not say much, for it to be useful one
needs to understand how “far" below f is Φs. The following inequality
answers this question:

f (ys) ≤ min
x∈Rn

Φs(x).

(3.19)

The rest of the proof is devoted to showing that (3.19) holds true, but
ﬁrst let us see how to combine (3.18) and (3.19) to obtain the rate given
by the theorem (we use that by β-smoothness one has f (x) − f (x∗) ≤
β
2 kx − x∗k2):

f (yt) − f (x∗) ≤ Φt(x∗) − f (x∗)
(cid:19)t−1

(cid:18)

≤

1 −

1
√
κ

(Φ1(x∗) − f (x∗))

≤

α + β
2

kx1 − x∗k2

(cid:18)

1 −

(cid:19)t−1

.

1
√
κ

We now prove (3.19) by induction (note that it is true at s = 1 since
x1 = y1). Let Φ∗
s = minx∈Rn Φs(x). Using the deﬁnition of ys+1 (and

292

Dimension-free convex optimization

β-smoothness), convexity, and the induction hypothesis, one gets

f (ys+1) ≤ f (xs) −

1
2β
(cid:19)

1
√
κ

k∇f (xs)k2
(cid:18)

f (ys) +

1 −

(cid:19)

1
√
κ

(f (xs) − f (ys))

f (xs) −

1
2β

k∇f (xs)k2

(cid:19)

1
√
κ

(cid:18)

1 −

Φ∗

s +

(cid:19)

1
√
κ

∇f (xs)>(xs − ys)

f (xs) −

1
2β

k∇f (xs)k2.

=

≤

(cid:18)

1 −

+

1
√
κ

(cid:18)

1 −

+

1
√
κ

Thus we now have to show that

Φ∗

s+1 ≥

(cid:18)

1 −

(cid:19)

1
√
κ

(cid:18)

1 −

Φ∗

s +

(cid:19)

1
√
κ

∇f (xs)>(xs − ys)

+

1
√
κ

f (xs) −

1
2β

k∇f (xs)k2.

(3.20)

To prove this inequality we have to understand better the functions
Φs. First note that ∇2Φs(x) = αIn (immediate by induction) and thus
Φs has to be of the following form:

Φs(x) = Φ∗

s +
for some vs ∈ Rn. Now observe that by diﬀerentiating (3.17) and using
the above form of Φs one obtains

kx − vsk2,

α
2

∇Φs+1(x) = α

(cid:18)

1 −

(cid:19)

1
√
κ

(x − vs) +

1
√
κ

∇f (xs) +

α
√
κ

(x − xs).

In particular Φs+1 is by deﬁnition minimized at vs+1 which can now be
deﬁned by induction using the above identity, precisely:
1
√
κ

∇f (xs).

1
√
κ

vs+1 =

(3.21)

xs −

vs +

1 −

1
√

α

(cid:18)

(cid:19)

κ

Using the form of Φs and Φs+1, as well as the original deﬁnition (3.17)
one gets the following identity by evaluating Φs+1 at xs:

α
2

Φ∗

s+1 +
(cid:18)

=

1 −

kxs − vs+1k2
(cid:18)
α
1
√
2
κ

s +

Φ∗

(cid:19)

1 −

(cid:19)

1
√
κ

kxs − vsk2 +

1
√
κ

f (xs).

(3.22)

## 3.7 Nesterov’s accelerated gradient descent


Note that thanks to (3.21) one has

kxs − vs+1k2 =

(cid:18)

1 −

2
√

−

α

κ

1
√
κ
(cid:18)

(cid:19)2

kxs − vsk2 +

1
α2κ

k∇f (xs)k2

1 −

(cid:19)

1
√
κ

∇f (xs)>(vs − xs),

which combined with (3.22) yields

Φ∗

s+1 =

(cid:18)

1 −

1
√
κ
1
2β

−

(cid:19)

Φ∗

s +

1
√
κ

f (xs) +

α
√

2

κ

(cid:18)

1 −

(cid:19)

1
√
κ

kxs − vsk2

k∇f (xs)k2 +

(cid:18)

1 −

1
√
κ

(cid:19)

∇f (xs)>(vs − xs).

Finally we show by induction that vs − xs =
κ(xs − ys), which con-
cludes the proof of (3.20) and thus also concludes the proof of the
theorem:

vs+1 − xs+1 =

(cid:18)

1 −

(cid:19)

1
√
κ

vs +

1
√
κ

1
√

κ

∇f (xs) − xs+1

xs −
√

α
κ
β

√

κxs − (

√

κ − 1)ys −
√

κys+1 − (
κ(xs+1 − ys+1),

κ − 1)ys − xs+1

=

=

=

√

√

∇f (xs) − xs+1

1
√
κ
√

where the ﬁrst equality comes from (3.21), the second from the induc-
tion hypothesis, the third from the deﬁnition of ys+1 and the last one
from the deﬁnition of xs+1.

3.7.2 The smooth case

In this section we show how to adapt Nesterov’s accelerated gradient
descent for the case α = 0, using a time-varying combination of the
elements in the primary sequence (yt). First we deﬁne the following
sequences:

λ0 = 0, λt =

1 +

q

1 + 4λ2

t−1

2

, and γt =

1 − λt
λt+1

.

294

Dimension-free convex optimization

(Note that γt ≤ 0.) Now the algorithm is simply deﬁned by the following
equations, with x1 = y1 an arbitrary initial point,

yt+1 = xt −

1
β

∇f (xt),

xt+1 = (1 − γs)yt+1 + γtyt.

Theorem 3.19. Let f be a convex and β-smooth function, then Nes-
terov’s accelerated gradient descent satisﬁes

f (yt) − f (x∗) ≤

2βkx1 − x∗k2
t2

.

We follow here the proof of Beck and Teboulle [2009]. We also refer

to Tseng [2008] for a proof with simpler step-sizes.

Proof. Using the unconstrained version of Lemma 3.6 one obtains

f (ys+1) − f (ys)

≤ ∇f (xs)>(xs − ys) −

1
2β

k∇f (xs)k2

= β(xs − ys+1)>(xs − ys) −

β
2

kxs − ys+1k2.

(3.23)

Similarly we also get

f (ys+1) − f (x∗) ≤ β(xs − ys+1)>(xs − x∗) −

β
2

kxs − ys+1k2.

(3.24)

Now multiplying (3.23) by (λs − 1) and adding the result to (3.24), one
obtains with δs = f (ys) − f (x∗),

λsδs+1 − (λs − 1)δs

≤ β(xs − ys+1)>(λsxs − (λs − 1)ys − x∗) −

β
2

λskxs − ys+1k2.

Multiplying this inequality by λs and using that by deﬁnition λ2
s−1 =
s −λs, as well as the elementary identity 2a>b−kak2 = kbk2 −kb−ak2,
λ2

## 3.7 Nesterov’s accelerated gradient descent


one obtains

sδs+1 − λ2
λ2
(cid:18)

s−1δs

≤

=

β
2
β
2

2λs(xs − ys+1)>(λsxs − (λs − 1)ys − x∗) − kλs(ys+1 − xs)k2

(cid:18)

kλsxs − (λs − 1)ys − x∗k2 − kλsys+1 − (λs − 1)ys − x∗k2

Next remark that, by deﬁnition, one has

xs+1 = ys+1 + γs(ys − ys+1)
⇔ λs+1xs+1 = λs+1ys+1 + (1 − λs)(ys − ys+1)
⇔ λs+1xs+1 − (λs+1 − 1)ys+1 = λsys+1 − (λs − 1)ys.

Putting together (3.25) and (3.26) one gets with us = λsxs − (λs −
1)ys − x∗,

sδs+1 − λ2
λ2

s−1δ2

s ≤

β
2

(cid:18)

kusk2 − kus+1k2

(cid:19)

.

Summing these inequalities from s = 1 to s = t − 1 one obtains:

δt ≤

β
2λ2

t−1

ku1k2.

By induction it is easy to see that λt−1 ≥ t

2 which concludes the proof.

(cid:19)

(cid:19)

.

(3.25)

(3.26)

4

Almost dimension-free convex optimization in
non-Euclidean spaces

In the previous chapter we showed that dimension-free oracle com-
plexity is possible when the objective function f and the constraint
set X are well-behaved in the Euclidean norm; e.g. if for all points
x ∈ X and all subgradients g ∈ ∂f (x), one has that kxk2 and kgk2
are independent of the ambient dimension n. If this assumption is not
met then the gradient descent techniques of Chapter 3 may lose their
dimension-free convergence rates. For instance consider a diﬀerentiable
convex function f deﬁned on the Euclidean ball B2,n and such that
n, and thus
k∇f (x)k∞ ≤ 1, ∀x ∈ B2,n. This implies that k∇f (x)k2 ≤
projected gradient descent will converge to the minimum of f on B2,n
at a rate pn/t. In this chapter we describe the method of Nemirovski
and Yudin [1983], known as mirror descent, which allows to ﬁnd the
minimum of such functions f over the ‘1-ball (instead of the Euclidean
ball) at the much faster rate plog(n)/t. This is only one example of
the potential of mirror descent. This chapter is devoted to the descrip-
tion of mirror descent and some of its alternatives. The presentation
is inspired from Beck and Teboulle [2003], [Chapter 11, Cesa-Bianchi
and Lugosi [2006]], Rakhlin [2009], Hazan [2011], Bubeck [2011].

√

296

297

In order to describe the intuition behind the method let us abstract
the situation for a moment and forget that we are doing optimization in
ﬁnite dimension. We already observed that projected gradient descent
works in an arbitrary Hilbert space H. Suppose now that we are in-
terested in the more general situation of optimization in some Banach
space B. In other words the norm that we use to measure the various
quantity of interest does not derive from an inner product (think of
B = ‘1 for example). In that case the gradient descent strategy does
not even make sense: indeed the gradients (more formally the Fréchet
derivative) ∇f (x) are elements of the dual space B∗ and thus one can-
not perform the computation x − η∇f (x) (it simply does not make
sense). We did not have this problem for optimization in a Hilbert
space H since by Riesz representation theorem H∗ is isometric to H.
The great insight of Nemirovski and Yudin is that one can still do a
gradient descent by ﬁrst mapping the point x ∈ B into the dual space
B∗, then performing the gradient update in the dual space, and ﬁnally
mapping back the resulting point to the primal space B. Of course the
new point in the primal space might lie outside of the constraint set
X ⊂ B and thus we need a way to project back the point on the con-
straint set X . Both the primal/dual mapping and the projection are
based on the concept of a mirror map which is the key element of the
scheme. Mirror maps are deﬁned in Section 4.1, and the above scheme
is formally described in Section 4.2.

In the rest of this chapter we ﬁx an arbitrary norm k · k on Rn,
and a compact convex set X ⊂ Rn. The dual norm k · k∗ is deﬁned as
kgk∗ = supx∈Rn:kxk≤1 g>x. We say that a convex function f : X → R
is (i) L-Lipschitz w.r.t. k · k if ∀x ∈ X , g ∈ ∂f (x), kgk∗ ≤ L, (ii) β-
smooth w.r.t. k · k if k∇f (x) − ∇f (y)k∗ ≤ βkx − yk, ∀x, y ∈ X , and (iii)
α-strongly convex w.r.t. k · k if

f (x) − f (y) ≤ g>(x − y) −

α
2

kx − yk2, ∀x, y ∈ X , g ∈ ∂f (x).

We also deﬁne the Bregman divergence associated to f as

Df (x, y) = f (x) − f (y) − ∇f (y)>(x − y).

The following identity will be useful several times:

(∇f (x) − ∇f (y))>(x − z) = Df (x, y) + Df (z, x) − Df (z, y).

(4.1)

298 Almost dimension-free convex optimization in non-Euclidean spaces

## 4.1 Mirror maps

Let D ⊂ Rn be a convex open set such that X is included in its closure,
that is X ⊂ D, and X ∩ D 6= ∅. We say that Φ : D → R is a mirror
map if it saﬁsﬁes the following properties1:

(i) Φ is strictly convex and diﬀerentiable.

(ii) The gradient of Φ takes all possible values, that is ∇Φ(D) = Rn.

(iii) The gradient of Φ diverges on the boundary of D, that is

lim
x→∂D

k∇Φ(x)k = +∞.

In mirror descent the gradient of the mirror map Φ is used to map
points from the “primal" to the “dual" (note that all points lie in Rn so
the notions of primal and dual spaces only have an intuitive meaning).
Precisely a point x ∈ X ∩ D is mapped to ∇Φ(x), from which one takes
a gradient step to get to ∇Φ(x) − η∇f (x). Property (ii) then allows
us to write the resulting point as ∇Φ(y) = ∇Φ(x) − η∇f (x) for some
y ∈ D. The primal point y may lie outside of the set of constraints
X , in which case one has to project back onto X . In mirror descent
this projection is done via the Bregman divergence associated to Φ.
Precisely one deﬁnes

ΠΦ

X (y) = argmin
x∈X ∩D

DΦ(x, y).

Property (i) and (iii) ensures the existence and uniqueness of this pro-
jection (in particular since x 7→ DΦ(x, y) is locally increasing on the
boundary of D). The following lemma shows that the Bregman diver-
gence essentially behaves as the Euclidean norm squared in terms of
projections (recall Lemma 3.1).

Lemma 4.1. Let x ∈ X ∩ D and y ∈ D, then

(∇Φ(ΠΦ

X (y)) − ∇Φ(y))>(ΠΦ

X (y) − x) ≤ 0,

1Assumption (ii) can be relaxed in some cases, see for example Audibert et al.

[2014].

## 4.2 Mirror descent


∇Φ

∇Φ(xt)

gradient step
(4.2)

∇Φ(yt+1)

xt

xt+1
X

Rn

(∇Φ)−1

projection (4.3)

yt+1

D

Figure 4.1: Illustration of mirror descent.

which also implies

DΦ(x, ΠΦ

X (y)) + DΦ(ΠΦ

X (y), y) ≤ DΦ(x, y).

Proof. The proof is an immediate corollary of Proposition 1.3 together
with the fact that ∇xDΦ(x, y) = ∇Φ(x) − ∇Φ(y).

## 4.2 Mirror descent

We can now describe the mirror descent strategy based on a mirror
map Φ. Let x1 ∈ argminx∈X ∩D Φ(x). Then for t ≥ 1, let yt+1 ∈ D such
that

∇Φ(yt+1) = ∇Φ(xt) − ηgt, where gt ∈ ∂f (xt),

(4.2)

and

xt+1 ∈ ΠΦ

X (yt+1).

(4.3)

See Figure 4.1 for an illustration of this procedure.

Theorem 4.2. Let Φ be a mirror map ρ-strongly convex on X ∩ D
w.r.t. k · k. Let R2 = supx∈X ∩D Φ(x) − Φ(x1), and f be convex and

300 Almost dimension-free convex optimization in non-Euclidean spaces

L-Lipschitz w.r.t. k · k. Then mirror descent with η = R
L

q 2ρ

t satisﬁes

f

(cid:18) 1
t

t
X

s=1

(cid:19)

xs

s

− f (x∗) ≤ RL

2
ρt

.

Proof. Let x ∈ X ∩ D. The claimed bound will be obtained by taking a
limit x → x∗. Now by convexity of f , the deﬁnition of mirror descent,
equation (4.1), and Lemma 4.1, one has

=

f (xs) − f (x)
≤ g>
s (xs − x)
1
η
1
η
1
η

=

≤

(cid:18)

(cid:18)

(∇Φ(xs) − ∇Φ(ys+1))>(xs − x)

DΦ(x, xs) + DΦ(xs, ys+1) − DΦ(x, ys+1)

(cid:19)

DΦ(x, xs) + DΦ(xs, ys+1) − DΦ(x, xs+1) − DΦ(xs+1, ys+1)

.

(cid:19)

The term DΦ(x, xs) − DΦ(x, xs+1) will lead to a telescopic sum when
summing over s = 1 to s = t, and it remains to bound the other term
as follows using ρ-strong convexity of the mirror map and az − bz2 ≤
a2
4b , ∀z ∈ R:

DΦ(xs, ys+1) − DΦ(xs+1, ys+1)
= Φ(xs) − Φ(xs+1) − ∇Φ(ys+1)>(xs − xs+1)
≤ (∇Φ(xs) − ∇Φ(ys+1))>(xs − xs+1) −

ρ
2

kxs − xs+1k2

= ηg>

s (xs − xs+1) −

≤ ηLkxs − xs+1k −

kxs − xs+1k2

ρ
2
ρ
kxs − xs+1k2
2

≤

(ηL)2
2ρ

.

We proved

t
X

s=1

(cid:18)

f (xs) − f (x)

(cid:19)

≤

DΦ(x, x1)
η

+ η

L2t
2ρ

,

which concludes the proof up to trivial computation.

## 4.3 Standard setups for mirror descent


We observe that one can rewrite mirror descent as follows:

xt+1 = argmin
x∈X ∩D
= argmin
x∈X ∩D
= argmin
x∈X ∩D
= argmin
x∈X ∩D

DΦ(x, yt+1)

Φ(x) − ∇Φ(yt+1)>x

Φ(x) − (∇Φ(xt) − ηgt)>x

ηg>

t x + DΦ(x, xt).

(4.4)

(4.5)

This last expression is often taken as the deﬁnition of mirror descent
(see Beck and Teboulle [2003]). It gives a proximal point of view on
mirror descent: the method is trying to minimize the local linearization
of the function while not moving too far away from the previous point,
with distances measured via the Bregman divergence of the mirror map.

## 4.3 Standard setups for mirror descent

2 kxk2

“Ball setup". The simplest version of mirror descent is obtained by
2 on D = Rn. The function Φ is a mirror map
taking Φ(x) = 1
strongly convex w.r.t. k · k2, and furthermore the associated Bregman
divergence is given by DΦ(x, y) = 1
2. Thus in that case mirror
descent is exactly equivalent to projected subgradient descent, and the
rate of convergence obtained in Theorem 4.2 recovers our earlier result
on projected subgradient descent.

2 kx − yk2

“Simplex setup". A more interesting choice of a mirror map is given
by the negative entropy

Φ(x) =

n
X

i=1

x(i) log x(i),

on D = Rn
η∇f (xt) can be written equivalently as

++. In that case the gradient update ∇Φ(yt+1) = ∇Φ(xt) −

yt+1(i) = xt(i) exp (cid:0) − η[∇f (xt)](i)(cid:1), i = 1, . . . , n.

The Bregman divergence of this mirror map is given by DΦ(x, y) =
Pn
y(i) (also known as the Kullback-Leibler divergence). It

i=1 x(i) log x(i)

302 Almost dimension-free convex optimization in non-Euclidean spaces

is easy to verify that the projection with respect to this Bregman di-
vergence on the simplex ∆n = {x ∈ Rn
i=1 x(i) = 1} amounts
to a simple renormalization y 7→ y/kyk1. Furthermore it is also easy
to verify that Φ is 1-strongly convex w.r.t. k · k1 on ∆n (this result
is known as Pinsker’s inequality). Note also that for X = ∆n one has
x1 = (1/n, . . . , 1/n) and R2 = log n.

+ : Pn

The above observations imply that when minimizing on the
simplex ∆n a function f with subgradients bounded in ‘∞-norm,
mirror descent with the negative entropy achieves a rate of convergence
. On the other hand the regular subgradient descent
of order

q log n
t
achieves only a rate of order

q n

t in this case!

“Spectrahedron setup". We consider here functions deﬁned on ma-
trices, and we are interested in minimizing a function f on the spectra-
hedron Sn deﬁned as:

Sn = (cid:8)X ∈ Sn

+ : Tr(X) = 1(cid:9) .

In this setting we consider the mirror map on D = Sn
negative von Neumann entropy:

++ given by the

Φ(X) =

n
X

i=1

λi(X) log λi(X),

where λ1(X), . . . , λn(X) are the eigenvalues of X. It can be shown that
the gradient update ∇Φ(Yt+1) = ∇Φ(Xt) − η∇f (Xt) can be written
equivalently as

Yt+1 = exp (cid:0) log Xt − η∇f (Xt)(cid:1),

where the matrix exponential and matrix logarithm are deﬁned as
usual. Furthermore the projection on Sn is a simple trace renormal-
ization.

With highly non-trivial computation one can show that Φ is 1
2 -

strongly convex with respect to the Schatten 1-norm deﬁned as

kXk1 =

n
X

i=1

λi(X).

## 4.4 Lazy mirror descent, aka Nesterov’s dual averaging


It is easy to see that for X = Sn one has x1 = 1
n In and R2 = log n. In
other words the rate of convergence for optimization on the spectrahe-
dron is the same than on the simplex!

## 4.4 Lazy mirror descent, aka Nesterov’s dual averaging

In this section we consider a slightly more eﬃcient version of mirror
descent for which we can prove that Theorem 4.2 still holds true. This
alternative algorithm can be advantageous in some situations (such
as distributed settings), but the basic mirror descent scheme remains
important for extensions considered later in this text (saddle points,
stochastic oracles, ...).

In lazy mirror descent, also commonly known as Nesterov’s dual

averaging or simply dual averaging, one replaces (4.2) by

∇Φ(yt+1) = ∇Φ(yt) − ηgt,

and also y1 is such that ∇Φ(y1) = 0. In other words instead of go-
ing back and forth between the primal and the dual, dual averaging
simply averages the gradients in the dual, and if asked for a point in
the primal it simply maps the current dual point to the primal using
the same methodology as mirror descent. In particular using (4.4) one
immediately sees that dual averaging is deﬁned by:

xt = argmin
x∈X ∩D

η

t−1
X

s=1

g>
s x + Φ(x).

(4.6)

Theorem 4.3. Let Φ be a mirror map ρ-strongly convex on X ∩ D
w.r.t. k · k. Let R2 = supx∈X ∩D Φ(x) − Φ(x1), and f be convex and
L-Lipschitz w.r.t. k · k. Then dual averaging with η = R
2t satisﬁes
L

q ρ

f

(cid:18) 1
t

t
X

s=1

(cid:19)

xs

s

− f (x∗) ≤ 2RL

2
ρt

.

Proof. We deﬁne ψt(x) = η Pt
so that xt ∈
argminx∈X ∩D ψt−1(x). Since Φ is ρ-strongly convex one clearly has that

s x + Φ(x),

s=1 g>

304 Almost dimension-free convex optimization in non-Euclidean spaces

ψt is ρ-strongly convex, and thus

ψt(xt+1) − ψt(xt) ≤ ∇ψt(xt+1)>(xt+1 − xt) −

≤ −

ρ
2

kxt+1 − xtk2,

ρ
2

kxt+1 − xtk2

where the second inequality comes from the ﬁrst order optimality con-
dition for xt+1 (see Proposition 1.3). Next observe that

ψt(xt+1) − ψt(xt) = ψt−1(xt+1) − ψt−1(xt) + ηg>

t (xt+1 − xt)

≥ ηg>

t (xt+1 − xt).

Putting together the two above displays and using Cauchy-Schwarz
(with the assumption kgtk∗ ≤ L) one obtains

ρ
2

kxt+1 − xtk2 ≤ ηg>

t (xt − xt+1) ≤ ηLkxt − xt+1k.

In particular this shows that kxt+1 −xtk ≤ 2ηL
display

ρ and thus with the above

g>
t (xt − xt+1) ≤

Now we claim that for any x ∈ X ∩ D,

2ηL2
ρ

.

t
X

s=1

g>
s (xs − x) ≤

t
X

s=1

g>
s (xs − xs+1) +

Φ(x) − Φ(x1)
η

,

which would clearly conclude the proof thanks to (4.7) and straightfor-
ward computations. Equation (4.8) is equivalent to

t
X

s=1

g>
s xs+1 +

Φ(x1)
η

≤

t
X

s=1

g>
s x +

Φ(x)
η

,

and we now prove the latter equation by induction. At t = 0 it is
true since x1 ∈ argminx∈X ∩D Φ(x). The following inequalities prove the
inductive step, where we use the induction hypothesis at x = xt+1 for
the ﬁrst inequality, and the deﬁnition of xt+1 for the second inequality:

t
X

s=1

g>
s xs+1 +

Φ(x1)
η

≤ g>

t xt+1 +

t−1
X

s=1

g>
s xt+1 +

Φ(xt+1)
η

≤

t
X

s=1

g>
s x+

Φ(x)
η

.

(4.7)

(4.8)

## 4.5 Mirror prox


## 4.5 Mirror prox

It can be shown that mirror descent accelerates for smooth functions to
the rate 1/t. We will prove this result in Chapter 6 (see Theorem 6.3).
We describe here a variant of mirror descent which also attains the rate
1/t for smooth functions. This method is called mirror prox and it was
introduced in Nemirovski [2004a]. The true power of mirror prox will
reveal itself later in the text when we deal with smooth representations
of non-smooth functions as well as stochastic oracles2.
Mirror prox is described by the following equations:

∇Φ(y0

t+1) = ∇Φ(xt) − η∇f (xt),

yt+1 ∈ argmin
x∈X ∩D

DΦ(x, y0

t+1),

∇Φ(x0

t+1) = ∇Φ(xt) − η∇f (yt+1),

xt+1 ∈ argmin
x∈X ∩D

DΦ(x, x0

t+1).

In words the algorithm ﬁrst makes a step of mirror descent to go from
xt to yt+1, and then it makes a similar step to obtain xt+1, starting
again from xt but this time using the gradient of f evaluated at yt+1
(instead of xt), see Figure 4.2 for an illustration. The following result
justiﬁes the procedure.

Theorem 4.4. Let Φ be a mirror map ρ-strongly convex on X ∩D w.r.t.
k · k. Let R2 = supx∈X ∩D Φ(x) − Φ(x1), and f be convex and β-smooth
w.r.t. k · k. Then mirror prox with η = ρ

β satisﬁes

f

(cid:18) 1
t

t
X

s=1

(cid:19)

ys+1

− f (x∗) ≤

βR2
ρt

.

2Basically mirror prox allows for a smooth vector ﬁeld point of view (see Section

4.6), while mirror descent does not.

306 Almost dimension-free convex optimization in non-Euclidean spaces

∇Φ

−η∇f (xt)

∇Φ(xt)

−η∇f (yt+1)

∇Φ(x0

t+1)

∇Φ(y0

t+1)

Rn

(∇Φ)−1

xt
xt+1
yt+1

X

x0
t+1

projection

y0
t+1

D

Figure 4.2: Illustration of mirror prox.

Proof. Let x ∈ X ∩ D. We write

f (yt+1) − f (x) ≤ ∇f (yt+1)>(yt+1 − x)

= ∇f (yt+1)>(xt+1 − x) + ∇f (xt)>(yt+1 − xt+1)

+(∇f (yt+1) − ∇f (xt))>(yt+1 − xt+1).

We will now bound separately these three terms. For the ﬁrst one, using
the deﬁnition of the method, Lemma 4.1, and equation (4.1), one gets

η∇f (yt+1)>(xt+1 − x)
= (∇Φ(xt) − ∇Φ(x0
t+1))>(xt+1 − x)
≤ (∇Φ(xt) − ∇Φ(xt+1))>(xt+1 − x)
= DΦ(x, xt) − DΦ(x, xt+1) − DΦ(xt+1, xt).

For the second term using the same properties than above and the

## 4.6 The vector ﬁeld point of view on MD, DA, and MP


strong-convexity of the mirror map one obtains

η∇f (xt)>(yt+1 − xt+1)
t+1))>(yt+1 − xt+1)
= (∇Φ(xt) − ∇Φ(y0
≤ (∇Φ(xt) − ∇Φ(yt+1))>(yt+1 − xt+1)
= DΦ(xt+1, xt) − DΦ(xt+1, yt+1) − DΦ(yt+1, xt)

≤ DΦ(xt+1, xt) −

ρ
2

kxt+1 − yt+1k2 −

ρ
2

kyt+1 − xtk2.

(4.9)

Finally for the last term, using Cauchy-Schwarz, β-smoothness, and
2ab ≤ a2 + b2 one gets

(∇f (yt+1) − ∇f (xt))>(yt+1 − xt+1)
≤ k∇f (yt+1) − ∇f (xt)k∗ · kyt+1 − xt+1k
≤ βkyt+1 − xtk · kyt+1 − xt+1k

≤

β
2

kyt+1 − xtk2 +

β
2

kyt+1 − xt+1k2.

Thus summing up these three terms and using that η = ρ

β one gets

f (yt+1) − f (x) ≤

DΦ(x, xt) − DΦ(x, xt+1)
η

.

The proof is concluded with straightforward computations.

## 4.6 The vector ﬁeld point of view on MD, DA, and MP

In this section we consider a mirror map Φ that satisﬁes the assump-
tions from Theorem 4.2.

By inspecting the proof of Theorem 4.2 one can see that for arbi-
trary vectors g1, . . . , gt ∈ Rn the mirror descent strategy described by
(4.2) or (4.3) (or alternatively by (4.5)) satisﬁes for any x ∈ X ∩ D,

t
X

s=1

g>
s (xs − x) ≤

R2
η

+

η
2ρ

t
X

s=1

kgsk2
∗.

(4.10)

The observation that the sequence of vectors (gs) does not have to come
from the subgradients of a ﬁxed function f is the starting point for the
theory of online learning, see Bubeck [2011] for more details. In this

308 Almost dimension-free convex optimization in non-Euclidean spaces

monograph we will use this observation to generalize mirror descent to
saddle point calculations as well as stochastic settings. We note that
we could also use dual averaging (deﬁned by (4.6)) which satisﬁes

t
X

s=1

g>
s (xs − x) ≤

R2
η

+

2η
ρ

t
X

s=1

kgsk2
∗.

In order to generalize mirror prox we simply replace the gradient ∇f
by an arbitrary vector ﬁeld g : X → Rn which yields the following
equations:

∇Φ(y0
yt+1 ∈ argmin
x∈X ∩D

t+1) = ∇Φ(xt) − ηg(xt),
DΦ(x, y0

t+1),

∇Φ(x0
xt+1 ∈ argmin
x∈X ∩D

t+1) = ∇Φ(xt) − ηg(yt+1),
DΦ(x, x0

t+1).

Under the assumption that the vector ﬁeld is β-Lipschitz w.r.t. k · k,
i.e., kg(x) − g(y)k∗ ≤ βkx − yk one obtains with η = ρ
β

t
X

s=1

g(ys+1)>(ys+1 − x) ≤

βR2
ρ

.

(4.11)

5

Beyond the black-box model

√

In the black-box model non-smoothness dramatically deteriorates the
rate of convergence of ﬁrst order methods from 1/t2 to 1/
t. However,
as we already pointed out in Section 1.5, we (almost) always know the
function to be optimized globally. In particular the “source" of non-
smoothness can often be identiﬁed. For instance the LASSO objective
(see Section 1.1) is non-smooth, but it is a sum of a smooth part (the
least squares ﬁt) and a simple non-smooth part (the ‘1-norm). Using
this speciﬁc structure we will propose in Section 5.1 a ﬁrst order method
with a 1/t2 convergence rate, despite the non-smoothness. In Section
## 5.2 we consider another type of non-smoothness that can eﬀectively
be overcome, where the function is the maximum of smooth functions.
Finally we conclude this chapter with a concise description of interior
point methods, for which the structural assumption is made on the
constraint set rather than on the objective function.

309

310

Beyond the black-box model

## 5.1 Sum of a smooth and a simple non-smooth term

We consider here the following problem1:

min
x∈Rn

f (x) + g(x),

where f is convex and β-smooth, and g is convex. We assume that f
can be accessed through a ﬁrst order oracle, and that g is known and
“simple". What we mean by simplicity will be clear from the description
of the algorithm. For instance a separable function, that is g(x) =
Pn
i=1 gi(x(i)), will be considered as simple. The prime example being
g(x) = kxk1. This section is inspired from Beck and Teboulle [2009]
(see also Nesterov [2007], Wright et al. [2009]).

ISTA (Iterative Shrinkage-Thresholding Algorithm)

Recall that gradient descent on the smooth function f can be written
as (see (4.5))

xt+1 = argmin

x∈Rn

η∇f (xt)>x +

1
2

kx − xtk2
2.

Here one wants to minimize f + g, and g is assumed to be known and
“simple". Thus it seems quite natural to consider the following update
rule, where only f is locally approximated with a ﬁrst order oracle:

xt+1 = argmin

x∈Rn

η(g(x) + ∇f (xt)>x) +

1
2

kx − xtk2
2

= argmin

x∈Rn

g(x) +

1
2η

kx − (xt − η∇f (xt))k2
2.

(5.1)

The algorithm described by the above iteration is known as ISTA (Iter-
ative Shrinkage-Thresholding Algorithm). In terms of convergence rate
it is easy to show that ISTA has the same convergence rate on f + g
as gradient descent on f . More precisely with η = 1

β one has

f (xt) + g(xt) − (f (x∗) + g(x∗)) ≤

βkx1 − x∗k2
2
2t

.

1We restrict to unconstrained minimization for sake of simplicity. One can extend

the discussion to constrained minimization by using ideas from Section 3.2.

## 5.1 Sum of a smooth and a simple non-smooth term


This improved convergence rate over a subgradient descent directly on
f + g comes at a price: in general (5.1) may be a diﬃcult optimization
problem by itself, and this is why one needs to assume that g is simple.
For instance if g can be written as g(x) = Pn
i=1 gi(x(i)) then one can
compute xt+1 by solving n convex problems in dimension 1. In the case
where g(x) = λkxk1 this one-dimensional problem is given by:

min
x∈R

λ|x| +

1
2η

(x − x0)2, where x0 ∈ R.

Elementary computations shows that this problem has an analytical
solution given by τλη(x0), where τ is the shrinkage operator (hence the
name ISTA), deﬁned by

τα(x) = (|x| − α)+sign(x).

Much more is known about (5.1) (which is called the proximal opera-
tor of g), and in fact entire monographs have been written about this
equation, see e.g. Parikh and Boyd [2013], Bach et al. [2012].

FISTA (Fast ISTA)

An obvious idea is to combine Nesterov’s accelerated gradient descent
(which results in a 1/t2 rate to optimize f ) with ISTA. This results in
FISTA (Fast ISTA) which is described as follows. Let

λ0 = 0, λt =

1 +

q

1 + 4λ2

t−1

2

, and γt =

1 − λt
λt+1

.

Let x1 = y1 an arbitrary initial point, and

yt+1 = argminx∈Rn g(x) +

xt+1 = (1 − γt)yt+1 + γtyt.

β
2

kx − (xt −

1
β

∇f (xt))k2
2,

Again it is easy show that the rate of convergence of FISTA on f + g
is similar to the one of Nesterov’s accelerated gradient descent on f ,
more precisely:

f (yt) + g(yt) − (f (x∗) + g(x∗)) ≤

2βkx1 − x∗k2
t2

.

312

Beyond the black-box model

CMD and RDA

ISTA and FISTA assume smoothness in the Euclidean metric. Quite
naturally one can also use these ideas in a non-Euclidean setting. Start-
ing from (4.5) one obtains the CMD (Composite Mirror Descent) al-
gorithm of Duchi et al. [2010], while with (4.6) one obtains the RDA
(Regularized Dual Averaging) of Xiao [2010]. We refer to these papers
for more details.

## 5.2 Smooth saddle-point representation of a non-smooth

function

Quite often the non-smoothness of a function f comes from a max op-
eration. More precisely non-smooth functions can often be represented
as

√

(5.2)

fi(x),

f (x) = max
1≤i≤m
where the functions fi are smooth. This was the case for instance with
t for non-
the function we used to prove the black-box lower bound 1/
smooth optimization in Theorem 3.13. We will see now that by using
this structural representation one can in fact attain a rate of 1/t. This
was ﬁrst observed in Nesterov [2004b] who proposed the Nesterov’s
smoothing technique. Here we will present the alternative method of
Nemirovski [2004a] which we ﬁnd more transparent (yet another ver-
sion is the Chambolle-Pock algorithm, see Chambolle and Pock [2011]).
Most of what is described in this section can be found in Juditsky and
Nemirovski [2011a,b].

In the next subsection we introduce the more general problem of
saddle point computation. We then proceed to apply a modiﬁed version
of mirror descent to this problem, which will be useful both in Chapter
6 and also as a warm-up for the more powerful modiﬁed mirror prox
that we introduce next.

5.2.1 Saddle point computation

Let X ⊂ Rn, Y ⊂ Rm be compact and convex sets. Let ϕ : X × Y →
R be a continuous function, such that ϕ(·, y) is convex and ϕ(x, ·) is

5.2. Smooth saddle-point representation of a non-smooth function 313

concave. We write gX (x, y) (respectively gY (x, y)) for an element of
∂xϕ(x, y) (respectively ∂y(−ϕ(x, y))). We are interested in computing

min
x∈X

max
y∈Y

ϕ(x, y).

By Sion’s minimax theorem there exists a pair (x∗, y∗) ∈ X × Y such
that

ϕ(x∗, y∗) = min
x∈X

max
y∈Y

ϕ(x, y) = max
y∈Y

min
x∈X

ϕ(x, y).

We will explore algorithms that produce a candidate pair of solutions
(ex, ey) ∈ X × Y. The quality of (ex, ey) is evaluated through the so-called
duality gap2

max
y∈Y

ϕ(ex, y) − min
x∈X

ϕ(x, ey).

The key observation is that the duality gap can be controlled similarly
to the suboptimality gap f (x) − f (x∗) in a simple convex optimization
problem. Indeed for any (x, y) ∈ X × Y,

ϕ(ex, ey) − ϕ(x, ey) ≤ gX (ex, ey)>(ex − x),

and

−ϕ(ex, ey) − (−ϕ(ex, y)) ≤ gY (ex, ey)>(ey − y).
In particular, using the notation z = (x, y) ∈ Z := X × Y and g(z) =
(gX (x, y), gY (x, y)) we just proved

max
y∈Y

ϕ(ex, y) − min
x∈X

ϕ(x, ey) ≤ g(ez)>(ez − z),

(5.3)

for some z ∈ Z. In view of the vector ﬁeld point of view developed in
Section 4.6 this suggests to do a mirror descent in the Z-space with
the vector ﬁeld g : Z → Rn × Rm.

We will assume in the next subsections that X is equipped with
a mirror map ΦX (deﬁned on DX ) which is 1-strongly convex w.r.t. a
norm k · kX on X ∩ DX . We denote R2
X = supx∈X Φ(x) − minx∈X Φ(x).
We deﬁne similar quantities for the space Y.

2Observe that the duality gap is the sum of the primal gap maxy∈Y ϕ(ex, y) −

ϕ(x∗, y∗) and the dual gap ϕ(x∗, y∗) − minx∈X ϕ(x, ey).

314

Beyond the black-box model

5.2.2 Saddle Point Mirror Descent (SP-MD)

We consider here mirror descent on the space Z = X × Y with the
mirror map Φ(z) = aΦX (x) + bΦY (y) (deﬁned on D = DX × DY ),
where a, b ∈ R+ are to be deﬁned later, and with the vector ﬁeld
g : Z → Rn × Rm deﬁned in the previous subsection. We call the
resulting algorithm SP-MD (Saddle Point Mirror Descent). It can be
described succintly as follows.

Let z1 ∈ argminz∈Z∩D Φ(z). Then for t ≥ 1, let

zt+1 ∈ argmin
z∈Z∩D

ηg>

t z + DΦ(z, zt),

where gt = (gX ,t, gY,t) with gX ,t ∈ ∂xϕ(xt, yt) and gY,t ∈ ∂y(−ϕ(xt, yt)).

Theorem 5.1. Assume that ϕ(·, y) is LX -Lipschitz w.r.t. k · kX , that
is kgX (x, y)k∗
X ≤ LX , ∀(x, y) ∈ X × Y. Similarly assume that ϕ(x, ·)
is LY -Lipschitz w.r.t. k · kY . Then SP-MD with a = LX
, and
RX

, b = LY
RY

q 2

η =

t satisﬁes

max
y∈Y

ϕ

1
t

t
X

s=1

!

xs, y

− min
x∈X

ϕ

x,

1
t

t
X

s=1

!

ys

≤ (RX LX + RY LY )

r 2
t

.

Proof. First we endow Z with the norm k · kZ deﬁned by

q

kzkZ =

akxk2

X + bkyk2
Y .

It is immediate that Φ is 1-strongly convex with respect to k · kZ on
Z ∩ D. Furthermore one can easily check that

kzk∗

Z =

r 1
a

(kxk∗

X )2 +

(cid:16)

1
b

kyk∗
Y

(cid:17)2

,

and thus the vector ﬁeld (gt) used in the SP-MD satisﬁes:

kgtk∗

Z ≤

s

L2
X
a

+

L2
Y
b

.

Using (4.10) together with (5.3) and the values of a, b and η concludes
the proof.



5.2. Smooth saddle-point representation of a non-smooth function 315

5.2.3 Saddle Point Mirror Prox (SP-MP)

We now consider the most interesting situation in the context of this
chapter, where the function ϕ is smooth. Precisely we say that ϕ is
(β11, β12, β22, β21)-smooth if for any x, x0 ∈ X , y, y0 ∈ Y,
X ≤ β11kx − x0kX ,
k∇xϕ(x, y) − ∇xϕ(x0, y)k∗
X ≤ β12ky − y0kY ,
k∇xϕ(x, y) − ∇xϕ(x, y0)k∗
Y ≤ β22ky − y0kY ,
k∇yϕ(x, y) − ∇yϕ(x, y0)k∗
Y ≤ β21kx − x0kX ,
k∇yϕ(x, y) − ∇yϕ(x0, y)k∗

This will imply the Lipschitzness of the vector ﬁeld g : Z → Rn × Rm
under the appropriate norm. Thus we use here mirror prox on the space
Z with the mirror map Φ(z) = aΦX (x) + bΦY (y) and the vector ﬁeld
g. The resulting algorithm is called SP-MP (Saddle Point Mirror Prox)
and we can describe it succintly as follows.

Let z1 ∈ argminz∈Z∩D Φ(z). Then for t ≥ 1, let zt = (xt, yt) and

wt = (ut, vt) be deﬁned by

wt+1 = argmin
z∈Z∩D
zt+1 = argmin
z∈Z∩D

η(∇xϕ(xt, yt), −∇yϕ(xt, yt))>z + DΦ(z, zt)

η(∇xϕ(ut+1, vt+1), −∇yϕ(ut+1, vt+1))>z + DΦ(z, zt).

Theorem 5.2. Assume
Then SP-MP with a
1/ (cid:0)2 max (cid:0)β11R2

that ϕ is

=

1
R2
X

,

b

(β11, β12, β22, β21)-smooth.
=

and η

X , β22R2
Y , β12RX RY , β21RX RY
t
X

!

us+1, y

− min
x∈X

ϕ

x,

1
t

max
y∈Y

ϕ

s=1
(cid:16)
β11R2

≤ max

X , β22R2

Y , β12RX RY , β21RX RY

,

1
=
R2
Y
(cid:1)(cid:1) satisﬁes
!

1
t

t
X

s=1

vs+1

(cid:17) 4
t

.

Proof. In light of the proof of Theorem 5.1 and (4.11) it clearly suf-
ﬁces to show that the vector ﬁeld g(z) = (∇xϕ(x, y), −∇yϕ(x, y))
r
X + 1
Y with β =
is β-Lipschitz w.r.t. kzkZ =
R2
Y
2 max (cid:0)β11R2
(cid:1). In other words one needs
X , β22R2
to show that

Y , β12RX RY , β21RX RY

kxk2

kyk2

1
R2
X

kg(z) − g(z0)k∗

Z ≤ βkz − z0kZ ,



316

Beyond the black-box model

which can be done with straightforward calculations (by introducing
g(x0, y) and using the deﬁnition of smoothness for ϕ).

5.2.4 Applications

We investigate brieﬂy three applications for SP-MD and SP-MP.

Minimizing a maximum of smooth functions

The problem (5.2) (when f has to minimized over X ) can be rewritten
as

min
x∈X

max
y∈∆m

~f (x)>y,

where ~f (x) = (f1(x), . . . , fm(x)) ∈ Rm. We assume that the functions
fi are L-Lipschtiz and β-smooth w.r.t. some norm k · kX . Let us study
the smoothness of ϕ(x, y) = ~f (x)>y when X is equipped with k · kX
and ∆m is equipped with k · k1. On the one hand ∇yϕ(x, y) = ~f (x), in
particular one immediately has β22 = 0, and furthermore

k ~f (x) − ~f (x0)k∞ ≤ Lkx − x0kX ,

that is β21 = L. On the other hand ∇xϕ(x, y) = Pm
thus

i=1 yi∇fi(x), and

k

k

m
X

i=1
m
X

i=1

y(i)(∇fi(x) − ∇fi(x0))k∗

X ≤ βkx − x0kX ,

(y(i) − y0(i))∇fi(x)k∗

X ≤ Lky − y0k1,

that is β11 = β and β12 = L. Thus using SP-MP with some mirror
map on X and the negentropy on ∆m (see the “simplex setup" in Sec-
tion 4.3), one obtains an ε-optimal point of f (x) = max1≤i≤m fi(x) in

iterations. Furthermore an iteration of SP-MP

(cid:18) βR2

O

X +LRX
ε

√

(cid:19)

log(m)

has a computational complexity of order of a step of mirror descent in
X on the function x 7→ Pm
i=1 y(i)fi(x) (plus O(m) for the update in
the Y-space).

Thus by using the structure of f we were able to obtain a much bet-
ter rate than black-box procedures (which would have required Ω(1/ε2)
iterations as f is potentially non-smooth).

5.2. Smooth saddle-point representation of a non-smooth function 317

Matrix games

Let A ∈ Rn×m, we denote kAkmax for the maximal entry (in abso-
lute value) of A, and Ai ∈ Rn for the ith column of A. We consider
the problem of computing a Nash equilibrium for the zero-sum game
corresponding to the loss matrix A, that is we want to solve

min
x∈∆n

max
y∈∆m

x>Ay.

Here we equip both ∆n and ∆m with k · k1. Let ϕ(x, y) = x>Ay. Using
that ∇xϕ(x, y) = Ay and ∇yϕ(x, y) = A>x one immediately obtains
β11 = β22 = 0. Furthermore since

kA(y − y0)k∞ = k

m
X

i=1

(y(i) − y0(i))Aik∞ ≤ kAkmaxky − y0k1,

(cid:16)

one also has β12 = β21 = kAkmax. Thus SP-MP with the ne-
gentropy on both ∆n and ∆m attains an ε-optimal pair of mixed
plog(n) log(m)/ε
iterations. Furthermore
strategies with O
the computational complexity of a step of SP-MP is dominated by
the matrix-vector multiplications which are O(nm). Thus overall the
complexity of getting an ε-optimal Nash equilibrium with SP-MP is
O

(cid:17)
kAkmaxnmplog(n) log(m)/ε

kAkmax

(cid:17)

(cid:16)

.

Linear classiﬁcation

Let (‘i, Ai) ∈ {−1, 1} × Rn, i ∈ [m], be a data set that one wishes to
separate with a linear classiﬁer. That is one is looking for x ∈ B2,n such
that for all i ∈ [m], sign(x>Ai) = sign(‘i), or equivalently ‘ix>Ai > 0.
Clearly without loss of generality one can assume ‘i = 1 for all i ∈ [m]
(simply replace Ai by ‘iAi). Let A ∈ Rn×m be the matrix where the
ith column is Ai. The problem of ﬁnding x with maximal margin can
be written as

max
x∈B2,n

min
1≤i≤m

A>

i x = max
x∈B2,n

min
y∈∆m

x>Ay.

(5.4)

Assuming that kAik2 ≤ B, and using the calculations we did in Section
5.2.4, it is clear that ϕ(x, y) = x>Ay is (0, B, 0, B)-smooth with respect

318

Beyond the black-box model

to k · k2 on B2,n and k · k1 on ∆m. This implies in particular that SP-
MP with the Euclidean norm squared on B2,n and the negentropy on
∆m will solve (5.4) in O(Bplog(m)/ε) iterations. Again the cost of
an iteration is dominated by the matrix-vector multiplications, which
results in an overall complexity of O(Bnmplog(m)/ε) to ﬁnd an ε-
optimal solution to (5.4).

5.3

Interior point methods

We describe here interior point methods (IPM), a class of algorithms
fundamentally diﬀerent from what we have seen so far. The ﬁrst
algorithm of this type was described in Karmarkar [1984], but the
theory we shall present was developed in Nesterov and Nemirovski
[1994]. We follow closely the presentation given in [Chapter 4, Nesterov
[2004a]]. Other useful references (in particular for the primal-dual
IPM, which are the ones used in practice) include Renegar [2001],
Nemirovski [2004b], Nocedal and Wright [2006].

IPM are designed to solve convex optimization problems of the form

min. c>x
s.t. x ∈ X ,

with c ∈ Rn, and X ⊂ Rn convex and compact. Note that, at this
point, the linearity of the objective is without loss of generality as
minimizing a convex function f over X is equivalent to minimizing a
linear objective over the epigraph of f (which is also a convex set). The
structural assumption on X that one makes in IPM is that there exists
a self-concordant barrier for X with an easily computable gradient and
Hessian. The meaning of the previous sentence will be made precise in
the next subsections. The importance of IPM stems from the fact that
LPs and SDPs (see Section 1.5) satisfy this structural assumption.

5.3.1 The barrier method

We say that F : int(X ) → R is a barrier for X if

F (x) −−−−→
x→∂X

+∞.

5.3.

Interior point methods

319

We will only consider strictly convex barriers. We extend the domain
of deﬁnition of F to Rn with F (x) = +∞ for x 6∈ int(X ). For t ∈ R+
let

x∗(t) ∈ argmin
x∈Rn

tc>x + F (x).

In the following we denote Ft(x) := tc>x + F (x). In IPM the path
(x∗(t))t∈R+ is referred to as the central path. It seems clear that the
central path eventually leads to the minimum x∗ of the objective func-
tion c>x on X , precisely we will have

x∗(t) −−−−→
t→+∞

x∗.

The idea of the barrier method is to move along the central path by
“boosting" a fast locally convergent algorithm, which we denote for
the moment by A, using the following scheme: Assume that one has
computed x∗(t), then one uses A initialized at x∗(t) to compute x∗(t0)
for some t0 > t. There is a clear tension for the choice of t0, on the one
hand t0 should be large in order to make as much progress as possible on
the central path, but on the other hand x∗(t) needs to be close enough
to x∗(t0) so that it is in the basin of fast convergence for A when run
on Ft0.

IPM follows the above methodology with A being Newton’s method.
Indeed as we will see in the next subsection, Newton’s method has a
quadratic convergence rate, in the sense that if initialized close enough
to the optimum it attains an ε-optimal point in log log(1/ε) iterations!
Thus we now have a clear plan to make these ideas formal and analyze
the iteration complexity of IPM:

1. First we need to describe precisely the region of fast convergence
for Newton’s method. This will lead us to deﬁne self-concordant
functions, which are “natural" functions for Newton’s method.

2. Then we need to evaluate precisely how much larger t0 can be
compared to t, so that x∗(t) is still in the region of fast conver-
gence of Newton’s method when optimizing the function Ft0 with
t0 > t. This will lead us to deﬁne ν-self concordant barriers.

320

Beyond the black-box model

3. How do we get close to the central path in the ﬁrst place? Is
it possible to compute x∗(0) = argminx∈Rn F (x) (the so-called
analytical center of X )?

5.3.2 Traditional analysis of Newton’s method

We start by describing Newton’s method together with its standard
analysis showing the quadratic convergence rate when initialized close
enough to the optimum. In this subsection we denote k · k for both the
Euclidean norm on Rn and the operator norm on matrices (in particular
kAxk ≤ kAk · kxk).

Let f : Rn → R be a C2 function. Using a Taylor’s expansion of f

around x one obtains

f (x + h) = f (x) + h>∇f (x) +

h>∇2f (x)h + o(khk2).

1
2

Thus, starting at x, in order to minimize f it seems natural to move in
the direction h that minimizes

h>∇f (x) +

h>∇f 2(x)h.

1
# 2 If ∇2f (x) is positive deﬁnite then the solution to this problem is given
by h = −[∇2f (x)]−1∇f (x). Newton’s method simply iterates this idea:
starting at some point x0 ∈ Rn, it iterates for k ≥ 0 the following
equation:

xk+1 = xk − [∇2f (xk)]−1∇f (xk).
While this method can have an arbitrarily bad behavior in general, if
started close enough to a strict local minimum of f , it can have a very
fast convergence:

Theorem 5.3. Assume that f has a Lipschitz Hessian, that is
k∇2f (x) − ∇2f (y)k ≤ M kx − yk. Let x∗ be local minimum of f with
strictly positive Hessian, that is ∇2f (x∗) (cid:23) µIn, µ > 0. Suppose that
the initial starting point x0 of Newton’s method is such that

kx0 − x∗k ≤

µ
2M

.

Then Newton’s method is well-deﬁned and converges to x∗ at a
quadratic rate:

kxk+1 − x∗k ≤

kxk − x∗k2.

M
µ

5.3.

Interior point methods

321

Proof. We use the following simple formula, for x, h ∈ Rn,

Z 1

0

∇2f (x + sh) h ds = ∇f (x + h) − ∇f (x).

Now note that ∇f (x∗) = 0, and thus with the above formula one
obtains

∇f (xk) =

Z 1

0

∇2f (x∗ + s(xk − x∗)) (xk − x∗) ds,

which allows us to write:

xk+1 − x∗
= xk − x∗ − [∇2f (xk)]−1∇f (xk)

= xk − x∗ − [∇2f (xk)]−1

Z 1

0

∇2f (x∗ + s(xk − x∗)) (xk − x∗) ds

= [∇2f (xk)]−1

Z 1

0

[∇2f (xk) − ∇2f (x∗ + s(xk − x∗))] (xk − x∗) ds.

In particular one has

kxk+1 − x∗k
≤ k[∇2f (xk)]−1k

(cid:18)Z 1

×

0

k∇2f (xk) − ∇2f (x∗ + s(xk − x∗))k ds

(cid:19)

kxk − x∗k.

Using the Lipschitz property of the Hessian one immediately obtains
that

(cid:18)Z 1

0

k∇2f (xk) − ∇2f (x∗ + s(xk − x∗))k ds

(cid:19)

≤

M
2

kxk − x∗k.

Using again the Lipschitz property of the Hessian (note that kA−Bk ≤
s ⇔ sIn (cid:23) A − B (cid:23) −sIn), the hypothesis on x∗, and an induction
hypothesis that kxk − x∗k ≤ µ
2M , one has

∇2f (xk) (cid:23) ∇2f (x∗) − M kxk − x∗kIn (cid:23) (µ − M kxk − x∗k)In (cid:23)

µ
2

In,

which concludes the proof.

322

Beyond the black-box model

5.3.3 Self-concordant functions

Before giving the deﬁnition of self-concordant functions let us try to
get some insight into the “geometry" of Newton’s method. Let A be a
n × n non-singular matrix. We look at a Newton step on the functions
f : x 7→ f (x) and ϕ : y 7→ f (A−1y), starting respectively from x and
y = Ax, that is:

x+ = x − [∇2f (x)]−1∇f (x), and y+ = y − [∇2ϕ(y)]−1∇ϕ(y).

By using the following simple formulas

∇(x 7→ f (Ax)) = A>∇f (Ax), and ∇2(x 7→ f (Ax)) = A>∇2f (Ax)A.

it is easy to show that

y+ = Ax+.

In other words Newton’s method will follow the same trajectory in the
“x-space" and in the “y-space" (the image through A of the x-space),
that is Newton’s method is aﬃne invariant. Observe that this property
is not shared by the methods described in Chapter 3 (except for the
conditional gradient descent).

The aﬃne invariance of Newton’s method casts some concerns on
the assumptions of the analysis in Section 5.3.2. Indeed the assumptions
are all in terms of the canonical inner product in Rn. However we just
showed that the method itself does not depend on the choice of the
inner product (again this is not true for ﬁrst order methods). Thus
one would like to derive a result similar to Theorem 5.3 without any
reference to a prespeciﬁed inner product. The idea of self-concordance
is to modify the Lipschitz assumption on the Hessian to achieve this
goal.

Assume from now on that f is C3, and let ∇3f (x) : Rn ×Rn ×Rn →
R be the third order diﬀerential operator. The Lipschitz assumption on
the Hessian in Theorem 5.3 can be written as:

∇3f (x)[h, h, h] ≤ M khk3
2.

The issue is that this inequality depends on the choice of an inner prod-
uct. More importantly it is easy to see that a convex function which

5.3.

Interior point methods

323

goes to inﬁnity on a compact set simply cannot satisfy the above in-
equality. A natural idea to try ﬁx these issues is to replace the Euclidean
metric on the right hand side by the metric given by the function f
itself at x, that is:

q

khkx =

h>∇2f (x)h.

Observe that to be clear one should rather use the notation k · kx,f , but
since f will always be clear from the context we stick to k · kx.

Deﬁnition 5.1. Let X be a convex set with non-empty interior, and
f a C3 convex function deﬁned on int(X ). Then f is self-concordant
(with constant M ) if for all x ∈ int(X ), h ∈ Rn,

∇3f (x)[h, h, h] ≤ M khk3
x.

We say that f is standard self-concordant if f is self-concordant with
constant M = 2.

An easy consequence of the deﬁnition is that a self-concordant func-
tion is a barrier for the set X , see [Theorem 4.1.4, Nesterov [2004a]].
The main example to keep in mind of a standard self-concordant func-
tion is f (x) = − log x for x > 0. The next deﬁnition will be key in order
to describe the region of quadratic convergence for Newton’s method
on self-concordant functions.

Deﬁnition 5.2. Let f be a standard self-concordant function on X . For
x ∈ int(X ), we say that λf (x) = k∇f (x)k∗
x is the Newton decrement of
f at x.

An important inequality is that for x such that λf (x) < 1, and

x∗ = argmin f (x), one has

kx − x∗kx ≤

λf (x)
1 − λf (x)

,

(5.5)

see [Equation 4.1.18, Nesterov [2004a]]. We state the next theorem
without a proof, see also [Theorem 4.1.14, Nesterov [2004a]].

Theorem 5.4. Let f be a standard self-concordant function on X , and
x ∈ int(X ) such that λf (x) ≤ 1/4, then
(cid:16)

(cid:17)
x − [∇2f (x)]−1∇f (x)

λf

≤ 2λf (x)2.

324

Beyond the black-box model

In other words the above theorem states that, if initialized at
a point x0 such that λf (x0) ≤ 1/4, then Newton’s iterates satisfy
λf (xk+1) ≤ 2λf (xk)2. Thus, Newton’s region of quadratic convergence
for self-concordant functions can be described as a “Newton decrement
ball" {x : λf (x) ≤ 1/4}. In particular by taking the barrier to be a
self-concordant function we have now resolved Step (1) of the plan
described in Section 5.3.1.

5.3.4 ν-self-concordant barriers

We deal here with Step (2) of the plan described in Section 5.3.1. Given
Theorem 5.4 we want t0 to be as large as possible and such that

λFt0 (x∗(t)) ≤ 1/4.

(5.6)

Since the Hessian of Ft0 is the Hessian of F , one has

λFt0 (x∗(t)) = kt0c + ∇F (x∗(t))k∗

x∗(t).

Observe that, by ﬁrst order optimality, one has tc + ∇F (x∗(t)) = 0,
which yields

Thus taking

λFt0 (x∗(t)) = (t0 − t)kck∗

x∗(t).

t0 = t +

1
4kck∗

x∗(t)

(5.7)

(5.8)

immediately yields (5.6). In particular with the value of t0 given in
initialized at x∗(t) will converge
(5.8) the Newton’s method on Ft0
quadratically fast to x∗(t0).

It remains to verify that by iterating (5.8) one obtains a sequence
diverging to inﬁnity, and to estimate the rate of growth. Thus one needs
to control kck∗
x∗(t). Luckily there is a natural class
of functions for which one can control k∇F (x)k∗
x uniformly over x. This
is the set of functions such that

t k∇F (x∗(t))k∗

x∗(t) = 1

∇2F (x) (cid:23)

1
ν

∇F (x)[∇F (x)]>.

(5.9)

5.3.

Interior point methods

325

Indeed in that case one has:

k∇F (x)k∗

x =

sup
h:h>∇F 2(x)h≤1

∇F (x)>h

≤

=

sup

∇F (x)>h

ν ∇F (x)[∇F (x)]>)h≤1

h:h>( 1
√

ν.

(cid:17)

Thus a safe choice to increase the penalization parameter is t0 =
(cid:16)
1 + 1
t. Note that the condition (5.9) can also be written as the
√
# 4 fact that the function F is 1
ν F (x)) is
concave. We arrive at the following deﬁnition.

ν -exp-concave, that is x 7→ exp(− 1

ν

Deﬁnition 5.3. F is a ν-self-concordant barrier if it is a standard self-
concordant function, and it is 1

ν -exp-concave.

Again the canonical example is the logarithmic function, x 7→
− log x, which is a 1-self-concordant barrier for the set R+. We state
the next theorem without a proof (see Bubeck and Eldan [2014] for
more on this result).

Theorem 5.5. Let X ⊂ Rn be a closed convex set with non-empty
interior. There exists F which is a (c n)-self-concordant barrier for X
(where c is some universal constant).

A key property of ν-self-concordant barriers is the following inequal-

ity:

c>x∗(t) − min
x∈X
see [Equation (4.2.17), Nesterov [2004a]]. More generally using (5.10)
together with (5.5) one obtains

c>x ≤

(5.10)

,

ν
t

+ c>(y − x∗(t))

c>y − min
x∈X

c>x ≤

=

≤

≤

ν
t
ν
t
ν
t
ν
t

+

+

+

1
t
1
t
1
t

(∇Ft(y) − ∇F (y))>(y − x∗(t))

y · ky − x∗(t)ky

k∇Ft(y) − ∇F (y)k∗
√

(λFt(y) +

ν)

λFt(y)
1 − λFt(y)

(5.11)

326

Beyond the black-box model

In the next section we describe a precise algorithm based on the ideas
we developed above. As we will see one cannot ensure to be exactly on
the central path, and thus it is useful to generalize the identity (5.7)
for a point x close to the central path. We do this as follows:

λFt0 (x) = kt0c + ∇F (x)k∗

x

= k(t0/t)(tc + ∇F (x)) + (1 − t0/t)∇F (x)k∗
x

(cid:19) √

− 1

ν.

(5.12)

≤

t0
t

λFt(x) +

5.3.5 Path-following scheme

(cid:18) t0
t

We can now formally describe and analyze the most basic IPM called
the path-following scheme. Let F be ν-self-concordant barrier for X .
Assume that one can ﬁnd x0 such that λFt0
(x0) ≤ 1/4 for some small
value t0 > 0 (we describe a method to ﬁnd x0 at the end of this sub-
section). Then for k ≥ 0, let

tk+1 =

(cid:18)

1 +

(cid:19)

1
√
13

ν

tk,

xk+1 = xk − [∇2F (xk)]−1(tk+1c + ∇F (xk)).

The next theorem shows that after O
path-following scheme one obtains an ε-optimal point.

ν log ν
t0ε

(cid:16)√

(cid:17)

iterations of the

Theorem 5.6. The path-following scheme described above satisﬁes

c>xk − min
x∈X

c>x ≤

2ν
t0

(cid:18)

−

exp

k
1 + 13

√

ν

(cid:19)

.

Proof. We show that the iterates (xk)k≥0 remain close to the central
path (x∗(tk))k≥0. Precisely one can easily prove by induction that

Indeed using Theorem 5.4 and equation (5.12) one immediately obtains

λFtk

(xk) ≤ 1/4.

λFtk+1

(xk)2

(xk+1) ≤ 2λFtk+1
(cid:18) tk+1
tk

≤ 2

≤ 1/4,

λFtk

(xk) +

(cid:18) tk+1
tk

(cid:19) √

− 1

(cid:19)2

ν

5.3.

Interior point methods

327

where we used in the last inequality that tk+1/tk = 1 + 1
√
13

ν and ν ≥ 1.

Thus using (5.11) one obtains

c>xk − min
x∈X

c>x ≤

√

ν +

ν/3 + 1/12

tk

≤

2ν
tk

.

Observe that tk =

(cid:16)

1 + 1
√
13

ν

(cid:17)k

t0, which ﬁnally yields

c>xk − min
x∈X

c>x ≤

2ν
t0

(cid:18)

1 +

(cid:19)−k

.

1
√
13

ν

At this point we still need to explain how one can get close to
an intial point x∗(t0) of the central path. This can be done with the
following rather clever trick. Assume that one has some point y0 ∈ X .
The observation is that y0 is on the central path at t = 1 for the problem
where c is replaced by −∇F (y0). Now instead of following this central
path as t → +∞, one follows it as t → 0. Indeed for t small enough the
central paths for c and for −∇F (y0) will be very close. Thus we iterate
the following equations, starting with t0

0 = 1,

(cid:19)

(cid:18)

1 −

t0
k+1 =

1
√
# 13 yk+1 = yk − [∇2F (yk)]−1(−t0

t0
k,

ν

k+1∇F (y0) + ∇F (yk)).

ν log ν), which corre-
A straightforward analysis shows that for k = O(
k = 1/νO(1), one obtains a point yk such that λFt0
sponds to t0
(yk) ≤ 1/4.
In other words one can initialize the path-following scheme with t0 = t0
k
and x0 = yk.

k

√

5.3.6

IPMs for LPs and SDPs

We have seen that, roughly, the complexity of interior point methods
(cid:1), where M is the com-
with a ν-self-concordant barrier is O (cid:0)M
plexity of computing a Newton direction (which can be done by com-
puting and inverting the Hessian of the barrier). Thus the eﬃciency of
the method is directly related to the form of the self-concordant bar-
rier that one can construct for X . It turns out that for LPs and SDPs

ν log ν
ε

√

328

Beyond the black-box model

i=1 log xi is an n-self-concordant barrier on Rn

one has particularly nice self-concordant barriers. Indeed one can show
that F (x) = − Pn
+, and
F (x) = − log det(X) is an n-self-concordant barrier on Sn
+. See also Lee
and Sidford [2013] for a recent improvement of the basic logarithmic
barrier for LPs.

There is one important issue that we overlooked so far. In most in-
teresting cases LPs and SDPs come with equality constraints, resulting
in a set of constraints X with empty interior. From a theoretical point
of view there is an easy ﬁx, which is to reparametrize the problem as
to enforce the variables to live in the subspace spanned by X . This
modiﬁcation also has algorithmic consequences, as the evaluation of
the Newton direction will now be diﬀerent. In fact, rather than doing
a reparametrization, one can simply search for Newton directions such
that the updated point will stay in X . In other words one has now to
solve a convex quadratic optimization problem under linear equality
constraints. Luckily using Lagrange multipliers one can ﬁnd a closed
form solution to this problem, and we refer to previous references for
more details.

6

Convex optimization and randomness

In this chapter we explore the interplay between optimization and ran-
domness. A key insight, going back to Robbins and Monro [1951], is
that ﬁrst order methods are quite robust: the gradients do not have
to be computed exactly to ensure progress towards the optimum. In-
deed since these methods usually do many small steps, as long as the
gradients are correct on average, the error introduced by the gradient
approximations will eventually vanish. As we will see below this intu-
ition is correct for non-smooth optimization (since the steps are indeed
small) but the picture is more subtle in the case of smooth optimization
(recall from Chapter 3 that in this case we take long steps).

We introduce now the main object of this chapter: a (ﬁrst order)
stochastic oracle for a convex function f : X → R takes as input a point
x ∈ X and outputs a random variable eg(x) such that E
eg(x) ∈ ∂f (x).
In the case where the query point x is a random variable (possi-
bly obtained from previous queries to the oracle), one assumes that
E (eg(x)|x) ∈ ∂f (x).

The unbiasedness assumption by itself is not enough to obtain rates
of convergence, one also needs to make assumptions about the ﬂuc-
tuations of eg(x). Essentially in the non-smooth case we will assume

329

330

Convex optimization and randomness

that there exists B > 0 such that Ekeg(x)k2
∗ ≤ B2 for all x ∈ X ,
while in the smooth case we assume that there exists σ > 0 such that
Ekeg(x) − ∇f (x)k2

∗ ≤ σ2 for all x ∈ X .

We also note that the situation with a biased oracle is quite diﬀerent,
and we refer to d’Aspremont [2008], Schmidt et al. [2011] for some works
in this direction.

The two canonical examples of a stochastic oracle in machine learn-

ing are as follows.

Let f (x) = Eξ‘(x, ξ) where ‘(x, ξ) should be interpreted as the loss
of predictor x on the example ξ. We assume that ‘(·, ξ) is a (diﬀeren-
tiable1) convex function for any ξ. The goal is to ﬁnd a predictor with
minimal expected loss, that is to minimize f . When queried at x the
stochastic oracle can draw ξ from the unknown distribution and report
∇x‘(x, ξ). One obviously has Eξ∇x‘(x, ξ) ∈ ∂f (x).

The second example is the one described in Section 1.1, where one
wants to minimize f (x) = 1
i=1 fi(x). In this situation a stochastic
m
oracle can be obtained by selecting uniformly at random I ∈ [m] and
reporting ∇fI (x).

Pm

Observe that the stochastic oracles in the two above cases are quite
diﬀerent. Consider the standard situation where one has access to a
data set of i.i.d. samples ξ1, . . . , ξm. Thus in the ﬁrst case, where one
wants to minimize the expected loss, one is limited to m queries to the
oracle, that is to a single pass over the data (indeed one cannot ensure
that the conditional expectations are correct if one uses twice a data
point). On the contrary for the empirical loss where fi(x) = ‘(x, ξi)
one can do as many passes as one wishes.

## 6.1 Non-smooth stochastic optimization

We initiate our study with stochastic mirror descent (S-MD) which is
deﬁned as follows: x1 ∈ argminX ∩D Φ(x), and

xt+1 = argmin
x∈X ∩D

ηeg(xt)>x + DΦ(x, xt).

1We assume diﬀerentiability only for sake of notation here.

## 6.1 Non-smooth stochastic optimization


In this case equation (4.10) rewrites

t
X

s=1

eg(xs)>(xs − x) ≤

R2
η

+

η
2ρ

t
X

s=1

keg(xs)k2
∗.

This immediately yields a rate of convergence thanks to the following
simple observation based on the tower rule:

Ef

(cid:18) 1
t

t
X

s=1

(cid:19)

xs

− f (x) ≤

≤

=

1
t

1
t

1
t

t
X

E

(f (xs) − f (x))

s=1
t
X

s=1
t
X

s=1

E

E

E(eg(xs)|xs)>(xs − x)

eg(xs)>(xs − x).

We just proved the following theorem.

Theorem 6.1. Let Φ be a mirror map 1-strongly convex on X ∩ D
with respect to k · k, and let R2 = supx∈X ∩D Φ(x) − Φ(x1). Let f be
convex. Furthermore assume that the stochastic oracle is such that
Ekeg(x)k2

∗ ≤ B2. Then S-MD with η = R
B

t satisﬁes

q 2

Ef

(cid:18) 1
t

t
X

s=1

(cid:19)

xs

− min
x∈X

f (x) ≤ RB

r 2
t

.

Similarly, in the Euclidean and strongly convex case, one can di-
rectly generalize Theorem 3.9. Precisely we consider stochastic gradient
descent (SGD), that is S-MD with Φ(x) = 1
2, with time-varying
step size (ηt)t≥1, that is

2 kxk2

xt+1 = ΠX (xt − ηteg(xt)).

Theorem 6.2. Let f be α-strongly convex, and assume that the
stochastic oracle is such that Ekeg(x)k2
∗ ≤ B2. Then SGD with ηs =
α(s+1) satisﬁes

2

  t

X

f

s=1

!

2s
t(t + 1)

xs

− f (x∗) ≤

2B2
α(t + 1)

.

332

Convex optimization and randomness

## 6.2 Smooth stochastic optimization and mini-batch SGD

In the previous section we showed that, for non-smooth optimization,
there is basically no cost for having a stochastic oracle instead of an
exact oracle. Unfortunately one can show (see e.g. Tsybakov [2003])
that smoothness does not bring any acceleration for a general stochastic
oracle2. This is in sharp contrast with the exact oracle case where we
t for non-
showed that gradient descent attains a 1/t rate (instead of 1/
smooth), and this could even be improved to 1/t2 thanks to Nesterov’s
accelerated gradient descent.

√

The next result interpolates between the 1/

t for stochastic smooth
optimization, and the 1/t for deterministic smooth optimization. We
will use it to propose a useful modiﬁcation of SGD in the smooth case.
The proof is extracted from Dekel et al. [2012].

√

Theorem 6.3. Let Φ be a mirror map 1-strongly convex on X ∩ D
w.r.t. k · k, and let R2 = supx∈X ∩D Φ(x) − Φ(x1). Let f be convex and
β-smooth w.r.t. k · k. Furthermore assume that the stochastic oracle is
such that Ek∇f (x) − eg(x)k2
β+1/η and
η = R
t satisﬁes
σ

∗ ≤ σ2. Then S-MD with stepsize

q 2

1

Ef

(cid:18) 1
t

t
X

s=1

(cid:19)

xs+1

− f (x∗) ≤ Rσ

r 2
t

+

βR2
t

.

Proof. Using β-smoothness, Cauchy-Schwarz (with 2ab ≤ xa2 + b2/x

2While being true in general this statement does not say anything about spe-
ciﬁc functions/oracles. For example it was shown in Bach and Moulines [2013] that
acceleration can be obtained for the square loss and the logistic loss.

## 6.2 Smooth stochastic optimization and mini-batch SGD


for any x > 0), and the 1-strong convexity of Φ, one obtains

f (xs+1) − f (xs)

≤ ∇f (xs)>(xs+1 − xs) +

β
# 2 s (xs+1 − xs) + (∇f (xs) − egs)>(xs+1 − xs) +

kxs+1 − xsk2

= eg>

≤ eg>
≤ eg>

s (xs+1 − xs) +

s (xs+1 − xs) +

k∇f (xs) − egsk2
k∇f (xs) − egsk2

∗ +

1
2

η
2
η
2

β
2

kxs+1 − xsk2

(β + 1/η)kxs+1 − xsk2

∗ + (β + 1/η)DΦ(xs+1, xs).

Observe that, using the same argument as to derive (4.9), one has

s (xs+1 − x∗) ≤ DΦ(x∗, xs) − DΦ(x∗, xs+1) − DΦ(xs+1, xs).

# 1 β + 1/η eg>
Thus

s (x∗ − xs) + (β + 1/η) (DΦ(x∗, xs) − DΦ(x∗, xs+1))

f (xs+1)
≤ f (xs) + eg>
η
+
2

k∇f (xs) − egsk2
≤ f (x∗) + (egs − ∇f (xs))>(x∗ − xs)

∗

+ (β + 1/η) (DΦ(x∗, xs) − DΦ(x∗, xs+1)) +

In particular this yields

η
2

k∇f (xs) − egsk2
∗.

Ef (xs+1) − f (x∗) ≤ (β + 1/η)E (DΦ(x∗, xs) − DΦ(x∗, xs+1)) +

ησ2
2

.

By summing this inequality from s = 1 to s = t one can easily conclude
with the standard argument.

We can now propose the following modiﬁcation of SGD based on
the idea of mini-batches. Let m ∈ N, then mini-batch SGD iterates the
following equation:

xt+1 = ΠX

xt −

!

egi(xt)

.

η
m

m
X

i=1


334

Convex optimization and randomness

where egi(xt), i = 1, . . . , m are independent random variables (condi-
tionally on xt) obtained from repeated queries to the stochastic oracle.
Assuming that f is β-smooth and that the stochastic oracle is such that
keg(x)k2 ≤ B, one can obtain a rate of convergence for mini-batch SGD
with Theorem 6.3. Indeed one can apply this result with the modiﬁed
Pm
stochastic oracle that returns 1
m

Ek

1
m

m
X

i=1

egi(x) − ∇f (x)k2

2 =

i=1 egi(x), it satisﬁes
1
m

Ekeg1(x) − ∇f (x)k2

2 ≤

2B2
m

.

Thus one obtains that with t calls to the (original) stochastic oracle,
that is t/m iterations of the mini-batch SGD, one has a suboptimality
gap bounded by

s

s

R

2B2
m

2
t/m
√

+

βR2
t/m

= 2

RB
√
t

+

mβR2
t

.

Thus as long as m ≤ B
Rβ
calls to the oracle, a point which is 3 RB√
t

-optimal.

t one obtains, with mini-batch SGD and t

Mini-batch SGD can be a better option than basic SGD in at least
two situations: (i) When the computation for an iteration of mini-
batch SGD can be distributed between multiple processors. Indeed a
central unit can send the message to the processors that estimates of
the gradient at point xs have to be computed, then each processor can
work independently and send back the estimate they obtained. (ii) Even
in a serial setting mini-batch SGD can sometimes be advantageous,
in particular if some calculations can be re-used to compute several
estimated gradients at the same point.

## 6.3 Sum of smooth and strongly convex functions

Let us examine in more details the main example from Section 1.1.
That is one is interested in the unconstrained minimization of

f (x) =

1
m

m
X

i=1

fi(x),

where f1, . . . , fm are β-smooth and convex functions, and f is α-
strongly convex. Typically in machine learning α can be as small as

## 6.3 Sum of smooth and strongly convex functions


1/m, while β is of order of a constant. In other words the condition
number κ = β/α can be as large as Ω(m). Let us now compare the
basic gradient descent, that is

to SGD

xt+1 = xt −

η
m

m
X

i=1

∇fi(x),

xt+1 = xt − η∇fit(x),

√

where it is drawn uniformly at random in [m] (independently of ev-
erything else). Theorem 3.10 shows that gradient descent requires
O(mκ log(1/ε)) gradient computations (which can be improved to
κ log(1/ε)) with Nesterov’s accelerated gradient descent), while
O(m
Theorem 6.2 shows that SGD (with appropriate averaging) requires
O(1/(αε)) gradient computations. Thus one can obtain a low accu-
racy solution reasonably fast with SGD, but for high accuracy the
basic gradient descent is more suitable. Can we get the best of both
worlds? This question was answered positively in Le Roux et al. [2012]
with SAG (Stochastic Averaged Gradient) and in Shalev-Shwartz and
Zhang [2013a] with SDCA (Stochastic Dual Coordinate Ascent). These
methods require only O((m + κ) log(1/ε)) gradient computations. We
describe below the SVRG (Stochastic Variance Reduced Gradient de-
scent) algorithm from Johnson and Zhang [2013] which makes the main
ideas of SAG and SDCA more transparent (see also Defazio et al.
[2014] for more on the relation between these diﬀerent methods). We
also observe that a natural question is whether one can obtain a Nes-
terov’s accelerated version of these algorithms that would need only
mκ) log(1/ε)), see Shalev-Shwartz and Zhang [2013b], Zhang
O((m +
and Xiao [2014], Agarwal and Bottou [2014] for recent works on this
question.

√

To obtain a linear rate of convergence one needs to make “big steps",
that is the step-size should be of order of a constant. In SGD the step-
t because of the variance introduced by
size is typically of order 1/
the stochastic oracle. The idea of SVRG is to “center" the output of
the stochastic oracle in order to reduce the variance. Precisely instead
of feeding ∇fi(x) into the gradient descent one would use ∇fi(x) −

√

336

Convex optimization and randomness

∇fi(y) + ∇f (y) where y is a centering sequence. This is a sensible idea
since, when x and y are close to the optimum, one should have that
∇fi(x) − ∇fi(y) will have a small variance, and of course ∇f (y) will
also be small (note that ∇fi(x) by itself is not necessarily small). This
intuition is made formal with the following lemma.

Lemma 6.4. Let f1, . . . fm be β-smooth convex functions on Rn, and i
be a random variable uniformly distributed in [m]. Then

Ek∇fi(x) − ∇fi(x∗)k2

2 ≤ 2β(f (x) − f (x∗)).

Proof. Let gi(x) = fi(x) − fi(x∗) − ∇fi(x∗)>(x − x∗). By convexity of
fi one has gi(x) ≥ 0 for any x and in particular using (3.5) this yields
−gi(x) ≤ − 1

2 which can be equivalently written as

2β k∇gi(x)k2

k∇fi(x) − ∇fi(x∗)k2

2 ≤ 2β(fi(x) − fi(x∗) − ∇fi(x∗)>(x − x∗)).

Taking expectation with respect to i and observing that E∇fi(x∗) =
∇f (x∗) = 0 yields the claimed bound.

On the other hand the computation of ∇f (y) is expensive (it re-
quires m gradient computations), and thus the centering sequence
should be updated more rarely than the main sequence. These ideas
lead to the following epoch-based algorithm.

Let y(1) ∈ Rn be an arbitrary initial point. For s = 1, 2 . . ., let

x(s)
1 = y(s). For t = 1, . . . , k let

t+1 = x(s)
x(s)

t − η

(cid:18)

∇f

i(s)
t

(x(s)

t ) − ∇f

i(s)
t

(y(s)) + ∇f (y(s))

(cid:19)

,

where i(s)
thing else) in [m]. Also let

t

is drawn uniformly at random (and independently of every-

y(s+1) =

1
k

k
X

t=1

x(s)
t

.

Theorem 6.5. Let f1, . . . fm be β-smooth convex functions on Rn and
f be α-strongly convex. Then SVRG with η = 1
10β and k = 20κ satisﬁes

Ef (y(s+1)) − f (x∗) ≤ 0.9s(f (y(1)) − f (x∗)).

## 6.3 Sum of smooth and strongly convex functions


Proof. We ﬁx a phase s ≥ 1 and we denote by E the expectation taken
with respect to i(s)

1 , . . . , i(s)

Ef (y(s+1)) − f (x∗) = Ef

− f (x∗) ≤ 0.9(f (y(s)) − f (x∗)),

k . We show below that
!

1
k

k
X

t=1

x(s)
t

which clearly implies the theorem. To simplify the notation in the fol-
lowing we drop the dependency on s, that is we want to show that

Ef

!

xt

1
k

k
X

t=1

− f (x∗) ≤ 0.9(f (y) − f (x∗)).

(6.1)

We start as for the proof of Theorem 3.10 (analysis of gradient descent
for smooth and strongly convex functions) with

kxt+1 − x∗k2

2 = kxt − x∗k2

2 − 2ηv>

t (xt − x∗) + η2kvtk2
2,

(6.2)

where

vt = ∇fit(xt) − ∇fit(y) + ∇f (y).

Using Lemma 6.4, we upper bound Eitkvtk2
EkX − E(X)k2

2, and Eit∇fit(x∗) = 0):

2 ≤ EkXk2

2 as follows (also recall that

Eitkvtk2
# 2 ≤ 2Eitk∇fit(xt) − ∇fit(x∗)k2
≤ 2Eitk∇fit(xt) − ∇fit(x∗)k2
≤ 4β(f (xt) − f (x∗) + f (y) − f (x∗)).

2 + 2Eitk∇fit(y) − ∇fit(x∗) − ∇f (y)k2
2
2 + 2Eitk∇fit(y) − ∇fit(x∗)k2
2

(6.3)

Also observe that

Eitv>

t (xt − x∗) = ∇f (xt)>(xt − x∗) ≥ f (xt) − f (x∗),

and thus plugging this into (6.2) together with (6.3) one obtains

Eitkxt+1 − x∗k2

2 ≤ kxt − x∗k2

2 − 2η(1 − 2βη)(f (xt) − f (x∗))

+4βη2(f (y) − f (x∗)).

Summing the above inequality over t = 1, . . . , k yields

Ekxk+1 − x∗k2

2 ≤ kx1 − x∗k2

2 − 2η(1 − 2βη)E

k
X

t=1

(f (xt) − f (x∗))

+4βη2k(f (y) − f (x∗)).



338

Convex optimization and randomness

2 kx − x∗k2
!

Noting that x1 = y and that by α-strong convexity one has f (x) −
f (x∗) ≥ α

2, one can rearrange the above display to obtain

Ef

1
k

k
X

t=1

xt

− f (x∗) ≤

(cid:18)

# 1 αη(1 − 2βη)k

+

2βη
1 − 2βη

(cid:19)

(f (y) − f (x∗)).

Using that η = 1
cludes the proof.

10β and k = 20κ ﬁnally yields (6.1) which itself con-

## 6.4 Random coordinate descent

We assume throughout this section that f is a convex and diﬀerentiable
function on Rn, with a unique3 minimizer x∗. We investigate one of the
simplest possible scheme to optimize f , the random coordinate descent
(RCD) method. In the following we denote ∇if (x) = ∂f
(x). RCD is
∂xi
deﬁned as follows, with an arbitrary initial point x1 ∈ Rn,

xs+1 = xs − η∇isf (x)eis,

where is is drawn uniformly at random from [n] (and independently of
everything else).

One can view RCD as SGD with the speciﬁc oracle eg(x) =
n∇I f (x)eI where I is drawn uniformly at random from [n]. Clearly
E

eg(x) = ∇f (x), and furthermore

Ekeg(x)k2

2 =

1
n

n
X

i=1

kn∇if (x)eik2

2 = nk∇f (x)k2
2.

Thus using Theorem 6.1 (with Φ(x) = 1
2 kxk2
one immediately obtains the following result.

2, that is S-MD being SGD)

Theorem 6.6. Let f be convex and L-Lipschitz on Rn, then RCD with
η = R
L

nt satisﬁes

q 2

Ef

(cid:18) 1
t

t
X

s=1

(cid:19)

xs

− min
x∈X

f (x) ≤ RL

r 2n
t

.

3Uniqueness is only assumed for sake of notation.


## 6.4 Random coordinate descent


Somewhat unsurprisingly RCD requires n times more iterations
than gradient descent to obtain the same accuracy. In the next sec-
tion, we will see that this statement can be greatly improved by taking
into account directional smoothness.

6.4.1 RCD for coordinate-smooth optimization

We assume now directional smoothness for f , that is there exists
β1, . . . , βn such that for any i ∈ [n], x ∈ Rn and u ∈ R,

|∇if (x + uei) − ∇if (x)| ≤ βi|u|.
If f is twice diﬀerentiable then this is equivalent to (∇2f (x))i,i ≤ βi. In
particular, since the maximal eigenvalue of a matrix is upper bounded
by its trace, one can see that the directional smoothness implies that f
is β-smooth with β ≤ Pn
i=1 βi. We now study the following “aggressive"
RCD, where the step-sizes are of order of the inverse smoothness:

∇isf (x)eis.

xs+1 = xs −

1
βis
Furthermore we study a more general sampling distribution than uni-
form, precisely for γ ≥ 0 we assume that is is drawn (independently)
from the distribution pγ deﬁned by
βγ
i
j=1 βγ
This algorithm was proposed in Nesterov [2012], and we denote it by
RCD(γ). Observe that, up to a preprocessing step of complexity O(n),
one can sample from pγ in time O(log(n)).

pγ(i) =

, i ∈ [n].

Pn

j

The following rate of convergence is derived in Nesterov [2012],

using the dual norms k · k[γ], k · k∗

[γ] deﬁned by

kxk[γ] =

v
u
u
t

n
X

i=1

βγ
i x2

i , and kxk∗

[γ] =

v
u
u
t

n
X

i=1

1
βγ
i

x2
i .

Theorem 6.7. Let f be convex and such that u ∈ R 7→ f (x + uei) is
βi-smooth for any i ∈ [n], x ∈ Rn. Then RCD(γ) satisﬁes for t ≥ 2,

Ef (xt) − f (x∗) ≤

2R2

1−γ(x1) Pn
t − 1

i=1 βγ

i

,

340

where

Convex optimization and randomness

R1−γ(x1) =

sup
x∈Rn:f (x)≤f (x1)

kx − x∗k[1−γ].

Recall from Theorem 3.3 that in this context the basic gradient
descent attains a rate of βkx1 − x∗k2
i=1 βi (see the
discussion above). Thus we see that RCD(1) greatly improves upon
gradient descent for functions where β is of order of Pn
i=1 βi. Indeed in
this case both methods attain the same accuracy after a ﬁxed number
of iterations, but the iterations of coordinate descent are potentially
much cheaper than the iterations of gradient descent.

2/t where β ≤ Pn

Proof. By applying (3.5) to the βi-smooth function u ∈ R 7→ f (x+uei)
one obtains

(cid:18)

1
βi
We use this as follows:

x −

f

∇if (x)ei

(cid:19)

− f (x) ≤ −

1
2βi

(∇if (x))2.

Eisf (xs+1) − f (xs) =

n
X

i=1

(cid:18)

(cid:18)

f

xs −

pγ(i)

1
βi

∇if (xs)ei

(cid:19)

(cid:19)

− f (xs)

n
X

i=1

≤ −

(∇if (xs))2

pγ(i)
2βi
# 1 i=1 βγ
2 Pn
Denote δs = Ef (xs) − f (x∗). Observe that the above calculation can
be used to show that f (xs+1) ≤ f (xs) and thus one has, by deﬁnition
of R1−γ(x1),

k∇f (xs)k∗

= −

[1−γ]

(cid:17)2

(cid:16)

.

i

δs ≤ ∇f (xs)>(xs − x∗)

≤ kxs − x∗k[1−γ]k∇f (xs)k∗
≤ R1−γ(x1)k∇f (xs)k∗
[1−γ].

[1−γ]

Thus putting together the above calculations one obtains

δs+1 ≤ δs −

1
1−γ(x1) Pn

2R2

i=1 βγ

i

δ2
s .

The proof can be concluded with similar computations than for Theo-
rem 3.3.

## 6.4 Random coordinate descent


We discussed above the speciﬁc case of γ = 1. Both γ = 0 and
γ = 1/2 also have an interesting behavior, and we refer to Nesterov
[2012] for more details. The latter paper also contains a discussion of
high probability results and potential acceleration à la Nesterov. We
also refer to Richtárik and Takác [2012] for a discussion of RCD in a
distributed setting.

6.4.2 RCD for smooth and strongly convex optimization

If in addition to directional smoothness one also assumes strong con-
vexity, then RCD attains in fact a linear rate.

Theorem 6.8. Let γ ≥ 0. Let f be α-strongly convex w.r.t. k · k[1−γ],
and such that u ∈ R 7→ f (x + uei) is βi-smooth for any i ∈ [n], x ∈ Rn.
Let κγ =

, then RCD(γ) satisﬁes

Pn

βγ
i

i=1
α

Ef (xt+1) − f (x∗) ≤

1 −

!t

1
κγ

(f (x1) − f (x∗)).

We use the following elementary lemma.

Lemma 6.9. Let f be α-strongly convex w.r.t. k · k on Rn, then

f (x) − f (x∗) ≤

1
2α

k∇f (x)k2
∗.

Proof. By strong convexity, Hölder’s inequality, and an elementary cal-
culation,

f (x) − f (y) ≤ ∇f (x)>(x − y) −

α
# 2 ≤ k∇f (x)k∗kx − yk −

≤

1
2α

k∇f (x)k2
∗,

kx − yk2
2
α
2

kx − yk2
2

which concludes the proof by taking y = x∗.

We can now prove Theorem 6.8.

Proof. In the proof of Theorem 6.7 we showed that

δs+1 ≤ δs −

(cid:16)

# 1 i=1 βγ
2 Pn

i

k∇f (xs)k∗

[1−γ]

(cid:17)2

.


342

Convex optimization and randomness

On the other hand Lemma 6.9 shows that

(cid:16)

k∇f (xs)k∗

[1−γ]

(cid:17)2

≥ 2αδs.

The proof is concluded with straightforward calculations.

## 6.5 Acceleration by randomization for saddle points

We explore now the use of randomness for saddle point computations.
That is we consider the context of Section 5.2.1 with a stochastic
oracle of the following form: given z = (x, y) ∈ X × Y it outputs
eg(z) = (egX (x, y), egY (x, y)) where E (egX (x, y)|x, y) ∈ ∂xϕ(x, y), and
E (egY (x, y)|x, y) ∈ ∂y(−ϕ(x, y)). Instead of using true subgradients as
in SP-MD (see Section 5.2.2) we use here the outputs of the stochastic
oracle. We refer to the resulting algorithm as S-SP-MD (Stochastic Sad-
dle Point Mirror Descent). Using the same reasoning than in Section
## 6.1 and Section 5.2.2 one can derive the following theorem.

Theorem 6.10. Assume that the stochastic oracle is such that
E (kegX (x, y)k∗
Y . Then S-SP-MD
with a = BX
RX

X , and E (cid:0)kegY (x, y)k∗
Y
q 2
t satisﬁes
, and η =

X )2 ≤ B2
, b = BY
RY

(cid:1)2 ≤ B2

E

max
y∈Y

ϕ

1
t

t
X

s=1

!

xs, y

− min
x∈X

ϕ

x,

!!

1
t

t
X

s=1

ys

≤ (RX BX +RY BY )

r 2
t

.

Using S-SP-MD we revisit the examples of Section 5.2.4 and
Section 5.2.4. In both cases one has ϕ(x, y) = x>Ay (with Ai being
the ith column of A), and thus ∇xϕ(x, y) = Ay and ∇yϕ(x, y) = A>x.

Matrix games. Here x ∈ ∆n and y ∈ ∆m. Thus there is a quite
natural stochastic oracle:

egX (x, y) = AI , where I ∈ [m] is drawn according to y ∈ ∆m,

(6.4)

and ∀i ∈ [m],

egY (x, y)(i) = Ai(J), where J ∈ [n] is drawn according to x ∈ ∆n.

(6.5)




## 6.6 Convex relaxation and randomized rounding


the

iterations. Furthermore

max log(n + m)/ε2(cid:1)

Clearly kegX (x, y)k∞ ≤ kAkmax and kegX (x, y)k∞ ≤ kAkmax, which
implies that S-SP-MD attains an ε-optimal pair of points with
O (cid:0)kAk2
computa-
tional complexity of a step of S-SP-MD is dominated by drawing
the indices I and J which takes O(n + m). Thus overall the com-
plexity of getting an ε-optimal Nash equilibrium with S-SP-MD is
O (cid:0)kAk2
max(n + m) log(n + m)/ε2(cid:1). While the dependency on ε is
worse than for SP-MP (see Section 5.2.4), the dependencies on the
dimensions is eO(n + m) instead of eO(nm). In particular, quite aston-
ishingly, this is sublinear in the size of the matrix A. The possibility of
sublinear algorithms for this problem was ﬁrst observed in Grigoriadis
and Khachiyan [1995].

Linear classiﬁcation. Here x ∈ B2,n and y ∈ ∆m. Thus the stochas-
tic oracle for the x-subgradient can be taken as in (6.4) but for the
y-subgradient we modify (6.5) as follows. For a vector x we denote by
x2 the vector such that x2(i) = x(i)2. For all i ∈ [m], egY (x, y)(i) =
kxk2
x(j) Ai(J), where J ∈ [n] is drawn according to
∈ ∆n. Note
that one indeed has E(egY (x, y)(i)|x, y) = Pn
j=1 x(j)Ai(j) = (A>x)(i).
Furthermore kegX (x, y)k2 ≤ B, and

x2
kxk2
2

E(kegY (x, y)k2

∞|x, y) =

n
X

j=1

x(j)2
kxk2
2

max
i∈[m]

kxk2
x(j)

!2

Ai(j)

≤

n
X

j=1

Ai(j)2.

max
i∈[m]

Unfortunately this last term can be O(n). However it turns out that
one can do a more careful analysis of mirror descent in terms of local
norms, which allows to prove that the “local variance" is dimension-
free. We refer to Bubeck and Cesa-Bianchi [2012] for more details on
these local norms, and to Clarkson et al. [2012] for the speciﬁc details
in the linear classiﬁcation situation.

## 6.6 Convex relaxation and randomized rounding

In this section we brieﬂy discuss the concept of convex relaxation, and
the use of randomization to ﬁnd approximate solutions. By now there
is an enormous literature on these topics, and we refer to Barak [2014]


344

Convex optimization and randomness

for further pointers.

We study here the seminal example of MAXCUT. This problem
can be described as follows. Let A ∈ Rn×n
be a symmetric matrix of
non-negative weights. The entry Ai,j is interpreted as a measure of
the “dissimilarity" between point i and point j. The goal is to ﬁnd a
partition of [n] into two sets, S ⊂ [n] and Sc, so as to maximize the
total dissimilarity between the two groups: P
i∈S,j∈Sc Ai,j. Equivalently
MAXCUT corresponds to the following optimization problem:

+

max
x∈{−1,1}n

1
2

n
X

i,j=1

Ai,j(xi − xj)2.

(6.6)

Viewing A as the (weighted) adjacency matrix of a graph, one can
rewrite (6.6) as follows, using the graph Laplacian L = D − A where
D is the diagonal matrix with entries (Pn

j=1 Ai,j)i∈[n],

max
x∈{−1,1}n

x>Lx.

(6.7)

It turns out that this optimization problem is NP-hard, that is the
existence of a polynomial time algorithm to solve (6.7) would prove
that P = NP. The combinatorial diﬃculty of this problem stems from
the hypercube constraint. Indeed if one replaces {−1, 1}n by the Eu-
clidean sphere, then one obtains an eﬃciently solvable problem (it is
the problem of computing the maximal eigenvalue of L).

We show now that, while (6.7) is a diﬃcult optimization problem,
it is in fact possible to ﬁnd relatively good approximate solutions by
using the power of randomization. Let ζ be uniformly drawn on the
hypercube {−1, 1}n, then clearly

E ζ >Lζ =

n
X

i,j=1,i6=j

Ai,j ≥

1
2

max
x∈{−1,1}n

x>Lx.

This means that, on average, ζ is a 1/2-approximate solution to (6.7).
Furthermore it is immediate that the above expectation bound implies
that, with probability at least ε, ζ is a (1/2 − ε)-approximate solu-
tion. Thus by repeatedly sampling uniformly from the hypercube one
can get arbitrarily close (with probability approaching 1) to a 1/2-
approximation of MAXCUT.

## 6.6 Convex relaxation and randomized rounding


Next we show that one can obtain an even better approximation ra-
tio by combining the power of convex optimization and randomization.
This approach was pioneered by Goemans and Williamson [1995]. The
Goemans-Williamson algorithm is based on the following inequality

max
x∈{−1,1}n

x>Lx = max

x∈{−1,1}n

hL, xx>i ≤

max

X∈Sn

+,Xi,i=1,i∈[n]

hL, Xi.

The right hand side in the above display is known as the convex (or
SDP) relaxation of MAXCUT. The convex relaxation is an SDP and
thus one can ﬁnd its solution eﬃciently with Interior Point Meth-
ods (see Section 5.3). The following result states both the Goemans-
Williamson strategy and the corresponding approximation ratio.

Theorem 6.11. Let Σ be the solution to the SDP relaxation of
MAXCUT. Let ξ ∼ N (0, Σ) and ζ = sign(ξ) ∈ {−1, 1}n. Then

E ζ >Lζ ≥ 0.878 max

x∈{−1,1}n

x>Lx.

The proof of this result is based on the following elementary geo-

metric lemma.

Lemma 6.12. Let ξ ∼ N (0, Σ) with Σi,i = 1 for i ∈ [n], and ζ =
sign(ξ). Then

E ζiζj =

2
π

arcsin (Σi,j) .

Proof. Let V ∈ Rn×n (with ith row V >
i ) be such that Σ = V V >. Note
that since Σi,i = 1 one has kVik2 = 1 (remark also that necessarily
|Σi,j| ≤ 1, which will be important in the proof of Theorem 6.11).
Let ε ∼ N (0, In) be such that ξ = V ε. Then ζi = sign(V >
i ε), and in
particular

E ζiζj = P(V >

i ε ≥ 0 and V >

j ε ≥ 0) + P(V >

i ε ≤ 0 and V >

j ε ≤ 0

i ε ≥ 0 and V >
i ε ≥ 0 and V >
j ε ≥ 0|V >

−P(V >
= 2P(V >
= P(V >
= 1 − 2P(V >

j ε < 0|V >

i ε ≥ 0) − P(V >
i ε ≥ 0).

j ε < 0) − P(V >
j ε ≥ 0) − 2P(V >

j ε < 0|V >

i ε < 0 and V >
i ε ≥ 0 and V >
i ε ≥ 0)

j ε ≥ 0)
j ε < 0)

346

Convex optimization and randomness

Now a quick picture shows that P(V >
i Vj)
(recall that ε/kεk2 is uniform on the Euclidean sphere). Using the fact
that V >

i Vj = Σi,j and arccos(x) = π

2 −arcsin(x) conclude the proof.

i ε ≥ 0) = 1

π arccos(V >

j ε < 0|V >

We can now get to the proof of Theorem 6.11.

Proof. We shall use the following inequality:

1 −

2
π

arcsin(t) ≥ 0.878(1 − t), ∀t ∈ [−1, 1].

(6.8)

Also remark that for X ∈ Rn×n such that Xi,i = 1, one has

hL, Xi =

n
X

i,j=1

Ai,j(1 − Xi,j),

and in particular for x ∈ {−1, 1}n, x>Lx = Pn
i,j=1 Ai,j(1−xixj). Thus,
using Lemma 6.12, and the facts that Ai,j ≥ 0 and |Σi,j| ≤ 1 (see the
proof of Lemma 6.12), one has

E ζ >Lζ =

n
X

(cid:18)

1 −

Ai,j

i,j=1

2
π

(cid:19)

arcsin (Σi,j)

≥ 0.878

= 0.878

n
X

i,j=1

Ai,j (1 − Σi,j)

max

hL, Xi

X∈Sn

+,Xi,i=1,i∈[n]
x>Lx.

≥ 0.878 max

x∈{−1,1}n

Theorem 6.11 depends on the form of the Laplacian L (insofar as
(6.8) was used). We show next a result from Nesterov [1997] that ap-
plies to any positive semi-deﬁnite matrix, at the expense of the constant
of approximation. Precisely we are now interested in the following op-
timization problem:

max
x∈{−1,1}n

x>Bx.

(6.9)

The corresponding SDP relaxation is

max

X∈Sn

+,Xi,i=1,i∈[n]

hB, Xi.

## 6.7 Random walk based methods


Theorem 6.13. Let Σ be the solution to the SDP relaxation of (6.9).
Let ξ ∼ N (0, Σ) and ζ = sign(ξ) ∈ {−1, 1}n. Then

E ζ >Bζ ≥

2
π

max
x∈{−1,1}n

x>Bx.

Proof. Lemma 6.12 shows that

E ζ >Bζ =

n
X

i,j=1

Bi,j

2
π

arcsin (Xi,j) =

2
π

hB, arcsin(X)i.

Thus to prove the result it is enough to show that hB, arcsin(Σ)i ≥
hB, Σi, which is itself implied by arcsin(Σ) (cid:23) Σ (the implication is true
since B is positive semi-deﬁnite, just write the eigendecomposition).
Now we prove the latter inequality via a Taylor expansion. Indeed recall
that |Σi,j| ≤ 1 and thus denoting by A◦α the matrix where the entries
are raised to the power α one has

arcsin(Σ) =

+∞
X

k=0

(cid:1)

(cid:0)2k
k
4k(2k + 1)

Σ◦(2k+1) = Σ +

+∞
X

k=1

(cid:1)

(cid:0)2k
k
4k(2k + 1)

Σ◦(2k+1).

Finally one can conclude using the fact if A, B (cid:23) 0 then A ◦ B (cid:23) 0.
This can be seen by writing A = V V >, B = U U >, and thus

(A ◦ B)i,j = V >

i VjU >

i Uj = Tr(UjV >

j ViU >

i ) = hViU >

i , VjU >

j i.

In other words A ◦ B is a Gram-matrix and, thus it is positive semi-
deﬁnite.

## 6.7 Random walk based methods

Randomization naturally suggests itself in the center of gravity method
(see Section 2.1), as a way to circumvent the exact calculation of the
center of gravity. This idea was proposed and developed in Bertsimas
and Vempala [2004]. We give below a condensed version of the main
ideas of this paper.

Assuming that one can draw independent points X1, . . . , XN uni-
formly at random from the current set St, one could replace ct by
ˆct = 1
i=1 Xi. Bertsimas and Vempala [2004] proved the following
N

PN

348

Convex optimization and randomness

generalization of Lemma 2.2 for the situation where one cuts a convex
set through a point close the center of gravity. Recall that a convex set
K is in isotropic position if EX = 0 and EXX > = In, where X is a
random variable drawn uniformly at random from K. Note in particular
that this implies EkXk2
2 = n. We also say that K is in near-isotropic
position if 1

2 In (cid:22) EXX > (cid:22) 3

2 In.

Lemma 6.14. Let K be a convex set in isotropic position. Then for any
w ∈ Rn, w 6= 0, z ∈ Rn, one has

(cid:16)

Vol

K ∩ {x ∈ Rn : (x − z)>w ≥ 0}

(cid:17)

≥

(cid:18) 1
e

(cid:19)

− kzk2

Vol(K).

Thus if one can ensure that St is in (near) isotropic position, and
kct − ˆctk2 is small (say smaller than 0.1), then the randomized center
of gravity method (which replaces ct by ˆct) will converge at the same
speed than the original center of gravity method.

2 = n

Assuming that St is in isotropic position one immediately obtains
N , and thus by Chebyshev’s inequality one has P(kct −
Ekct − ˆctk2
ˆctk2 > 0.1) ≤ 100 n
N . In other words with N = O(n) one can ensure
that the randomized center of gravity method makes progress on a
constant fraction of the iterations (to ensure progress at every step one
would need a larger value of N because of an union bound, but this is
unnecessary).

PN

Let us now consider the issue of putting St in near-isotropic po-
sition. Let ˆΣt = 1
i=1(Xi − ˆct)(Xi − ˆct)>. Rudelson [1999] showed
N
that as long as N = eΩ(n), one has with high probability (say at least
probability 1 − 1/n2) that the set ˆΣ−1/2
(St − ˆct) is in near-isotropic
position.

t

Thus it only remains to explain how to sample from a near-isotropic
convex set K. This is where random walk ideas come into the picture.
The hit-and-run walk4 is described as follows: at a point x ∈ K, let L
be a line that goes through x in a direction taken uniformly at random,
then move to a point chosen uniformly at random in L∩K. Lovász [1998]

4Other random walks are known for this problem but hit-and-run is the one with
the sharpest theoretical guarantees. Curiously we note that one of those walks is
closely connected to projected gradient descent, see Bubeck et al. [2015a].

## 6.7 Random walk based methods


showed that if the starting point of the hit-and-run walk is chosen from
a distribution “close enough" to the uniform distribution on K, then
after O(n3) steps the distribution of the last point is ε away (in total
variation) from the uniform distribution on K. In the randomized center
of gravity method one can obtain a good initial distribution for St by
using the distribution that was obtained for St−1. In order to initialize
the entire process correctly we start here with S1 = [−L, L]n ⊃ X (in
Section 2.1 we used S1 = X ), and thus we also have to use a separation
oracle at iterations where ˆct 6∈ X , just like we did for the ellipsoid
method (see Section 2.2).

Wrapping up the above discussion, we showed (informally) that to
attain an ε-optimal point with the randomized center of gravity method
one needs: eO(n) iterations, each iterations requires eO(n) random sam-
ples from St (in order to put it in isotropic position) as well as a call
to either the separation oracle or the ﬁrst order oracle, and each sam-
ple costs eO(n3) steps of the random walk. Thus overall one needs eO(n)
calls to the separation oracle and the ﬁrst order oracle, as well as eO(n5)
steps of the random walk.

Acknowledgements

This text grew out of lectures given at Princeton University in 2013
and 2014. I would like to thank Mike Jordan for his support in this
project. My gratitude goes to the four reviewers, and especially the
non-anonymous referee Francis Bach, whose comments have greatly
helped to situate this monograph in the vast optimization literature.
Finally I am thankful to Philippe Rigollet for suggesting the new title
(a previous version of the manuscript was titled “Theory of Convex
Optimization for Machine Learning"), and to Yin-Tat Lee for many
insightful discussions about cutting-plane methods.

350

References

A. Agarwal and L. Bottou. A lower bound for the optimization of ﬁnite sums.

Arxiv preprint arXiv:1410.0723, 2014.

Z. Allen-Zhu and L. Orecchia. Linear coupling: An ultimate uniﬁcation of

gradient and mirror descent. Arxiv preprint arXiv:1407.1537, 2014.

K. M. Anstreicher. Towards a practical volumetric cutting plane method for
convex programming. SIAM Journal on Optimization, 9(1):190–206, 1998.

J.Y Audibert, S. Bubeck, and R. Munos. Bandit view on noisy optimization.
In S. Sra, S. Nowozin, and S. Wright, editors, Optimization for Machine
Learning. MIT press, 2011.

J.Y. Audibert, S. Bubeck, and G. Lugosi. Regret in online combinatorial

optimization. Mathematics of Operations Research, 39:31–45, 2014.

F. Bach. Learning with submodular functions: A convex optimization per-
spective. Foundations and Trends R(cid:13) in Machine Learning, 6(2-3):145–373,
2013.

F. Bach and E. Moulines. Non-strongly-convex smooth stochastic approxi-
mation with convergence rate o(1/n). In Advances in Neural Information
Processing Systems (NIPS), 2013.

F. Bach, R. Jenatton, J. Mairal, and G. Obozinski. Optimization with
sparsity-inducing penalties. Foundations and Trends R(cid:13) in Machine Learn-
ing, 4(1):1–106, 2012.

B. Barak. Sum of squares upper bounds, lower bounds, and open questions.

Lecture Notes, 2014.

351

352

References

A. Beck and M. Teboulle. Mirror Descent and nonlinear projected subgradient
methods for convex optimization. Operations Research Letters, 31(3):167–
175, 2003.

A. Beck and M. Teboulle. A fast iterative shrinkage-thresholding algorithm for
linear inverse problems. SIAM Journal on Imaging Sciences, 2(1):183–202,
2009.

A. Ben-Tal and A. Nemirovski. Lectures on modern convex optimization:
analysis, algorithms, and engineering applications. Society for Industrial
and Applied Mathematics (SIAM), 2001.

D. Bertsimas and S. Vempala. Solving convex programs by random walks.

Journal of the ACM, 51:540–556, 2004.

S. Boyd and L. Vandenberghe. Convex Optimization. Cambridge University

Press, 2004.

S. Boyd, N. Parikh, E. Chu, B. Peleato, and J. Eckstein. Distributed opti-
mization and statistical learning via the alternating direction method of
multipliers. Foundations and Trends R(cid:13) in Machine Learning, 3(1):1–122,
2011.

S. Bubeck. Introduction to online optimization. Lecture Notes, 2011.

S. Bubeck and N. Cesa-Bianchi. Regret analysis of stochastic and nonstochas-
tic multi-armed bandit problems. Foundations and Trends R(cid:13) in Machine
Learning, 5(1):1–122, 2012.

S. Bubeck and R. Eldan. The entropic barrier: a simple and optimal universal

self-concordant barrier. Arxiv preprint arXiv:1412.1587, 2014.

S. Bubeck, R. Eldan, and J. Lehec. Sampling from a log-concave distribu-
tion with projected langevin monte carlo. Arxiv preprint arXiv:1507.02564,
2015a.

S. Bubeck, Y.-T. Lee, and M. Singh. A geometric alternative to nesterov’s
accelerated gradient descent. Arxiv preprint arXiv:1506.08187, 2015b.

E. Candès and B. Recht. Exact matrix completion via convex optimization.

Foundations of Computational mathematics, 9(6):717–772, 2009.

A. Cauchy. Méthode générale pour la résolution des systemes d’équations

simultanées. Comp. Rend. Sci. Paris, 25(1847):536–538, 1847.

N. Cesa-Bianchi and G. Lugosi. Prediction, Learning, and Games. Cambridge

University Press, 2006.

A. Chambolle and T. Pock. A ﬁrst-order primal-dual algorithm for convex
problems with applications to imaging. Journal of Mathematical Imaging
and Vision, 40(1):120–145, 2011.

References

353

K. Clarkson, E. Hazan, and D. Woodruﬀ. Sublinear optimization for machine

learning. Journal of the ACM, 2012.

A. Conn, K. Scheinberg, and L. Vicente. Introduction to Derivative-Free Op-
timization. Society for Industrial and Applied Mathematics (SIAM), 2009.

T. M. Cover. 1990 shannon lecture. IEEE information theory society newslet-

ter, 42(4), 1992.

A. d’Aspremont. Smooth optimization with approximate gradient. SIAM

Journal on Optimization, 19(3):1171–1183, 2008.

A. Defazio, F. Bach, and S. Lacoste-Julien. Saga: A fast incremental gradient
method with support for non-strongly convex composite objectives.
In
Advances in Neural Information Processing Systems (NIPS), 2014.

O. Dekel, R. Gilad-Bachrach, O. Shamir, and L. Xiao. Optimal distributed on-
line prediction using mini-batches. Journal of Machine Learning Research,
13:165–202, 2012.

J. Duchi, S. Shalev-Shwartz, Y. Singer, and A. Tewari. Composite objective
mirror descent. In Proceedings of the 23rd Annual Conference on Learning
Theory (COLT), 2010.

J. C. Dunn and S. Harshbarger. Conditional gradient algorithms with open
loop step size rules. Journal of Mathematical Analysis and Applications, 62
(2):432–444, 1978.

M. Frank and P. Wolfe. An algorithm for quadratic programming. Naval

research logistics quarterly, 3(1-2):95–110, 1956.

M. P. Friedlander and P. Tseng. Exact regularization of convex programs.

SIAM Journal on Optimization, 18(4):1326–1350, 2007.

M. Goemans and D. Williamson.

Improved approximation algorithms for
maximum cut and satisﬁability problems using semideﬁnite programming.
Journal of the ACM, 42(6):1115–1145, 1995.

M. D. Grigoriadis and L. G. Khachiyan. A sublinear-time randomized ap-
proximation algorithm for matrix games. Operations Research Letters, 18:
53–58, 1995.

B. Grünbaum. Partitions of mass-distributions and of convex bodies by hy-

perplanes. Paciﬁc J. Math, 10(4):1257–1261, 1960.

T. Hastie, R. Tibshirani, and J. Friedman. The Elements of Statistical Learn-

ing. Springer, 2001.

E. Hazan. The convex optimization approach to regret minimization.

In
S. Sra, S. Nowozin, and S. Wright, editors, Optimization for Machine Learn-
ing, pages 287–303. MIT press, 2011.

354

References

M. Jaggi. Revisiting frank-wolfe: Projection-free sparse convex optimization.
In Proceedings of the 30th International Conference on Machine Learning
(ICML), pages 427–435, 2013.

P. Jain, P. Netrapalli, and S. Sanghavi. Low-rank matrix completion using
In Proceedings of the Forty-ﬁfth Annual ACM

alternating minimization.
Symposium on Theory of Computing, STOC ’13, pages 665–674, 2013.

R. Johnson and T. Zhang. Accelerating stochastic gradient descent using pre-
dictive variance reduction. In Advances in Neural Information Processing
Systems (NIPS), 2013.

L. K. Jones. A simple lemma on greedy approximation in hilbert space
and convergence rates for projection pursuit regression and neural network
training. Annals of Statistics, pages 608–613, 1992.

A. Juditsky and A. Nemirovski. First-order methods for nonsmooth convex
large-scale optimization, i: General purpose methods. In S. Sra, S. Nowozin,
and S. Wright, editors, Optimization for Machine Learning, pages 121–147.
MIT press, 2011a.

A. Juditsky and A. Nemirovski. First-order methods for nonsmooth con-
vex large-scale optimization, ii: Utilizing problem’s structure.
In S. Sra,
S. Nowozin, and S. Wright, editors, Optimization for Machine Learning,
pages 149–183. MIT press, 2011b.

N. Karmarkar. A new polynomial-time algorithm for linear programming.

Combinatorica, 4:373–395, 1984.

S. Lacoste-Julien, M. Schmidt, and F. Bach. A simpler approach to obtaining
an o (1/t) convergence rate for the projected stochastic subgradient method.
arXiv preprint arXiv:1212.2002, 2012.

N. Le Roux, M. Schmidt, and F. Bach. A stochastic gradient method with
an exponential convergence rate for strongly-convex optimization with ﬁ-
nite training sets. In Advances in Neural Information Processing Systems
(NIPS), 2012.

Y.-T. Lee and A. Sidford. Path ﬁnding i :solving linear programs with
ÃŢ(sqrt(rank)) linear system solves. Arxiv preprint arXiv:1312.6677, 2013.

Y.-T. Lee, A. Sidford, and S. C.-W Wong.

A faster cutting plane
method and its implications for combinatorial and convex optimization.
abs/1508.04874, 2015.

A. Levin. On an algorithm for the minimization of convex functions. In Soviet

Mathematics Doklady, volume 160, pages 1244–1247, 1965.

L. Lovász. Hit-and-run mixes fast. Math. Prog., 86:443–461, 1998.

References

355

G. Lugosi. Comment on: ‘1-penalization for mixture regression models. Test,

19(2):259–263, 2010.

N. Maculan and G. G. de Paula. A linear-time median-ﬁnding algorithm for
projecting a vector on the simplex of rn. Operations research letters, 8(4):
219–222, 1989.

A. Nemirovski. Orth-method for smooth convex optimization. Izvestia AN

SSSR, Ser. Tekhnicheskaya Kibernetika, 2, 1982.

A. Nemirovski. Information-based complexity of convex programming. Lecture

Notes, 1995.

A. Nemirovski. Prox-method with rate of convergence o (1/t) for variational
inequalities with lipschitz continuous monotone operators and smooth
convex-concave saddle point problems. SIAM Journal on Optimization,
15(1):229–251, 2004a.

A. Nemirovski. Interior point polynomial time methods in convex program-

ming. Lecture Notes, 2004b.

A. Nemirovski and D. Yudin. Problem Complexity and Method Eﬃciency in

Optimization. Wiley Interscience, 1983.

Y. Nesterov. A method of solving a convex programming problem with con-
vergence rate o(1/k2). Soviet Mathematics Doklady, 27(2):372–376, 1983.

Y. Nesterov. Quality of semideﬁnite relaxation for nonconvex quadratic op-
timization. CORE Discussion Papers 1997019, Université catholique de
Louvain, Center for Operations Research and Econometrics (CORE), 1997.

Y. Nesterov. Introductory lectures on convex optimization: A basic course.

Kluwer Academic Publishers, 2004a.

Y. Nesterov. Smooth minimization of non-smooth functions. Mathematical

programming, 103(1):127–152, 2004b.

Y. Nesterov. Gradient methods for minimizing composite objective function.
Core discussion papers, Université catholique de Louvain, Center for Op-
erations Research and Econometrics (CORE), 2007.

Y. Nesterov. Eﬃciency of coordinate descent methods on huge-scale optimiza-

tion problems. SIAM Journal on Optimization, 22:341–362, 2012.

Y. Nesterov and A. Nemirovski. Interior-point polynomial algorithms in con-
vex programming. Society for Industrial and Applied Mathematics (SIAM),
1994.

D. Newman. Location of the maximum on unimodal surfaces. Journal of the

ACM, 12(3):395–398, 1965.

356

References

J. Nocedal and S. J. Wright. Numerical Optimization. Springer, 2006.

N. Parikh and S. Boyd. Proximal algorithms. Foundations and Trends R(cid:13) in

Optimization, 1(3):123–231, 2013.

A. Rakhlin. Lecture notes on online learning. 2009.

J. Renegar. A mathematical view of interior-point methods in convex opti-

mization, volume 3. Siam, 2001.

P. Richtárik and M. Takác. Parallel coordinate descent methods for big data

optimization. Arxiv preprint arXiv:1212.0873, 2012.

H. Robbins and S. Monro. A stochastic approximation method. Annals of

Mathematical Statistics, 22:400–407, 1951.

R. Rockafellar. Convex Analysis. Princeton University Press, 1970.

M. Rudelson. Random vectors in the isotropic position. Journal of Functional

Analysis, 164:60–72, 1999.

M. Schmidt, N. Le Roux, and F. Bach. Convergence rates of inexact proximal-
gradient methods for convex optimization. In Advances in neural informa-
tion processing systems, pages 1458–1466, 2011.

B. Schölkopf and A. Smola. Learning with kernels. MIT Press, 2002.

S. Shalev-Shwartz and S. Ben-David. Understanding Machine Learning: From

Theory to Algorithms. Cambridge University Press, 2014.

S. Shalev-Shwartz and T. Zhang. Stochastic dual coordinate ascent methods
for regularized loss minimization. Journal of Machine Learning Research,
14:567–599, 2013a.

S. Shalev-Shwartz and T. Zhang. Accelerated mini-batch stochastic dual co-
In Advances in Neural Information Processing Systems

ordinate ascent.
(NIPS), 2013b.

W. Su, S. Boyd, and E. Candès. A diﬀerential equation for modeling nesterov’s
accelerated gradient method: Theory and insights. In Advances in Neural
Information Processing Systems (NIPS), 2014.

R. Tibshirani. Regression shrinkage and selection via the lasso. Journal of
the Royal Statistical Society. Series B (Methodological), 58(1):pp. 267–288,
1996.

P. Tseng. On accelerated proximal gradient methods for convex-concave op-

timization. 2008.

A. Tsybakov. Optimal rates of aggregation. In Conference on Learning Theory

(COLT), pages 303–313. 2003.

References

357

P. M. Vaidya. A new algorithm for minimizing convex functions over convex
sets. In Foundations of Computer Science, 1989., 30th Annual Symposium
on, pages 338–343, 1989.

P. M. Vaidya. A new algorithm for minimizing convex functions over convex

sets. Mathematical programming, 73(3):291–341, 1996.

S. J. Wright, R. D. Nowak, and M. A. T. Figueiredo. Sparse reconstruction
by separable approximation. IEEE Transactions on Signal Processing, 57
(7):2479–2493, 2009.

L. Xiao. Dual averaging methods for regularized stochastic learning and online
optimization. Journal of Machine Learning Research, 11:2543–2596, 2010.

Y. Zhang and L. Xiao. Stochastic primal-dual coordinate method for regular-
ized empirical risk minimization. Arxiv preprint arXiv:1409.3257, 2014.

