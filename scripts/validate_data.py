#!/usr/bin/env python3
"""
Optional data validation script - demonstrates partial boundary checking.

This script can catch SOME data quality issues, but:
- Humans must decide what to validate
- Not all problems can be automatically detected
- Validation rules are based on assumptions that must be documented

Run: python3 scripts/validate_data.py data/results.csv
"""

import csv
import sys
from pathlib import Path


def validate_data(filepath: str) -> list[str]:
    """
    Validate CSV data against expected format and constraints.

    Returns list of validation errors (empty if valid).
    """
    errors = []

    if not Path(filepath).exists():
        return [f"File not found: {filepath}"]

    with open(filepath, 'r') as f:
        reader = csv.DictReader(f)

        # Check header
        expected_cols = {'trial', 'condition', 'response_time_ms', 'accuracy'}
        if reader.fieldnames:
            actual_cols = set(reader.fieldnames)
            if actual_cols != expected_cols:
                errors.append(f"Wrong columns: expected {expected_cols}, got {actual_cols}")

        # Check each row
        for row_num, row in enumerate(reader, start=2):  # start=2 because row 1 is header
            # Check for blank cells
            for col, value in row.items():
                if not value or value.strip() == '':
                    errors.append(f"Row {row_num}: Blank cell in column '{col}'")

            # Check for LaTeX special characters in condition names
            # (demonstrates boundary agreement between Python and LaTeX)
            latex_special = ['%', '$', '_', '&', '#', '{', '}', '^', '~', '\\']
            condition = row.get('condition', '')
            for char in latex_special:
                if char in condition:
                    errors.append(
                        f"Row {row_num}: LaTeX special character '{char}' in condition '{condition}' "
                        f"(will break LaTeX compilation)"
                    )

            # Check data types and ranges
            try:
                rt = float(row['response_time_ms'])
                # Sanity check: response times should be in milliseconds (reasonable range: 50-5000ms)
                if rt < 50 or rt > 5000:
                    errors.append(
                        f"Row {row_num}: Suspicious response time {rt}ms "
                        f"(too {'small' if rt < 50 else 'large'} - wrong units?)"
                    )
            except (ValueError, KeyError):
                errors.append(f"Row {row_num}: Invalid response_time_ms value")

            try:
                acc = int(row['accuracy'])
                if acc not in (0, 1):
                    errors.append(f"Row {row_num}: Accuracy must be 0 or 1, got {acc}")
            except (ValueError, KeyError):
                errors.append(f"Row {row_num}: Invalid accuracy value")

    return errors


def main():
    if len(sys.argv) != 2:
        print("Usage: python3 scripts/validate_data.py <data_file.csv>")
        sys.exit(1)

    filepath = sys.argv[1]
    print(f"Validating: {filepath}")
    print("=" * 60)

    errors = validate_data(filepath)

    if errors:
        print(f"\n❌ Found {len(errors)} validation error(s):\n")
        for error in errors:
            print(f"  • {error}")
        print("\n" + "=" * 60)
        print("Validation FAILED")
        sys.exit(1)
    else:
        print("✓ All checks passed")
        print("=" * 60)
        print("Validation SUCCEEDED")
        print("\nNote: This validates format and basic sanity checks,")
        print("but cannot verify if the data is scientifically meaningful.")
        sys.exit(0)


if __name__ == '__main__':
    main()
