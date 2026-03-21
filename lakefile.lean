import Lake
open Lake DSL

package «prover» where
  leanOptions := #[
    ⟨`pp.unicode.fun, true⟩
  ]

require optlib from git "https://github.com/optsuite/optlib" @ "main"

@[default_target]
lean_lib «Prover» where

lean_lib «Proofs» where
  srcDir := "."
  roots := #[`proofs.demo.GradientDescentConvergence,
             `proofs.demo_lecture.Theorem21,
             `proofs.Bubeck_convex_optimization.Proposition16,
             `proofs.Bubeck_convex_optimization.Proposition15,
             `proofs.Bubeck_convex_optimization.Proposition17,
             `proofs.Bubeck_convex_optimization.Lemma22,
             `proofs.Bubeck_convex_optimization.Lemma22_BM1D,
             `proofs.Bubeck_convex_optimization.Lemma22_ConeOpt,
             `proofs.Bubeck_convex_optimization.Theorem21,
             `proofs.Bubeck_convex_optimization.Lemma25,
             `proofs.Bubeck_convex_optimization.Lemma31,
             `proofs.Bubeck_convex_optimization.Theorem32,
             `proofs.Bubeck_convex_optimization.Lemma34,
             `proofs.Bubeck_convex_optimization.Lemma35,
             `proofs.Bubeck_convex_optimization.Lemma36,
             `proofs.Bubeck_convex_optimization.Theorem33,
             `proofs.Bubeck_convex_optimization.Theorem37]
