This project aims to build a demo for automatically formalizing some given theorems in optimization.

As a high level goal, I would give you some optimization papers / lecture notes. 
Then this demo would read the papers and output the formal proofs in Lean 4 for the theorems in the papers.

To build this system, you may need to set up claude code with lean 4 skills / plugin / agents. 

To facilitate Lean 4 skills, it is recommended to use Lean MCP Server.

Also, to better understand the context, this demo can also preprocess the papers: convert it into MarkDown, then splitting them into multiple separate files (one per section) for progressive disclosure.

For formalizing optimization theorems, there is a Lean library, `optlib`. You can need to design a method to better understand and indexing this library.

As a minimal proof for this pipeline, we may need to start with some simple tasks:
1. given an informal proof from GPT 5.2, translate it into formal proofs.
2. given a pdf lecture note, convert it into markdown and splitting them into multiple separate files (one per section). Then try to give the formal proof for one of the theorem mentioned in the lecture note.