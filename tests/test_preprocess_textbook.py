"""Tests for preprocess_textbook pipeline."""
import sys
import os
import tempfile
from pathlib import Path

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'scripts'))

from preprocess_textbook import split_subsections, detect_theorems


# --- detect_theorems tests ---

def test_detect_basic():
    content = "See Theorem 3.2 for the main result."
    thms = detect_theorems(content)
    assert len(thms) == 1
    assert thms[0]['id'] == 'Theorem 3.2'
    assert thms[0]['label'] == ''


def test_detect_with_label():
    content = "Lemma 1.1 (Projection onto convex set). Let $C$ be convex."
    thms = detect_theorems(content)
    assert len(thms) == 1
    assert thms[0]['id'] == 'Lemma 1.1'
    assert thms[0]['label'] == 'Projection onto convex set'


def test_detect_multiple():
    content = """
Theorem 3.2. GD converges.
Corollary 3.3 (Rate). The rate is O(1/k).
Definition 4.1. A function is L-smooth if...
"""
    thms = detect_theorems(content)
    ids = [t['id'] for t in thms]
    assert 'Theorem 3.2' in ids
    assert 'Corollary 3.3' in ids
    assert 'Definition 4.1' in ids


def test_detect_empty():
    assert detect_theorems("") == []


def test_detect_no_theorems():
    assert detect_theorems("Just some regular prose.") == []


# --- split_subsections tests ---

def test_split_empty():
    assert split_subsections("") == []


def test_split_no_subsections():
    assert split_subsections("# 1 Intro\n\nSome text.") == []


def test_split_cross_chapter():
    md = """# 1 Introduction

## 1.1 First

Content A.

# 2 Methods

## 2.1 Setup

Content B.

## 2.2 Details

Content C.
"""
    subs = split_subsections(md)
    assert len(subs) == 3
    assert subs[0]['chapter'] == 1
    assert subs[0]['chapter_title'] == 'Introduction'
    assert subs[1]['chapter'] == 2
    assert subs[1]['chapter_title'] == 'Methods'
    assert subs[2]['section_id'] == '2.2'


def test_split_content_preserved():
    md = "# 1 Intro\n\n## 1.1 Topic\n\nLet $f: \\mathbb{R}^n \\to \\mathbb{R}$.\n"
    subs = split_subsections(md)
    assert '$f:' in subs[0]['content']


def test_split_basic():
    md = """# 1 Introduction

## 1.1 Some convex problems

Content about convex problems.

## 1.2 Basic properties

Content about properties.
"""
    subs = split_subsections(md)
    assert len(subs) == 2
    assert subs[0]['chapter'] == 1
    assert subs[0]['chapter_title'] == 'Introduction'
    assert subs[0]['subsection'] == 1
    assert subs[0]['subsection_title'] == 'Some convex problems'
    assert subs[0]['section_id'] == '1.1'
    assert subs[1]['subsection'] == 2
    assert subs[1]['section_id'] == '1.2'
