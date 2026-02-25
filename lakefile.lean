import Lake
open Lake DSL

package «prover» where
  leanOptions := #[
    ⟨`pp.unicode.fun, true⟩
  ]

require optlib from git "https://github.com/optsuite/optlib" @ "main"

@[default_target]
lean_lib «Prover» where
