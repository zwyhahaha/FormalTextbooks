---
book: Bubeck15
chapter: 1
chapter_title: ''
subsection: 6
subsection_title: Overview of the results and disclaimer
section_id: '1.6'
theorems: []
lean_files: []
---

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