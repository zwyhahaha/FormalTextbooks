---
book: Bubeck15
chapter: 1
chapter_title: ''
subsection: 2
subsection_title: Basic properties of convexity
section_id: '1.2'
theorems:
- id: Proposition 1.1
  label: Existence of subgradients
lean_files:
- id: Proposition 1.1
  path: proofs/Bubeck15/Proposition11.lean
  status: pending
---

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