# Data Files

## Main Pipeline Data

- **[results.csv](results.csv)**: Correct experimental data
  - Response times in **milliseconds** (180-280 ms range)
  - Used by default `make` target

## Demonstration Data (Data Quality Errors)

### 1. Wrong Units (Data Capture Error)

- **[results_wrong_units.csv](results_wrong_units.csv)**: **WRONG UNITS**
  - Same numbers as results.csv, but in **seconds** instead of milliseconds (0.18-0.28 sec)
  - The pipeline will run successfully but produce nonsense results
  - Inspired by Mars Climate Orbiter failure (metric vs imperial units)
  - Demonstrates: Automation cannot detect wrong units

### 2. Blank Cell (Boundary Agreement Violation)

- **[results_blank_cell.csv](results_blank_cell.csv)**: Contains a blank cell in row 4
  - Violates implicit assumption: "all CSV cells must have values"
  - Python's `float()` will crash with a ValueError
  - Demonstrates: Implicit contracts between tools can break silently
  - Can be caught with validation: `python3 scripts/validate_data.py data/results_blank_cell.csv`

### 3. LaTeX Special Characters (Cross-Tool Boundary Violation)

- **[results_latex_special_chars.csv](results_latex_special_chars.csv)**: Condition names contain `%`
  - Valid CSV, valid Python, but **breaks LaTeX** (% is a comment character)
  - Demonstrates: Data valid in one tool can be toxic to another
  - Boundary agreement violated: "condition names must be LaTeX-safe"
  - Can be caught with validation: `python3 scripts/validate_data.py data/results_latex_special_chars.csv`

## Pedagogical Point

**Automation cannot detect data quality errors** like wrong units because:
- The CSV format is valid (syntax checking passes)
- The data types are correct (floats are floats)
- The pipeline has no way to know what units "should" be
- **Humans must establish and document measurement protocols**

This is an example of an error that requires:
1. Clear communication about assumptions (boundary agreements)
2. Human verification and validation
3. Domain knowledge that can't be automated
