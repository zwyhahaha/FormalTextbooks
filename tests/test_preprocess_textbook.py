"""Tests for preprocess_textbook pipeline."""
import sys
import os
import tempfile
from pathlib import Path

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'scripts'))

from preprocess_textbook import split_subsections


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
