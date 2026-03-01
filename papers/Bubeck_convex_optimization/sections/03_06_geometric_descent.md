---
book: Bubeck_convex_optimization
chapter: 3
chapter_title: Dimension-free convex optimization
section: 6
section_title: Geometric descent
subsection: null
subsection_title: null
section_id: '3.6'
tex_label: sec:GeoD
theorems: []
lean_files: []
---

\section{Geometric descent} \label{sec:GeoD}
So far our results leave a gap in the case of smooth optimization: gradient descent achieves an oracle complexity of $O(1/\epsilon)$ (respectively $O(\kappa \log(1/\epsilon))$ in the strongly convex case) while we proved a lower bound of $\Omega(1/\sqrt{\epsilon})$ (respectively $\Omega(\sqrt{\kappa} \log(1/\epsilon))$). In this section we close these gaps with the geometric descent method which was recently introduced in \cite{BLS15}. Historically the first method with optimal oracle complexity was proposed in \cite{NY83}. This method, inspired by the conjugate gradient (see Section \ref{sec:CG}), assumes an oracle to compute {\em plane searches}. In \cite{Nem82} this assumption was relaxed to a line search oracle (the geometric descent method also requires a line search oracle). Finally in \cite{Nes83} an optimal method requiring only a first order oracle was introduced. The latter algorithm, called Nesterov's accelerated gradient descent, has been the most influential optimal method for smooth optimization up to this day. We describe and analyze this method in Section \ref{sec:AGD}. As we shall see the intuition behind Nesterov's accelerated gradient descent (both for the derivation of the algorithm and its analysis) is not quite transparent, which motivates the present section as geometric descent has a simple geometric interpretation loosely inspired from the ellipsoid method (see Section \ref{sec:ellipsoid}).

We focus here on the unconstrained optimization of a smooth and strongly convex function, and we prove that geometric descent achieves the oracle complexity of $O(\sqrt{\kappa} \log(1/\epsilon))$, thus reducing the complexity of the basic gradient descent by a factor $\sqrt{\kappa}$. We note that this improvement is quite relevant for machine learning applications. Consider for example the logistic regression problem described in Section \ref{sec:mlapps}: this is a smooth and strongly convex problem, with a smoothness of order of a numerical constant, but with strong convexity equal to the regularization parameter whose inverse can be as large as the sample size. Thus in this case $\kappa$ can be of order of the sample size, and a faster rate by a factor of $\sqrt{\kappa}$ is quite significant. We also observe that this improved rate for smooth and strongly convex objectives also implies an almost optimal rate of $O(\log(1/\epsilon) / \sqrt{\epsilon})$ for the smooth case, as one can simply run geometric descent on the function $x \mapsto f(x) + \epsilon \|x\|^2$. 

In Section \ref{sec:warmup} we describe the basic idea of geometric descent, and we show how to obtain effortlessly a geometric method with an oracle complexity of $O(\kappa \log(1/\epsilon))$ (i.e., similar to gradient descent). Then we explain why one should expect to be able to accelerate this method in Section \ref{sec:accafterwarmup}. The geometric descent method is described precisely and analyzed in Section \ref{sec:GeoDmethod}.