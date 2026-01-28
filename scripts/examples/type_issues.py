#!/usr/bin/env python3
"""
DEMONSTRATION FILE: Intentionally problematic code for type-checking demo.
This file is NOT part of the main pipeline.

Run `make typecheck-examples` to see what a type checker can catch.
"""


def add_numbers(a, b):
    """Missing type annotations - mypy will complain in strict mode."""
    return a + b


def process_value(x: int) -> str:
    """Type mismatch - returns int but declares str return type."""
    return x * 2  # Type error: returns int, not str


def inconsistent_return(flag: bool):
    """Missing return type annotation and inconsistent returns."""
    if flag:
        return "string"
    else:
        return 42  # Inconsistent: str vs int


def use_optional(value: int | None) -> int:
    """Using potentially None value without checking."""
    return value * 2  # Type error: value could be None
