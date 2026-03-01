---
book: Bubeck15
chapter: 1
chapter_title: ''
subsection: 4
subsection_title: Black-box model
section_id: '1.4'
theorems: []
lean_files: []
---

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