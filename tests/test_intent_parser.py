"""Tests for the intent parser."""

import pytest
from voice.intent_parser import IntentParser, Intent


def _parse(text: str) -> Intent | None:
    parser = IntentParser.__new__(IntentParser)  # skip bus.subscribe in __init__
    return parser._parse(text.lower())


def test_label_basic():
    i = _parse("make a label that says hello world")
    assert i is not None
    assert i.object_class == "label"
    assert i.text_content == "hello world"


def test_nameplate_with_dimensions():
    i = _parse("make a nameplate reading John Smith 80mm wide 30mm tall")
    assert i.object_class == "nameplate"
    assert i.text_content == "john smith"
    assert i.width_mm == pytest.approx(80.0)
    assert i.height_mm == pytest.approx(30.0)


def test_tag_with_quotes():
    i = _parse('create a tag saying "Storage Box"')
    assert i.object_class == "tag"
    assert i.text_content == "Storage Box"


def test_box_shape():
    i = _parse("print a box 40mm by 30mm by 20mm")
    assert i.object_class == "box"
    assert i.width_mm == pytest.approx(40.0)
    assert i.height_mm == pytest.approx(30.0)
    assert i.depth_mm == pytest.approx(20.0)


def test_cm_conversion():
    i = _parse("make a label 6 cm wide")
    assert i.width_mm == pytest.approx(60.0)


def test_inch_conversion():
    i = _parse("make a nameplate 3 inches wide")
    assert i.width_mm == pytest.approx(76.2)


def test_unknown_returns_none():
    i = _parse("what is the weather today")
    assert i is None


def test_hook():
    i = _parse("print me a hook")
    assert i.object_class == "hook"


def test_text_in_double_quotes():
    i = _parse('label "FRAGILE"')
    assert i.object_class == "label"
    assert i.text_content == "FRAGILE"
