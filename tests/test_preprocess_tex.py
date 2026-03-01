"""Tests for preprocess_tex pipeline."""
import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'scripts'))


def test_import():
    import preprocess_tex  # noqa: F401


from preprocess_tex import load_macros
from pathlib import Path

TEX_DIR = Path("textbook/Bubeck15-arXiv-1405.4980v2")


def test_load_macros_basic():
    macros = load_macros(TEX_DIR / "Commands.tex")
    assert macros[r"\R"] == r"\mathbb{R}"
    assert macros[r"\cX"] == r"\mathcal{X}"
    assert macros[r"\E"] == r"\mathbb{E}"


def test_load_macros_returns_dict():
    macros = load_macros(TEX_DIR / "Commands.tex")
    assert isinstance(macros, dict)
    assert len(macros) > 10
