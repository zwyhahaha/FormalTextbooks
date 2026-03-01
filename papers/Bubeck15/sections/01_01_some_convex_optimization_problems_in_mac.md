---
book: Bubeck15
chapter: 1
chapter_title: ''
subsection: 1
subsection_title: Some convex optimization problems in machine learning
section_id: '1.1'
theorems: []
lean_files: []
---

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