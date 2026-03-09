# Server Setup for Formal Verification Pipeline

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Stand up the full formalization pipeline on a remote Linux server so theorems can be proved autonomously via Claude Code + Lean 4.

**Architecture:** Install system dependencies (Node, Python, elan/Lean), clone the repo, pull Mathlib cache, then configure Claude Code with the lean4 plugin and lean-lsp-mcp. Everything runs on CPU — Claude Code itself is a thin CLI that calls the Anthropic API remotely; only `lake build` and (optionally) `marker_single` run locally.

**Tech Stack:** Ubuntu 22.04+ (or Debian 12), Node.js ≥18, Python ≥3.10, elan (Lean version manager), lake (Lean build tool), Claude Code CLI, lean-lsp-mcp, optlib + mathlib4 via lake

---

## CPU vs GPU

**Claude Code itself: CPU-only.**
Claude Code is a CLI wrapper that sends prompts to the Anthropic API over HTTPS. No model weights run locally. You only need internet access and an API key.

**Lean 4 / lake build: CPU-only.**
All Lean elaboration and proof checking is CPU-bound. More cores = faster parallel compilation. Recommended: ≥8 cores, ≥16 GB RAM.

**`marker_single` (PDF→Markdown, Workflow C): GPU optional.**
`marker_single` is an ML layout model. It runs on CPU but is 10–30× faster with a CUDA GPU. For the `--fast` mode (pdfminer, no ML), GPU is irrelevant. If you only use TeX source (Workflow D via `preprocess_tex.py`), you never need `marker_single` at all.

**Summary:** For pure theorem-proving from TeX source, a CPU-only server is completely sufficient.

---

## Prerequisites (know before you start)

- Server OS: Ubuntu 22.04 LTS or Debian 12 (tested)
- You have `sudo` on the server
- Outbound HTTPS is open (GitHub, leanprover-community CDN, Anthropic API)
- You have an Anthropic API key with Claude Sonnet/Opus access
- You have SSH access to the server and a GitHub account

---

## Task 1: Install System Dependencies

**Files:** none
**Time:** ~5 min

**Step 1: Update apt and install base tools**

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl wget build-essential python3 python3-pip python3-venv unzip
```

**Step 2: Install Node.js ≥18 (required by Claude Code)**

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
node --version   # should print v20.x.x
```

**Step 3: Verify Python version**

```bash
python3 --version   # should be 3.10+
```

---

## Task 2: Install elan and Lean 4

**Files:** none
**Time:** ~5 min (elan install) + 5–10 min (Lean toolchain download)

**Step 1: Install elan (Lean version manager)**

```bash
curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh
# Accept defaults. When asked to modify PATH, say yes.
source "$HOME/.elan/env"
```

**Step 2: Verify elan is on PATH**

```bash
elan --version   # should print elan 3.x.x
```

**Step 3: Install the exact Lean toolchain pinned by this project**

The repo pins `leanprover/lean4:v4.13.0` in `lean-toolchain`. elan will auto-install it when you first run `lake`, but you can pre-install:

```bash
elan toolchain install leanprover/lean4:v4.13.0
elan default leanprover/lean4:v4.13.0
lean --version   # should print Lean (version 4.13.0, ...)
```

---

## Task 4: Pull Mathlib Cache and Build

> **This is the most critical step.** Without the Mathlib cache, `lake build` recompiles ~100k files from scratch (~2–3 hours). With the cache it takes ~5 minutes.

**Files:** `.lake/` directory (auto-created)
**Time:** ~5–15 min (with cache)

**Step 1: Pull the Mathlib binary cache**

```bash
cd ~/prover
lake exe cache get
```

Expected output ends with:
```
Decompressing X/Y files...
Done.
```

If you see `lake: command not found`, run `source "$HOME/.elan/env"` first.

**Step 2: Build the project**

```bash
lake build
```

Expected: no errors. Warnings about `sorry` in proof files are OK.
This downloads and compiles optlib (~2–5 min after cache is warm).

**Step 3: Confirm build passes**

```bash
echo $?   # should print 0
```


---

## Task 6: Install lean-lsp-mcp (Lean MCP Server)

The lean-lsp-mcp gives Claude Code live Lean proof state, diagnostics, and lemma search during proving sessions. Without it, `/lean4:autoprove` still works but cannot call `lean_goal` or `lean_diagnostic_messages`.

**Files:** `~/.claude/claude.json` (MCP server config)
**Time:** ~5 min

**Step 1: Install lean-lsp-mcp via npm**

```bash
npm install -g lean-lsp-mcp
lean-lsp-mcp --version   # should print a version number
```

**Step 2: Register it as a global MCP server in Claude Code**

```bash
claude mcp add lean-lsp-mcp lean-lsp-mcp
```

Or manually edit `~/.claude/claude.json`:

```json
{
  "mcpServers": {
    "lean-lsp": {
      "command": "lean-lsp-mcp",
      "args": [],
      "env": {}
    }
  }
}
```

**Step 3: Verify the MCP server is registered**

```bash
claude mcp list   # should show lean-lsp in the list
```

---

## Task 7: Install the lean4 Skills Plugin

The `lean4` skills (e.g. `/lean4:autoprove`, `/lean4:checkpoint`) are what actually drive autonomous proving. They are loaded via the Claude Code plugin system.

**Files:** `~/.claude/plugins/`
**Time:** ~2 min

**Step 1: Check if the plugin is already bundled with Claude Code**

```bash
ls ~/.claude/plugins/cache/ 2>/dev/null || echo "no plugins yet"
```

**Step 2: If not present, install the official superpowers/lean4 plugin**

```bash
# The plugin registry command (exact syntax may vary by Claude Code version):
claude plugin install lean4
# Or via the settings file if claude plugin install is not available:
# Edit ~/.claude/settings.json and add the plugin entry per Claude Code docs
```

**Step 3: Verify skills are available**

Start a Claude Code session in the project:

```bash
cd ~/prover
claude
```

Then type `/lean4:autoprove` — if the skill loads without error, the plugin is active.

---

## Task 8: Install Python Dependencies (for preprocessing scripts)

Only needed if you want to run `preprocess_tex.py` or `preprocess_textbook.py` to convert new papers. Not needed for pure theorem-proving on already-converted content.

**Files:** `~/prover/venv/`
**Time:** ~3 min

**Step 1: Create a virtual environment**

```bash
cd ~/prover
python3 -m venv venv
source venv/bin/activate
```

**Step 2: Install dependencies**

```bash
pip install --upgrade pip
# Core deps used by the scripts:
pip install pyyaml pathlib2

# For Workflow C (PDF conversion via marker_single, CPU mode):
pip install marker-pdf

# For Workflow D (TeX source, no extra ML deps needed):
# preprocess_tex.py only uses pandoc (system tool) + stdlib
sudo apt install -y pandoc
```

**Step 3: Test the TeX preprocessor**

```bash
# If you have a TeX source directory:
python3 scripts/preprocess_tex.py textbook/Bubeck15-arXiv-1405.4980v2/ --chapter 1
ls papers/Bubeck_convex_optimization/sections/
```

---

## Task 9: Configure Project Settings

**Files:** `.claude/settings.local.json` (already in repo, may need updating)

**Step 1: Copy or create local settings**

```bash
cd ~/prover
cat .claude/settings.local.json   # review current settings
```

**Step 2: Set the project working directory explicitly**
The path in `goal.md` and some commands reference `/Users/apple/Documents/formal verification/prover`. On the server this will be different (e.g. `/home/ubuntu/prover`). You don't need to edit Lean files — this path only appears in prose notes.

**Step 3: Confirm `lake env lean` works on a proof file**

```bash
lake env lean proofs/demo/GradientDescentConvergence.lean
# Expected: no output (clean) or only sorry warnings
```

---

## Task 10: Run a Full End-to-End Smoke Test

This confirms every layer of the stack works together.

**Step 1: Start a Claude Code session in the project**

```bash
cd ~/prover
claude
```

**Step 2: Run the autoprove skill on an already-proved theorem to confirm the pipeline**

In the Claude Code session:

```
/lean4:autoprove
Formalize Proposition 1.6 (Local minima are global minima) from:
  papers/Bubeck_convex_optimization/sections/01_03_why_convexity.md
Check optlib first.
```

**Step 3: Confirm lean_goal MCP tool responds**

During the session, Claude should call `lean_goal` and get a proof state back (not a timeout). If it times out, run `lake build` again and restart the session.

**Step 4: After proof completes, verify with `lake env lean`**

```bash
lake env lean proofs/Bubeck_convex_optimization/Proposition16.lean
# Expected: zero output
```

---

## Quick Reference: What Runs Where

| Component | Runs On | Notes |
|-----------|---------|-------|
| Claude Code CLI | CPU (client) | Sends API calls to Anthropic servers |
| Anthropic Claude model | Anthropic cloud | Your API key → Sonnet/Opus |
| `lake build` / Lean elaboration | Server CPU | 8+ cores recommended |
| `lean-lsp-mcp` | Server CPU | LSP subprocess, lightweight |
| `preprocess_tex.py` | Server CPU | pandoc + stdlib, no GPU |
| `preprocess_textbook.py --fast` | Server CPU | pdfminer, no GPU |
| `preprocess_textbook.py` (default) | Server CPU or GPU | marker_single ML model; GPU optional |

---

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| `lake: command not found` | `source "$HOME/.elan/env"` |
| `lake build` takes hours | You missed `lake exe cache get` — run it first |
| lean-lsp-mcp times out | `lake build` hasn't finished; wait and retry |
| `claude` not on PATH | Add `~/.npm-global/bin` to PATH in `~/.bashrc` |
| API key errors | Confirm `ANTHROPIC_API_KEY` is set in shell env |
| `marker_single` OOM on CPU | Use `--fast` flag; or add `--workers 1` |
| Lean toolchain version mismatch | Run `elan toolchain install leanprover/lean4:v4.13.0` |
