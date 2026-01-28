# Example Files for Demonstration

These files are **NOT** part of the main pipeline. They exist purely to demonstrate what correctness automation tools can and cannot catch.

## Files

- **[linter_issues.py](linter_issues.py)**: Intentionally contains style issues that `ruff` can detect
  - Run `make lint-examples` to see linter warnings

- **[type_issues.py](type_issues.py)**: Intentionally contains type errors that `mypy` can detect
  - Run `make typecheck-examples` to see type-checking errors

## Pedagogical Purpose

These examples help illustrate:
1. **What automation CAN check**: Syntax, style, type consistency
2. **What automation CANNOT check**: Whether the logic is correct, whether assumptions are valid
3. **Humans decide what to check**: The Makefile explicitly lists which files to lint/typecheck
