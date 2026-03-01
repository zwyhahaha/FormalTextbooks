"""TeX source preprocessing pipeline: Bubeck15 TeX → subsection-level markdown files."""
import datetime, json, re, subprocess, sys, tempfile
from pathlib import Path
import yaml

LOG_FILE = Path("logs/pipeline.log")

CHAPTER_FILES = [
    (1, "Introduction",                                                      "intro2.tex"),
    (2, "Convex optimization in finite dimension",                           "finitedim2.tex"),
    (3, "Dimension-free convex optimization",                                "dimfree2.tex"),
    (4, "Almost dimension-free convex optimization in non-Euclidean spaces", "mirror2.tex"),
    (5, "Beyond the black-box model",                                        "beyond2.tex"),
    (6, "Convex optimization and randomness",                                "rand2.tex"),
]

THEOREM_ENVS = {"theorem", "lemma", "proposition", "corollary", "definition", "remark"}


# Matches: \newcommand{\NAME}{EXPANSION} or \renewcommand{\NAME}{EXPANSION}
# Expansion group handles one level of nested braces (e.g. \mathbb{R})
_NEWCMD_RE = re.compile(
    r'\\(?:new|renew)command\{(\\[a-zA-Z]+)\}\{((?:[^{}]|\{[^{}]*\})*)\}'
)


def load_macros(commands_path: Path) -> dict[str, str]:
    """Parse Commands.tex and return {macro: expansion} dict.

    Only captures simple one-argument-free macros (no #1 parameters).
    Skips macros whose expansion contains '#' (parameterized).
    """
    text = commands_path.read_text(encoding="utf-8")
    result = {}
    for m in _NEWCMD_RE.finditer(text):
        name, expansion = m.group(1), m.group(2)
        if "#" not in expansion:
            result[name] = expansion
    return result


def _log(event: str, data: dict) -> None:
    LOG_FILE.parent.mkdir(parents=True, exist_ok=True)
    entry = {"ts": datetime.datetime.now().isoformat(timespec="seconds"), "event": event, **data}
    with LOG_FILE.open("a") as f:
        f.write(json.dumps(entry) + "\n")


if __name__ == "__main__":
    print("preprocess_tex scaffold ok")
