---
book: Bubeck15
chapter: 1
chapter_title: ''
subsection: 5
subsection_title: Structured optimization
section_id: '1.5'
theorems: []
lean_files: []
---

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