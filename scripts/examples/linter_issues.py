#!/usr/bin/env python3
"""
DEMONSTRATION FILE: Intentionally problematic code for linter demo.
This file is NOT part of the main pipeline.

Run `make lint-examples` to see what a linter can catch.
"""

import os
import sys
import json  # F401: unused import


def process_data(x):
    """Process some data."""
    # E741: Variable names that are too short
    a = x * 2
    b = a + 5
    c = b / 3

    # F841: Unused variable
    unused_result = c ** 2

    return c


def another_function(data, flag):
    """Another problematic function."""
    # E712: Comparison to True should be simplified
    if flag == True:
        result = data
    else:
        result = None

    # E501: Line too long (will exceed typical 88-100 char limits)
    very_long_string = "This is an extremely long string that clearly extends well beyond any reasonable line length limits and would trigger linting warnings"

    return result
