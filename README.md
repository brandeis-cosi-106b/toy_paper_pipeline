# Paper Pipeline: Build System Demonstration

A pedagogical build system that coordinates Python, LaTeX, and Make to produce a research paper from data.

**Purpose**: Instructor-led demonstration of coordination automation, correctness automation, and the limits of automation.

## For Instructors

**See [INSTRUCTOR_NOTES.md](INSTRUCTOR_NOTES.md)** for the complete walkthrough script, including:
- Narration for every command
- Pedagogical goals and learning outcomes
- Scaffolding for students with no Bash/Make experience
- Demonstrations of three types of automation
- Synthesis connecting to course themes

**Duration**: ~40 minutes (instructor-led, projected)

## For Students (Optional Exploration)

If you want to explore this repo on your own after the in-class demo:

### Setup

You'll need these installed:
- **make** - Build automation
- **python3** - Data processing (no extra packages needed)
- **LaTeX** - Document compilation (pdflatex, bibtex, pgfplots package)
- **ruff** - Python linter (optional): `pip install ruff`
- **mypy** - Python type checker (optional): `pip install mypy`

#### Installation Help

**macOS**:
- make: Should be pre-installed, or install with `xcode-select --install`
- LaTeX: **Two options**
  - **Option 1 - BasicTeX** (~100MB, minimal):
    1. Download and install [BasicTeX](https://www.tug.org/mactex/morepackages.html)
    2. Install required packages:
       ```bash
       sudo tlmgr update --self
       sudo tlmgr install pgfplots
       ```
  - **Option 2 - MacTeX** (~4GB, full distribution): Install [MacTeX](https://www.tug.org/mactex/)

**Linux**:
- make: `sudo apt install build-essential`
- LaTeX (~450-500MB, includes pgfplots):
  ```bash
  sudo apt install texlive-latex-extra texlive-fonts-recommended
  ```

**Windows**:
- Recommended: Use WSL (Windows Subsystem for Linux), then follow Linux instructions above
- Alternative: [MiKTeX](https://miktex.org/) for LaTeX (~200MB), MinGW for make

### Basic Usage

```bash
make        # Build the paper
make clean  # Remove all generated files
```

### Exploring the Three Types of Automation

#### 1. Coordination Automation (Make)
```bash
make                          # Initial build
make                          # Nothing to do
touch data/results.csv        # Mark data as changed
make                          # Rebuilds only what's needed
touch paper/sections/intro.tex
make                          # Rebuilds only paper, not analysis
```

#### 2. Correctness Automation (Linters & Type Checkers)
```bash
make lint                  # Lint main pipeline code
make lint-examples         # See intentional linter warnings
make typecheck             # Type-check main code
make typecheck-examples    # See intentional type errors
make check                 # Run both lint and typecheck
```

#### 3. Limits of Automation (What Can't Be Automated)
```bash
# Data quality validation
make validate                              # Validate correct data
python3 scripts/validate_data.py data/results_blank_cell.csv  # Blank cell error
python3 scripts/validate_data.py data/results_latex_special_chars.csv  # LaTeX special chars

# Bootstrapping problem
make demo-bootstrapping                    # Build with incomplete dependencies
touch paper/sections/intro.tex
make demo-bootstrapping                    # Says "nothing to do" - WRONG!
```

## Repository Structure

```
paper-pipeline/
├── Makefile                    # Build coordination
├── INSTRUCTOR_NOTES.md         # Complete walkthrough script
├── data/                       # Input data (including error examples)
│   ├── results.csv             # Correct data
│   ├── results_wrong_units.csv # Wrong units (Mars Climate Orbiter scenario)
│   ├── results_blank_cell.csv  # Boundary agreement violation
│   └── results_latex_special_chars.csv  # Cross-tool boundary violation
├── scripts/                    # Python analysis
│   ├── analyze.py              # Main pipeline script
│   ├── validate_data.py        # Optional validation
│   └── examples/               # Intentionally problematic code for demos
│       ├── linter_issues.py    # For `make lint-examples`
│       └── type_issues.py      # For `make typecheck-examples`
├── paper/                      # LaTeX source
│   ├── main.tex
│   ├── sections/
│   ├── figures/
│   └── references.bib
└── build/                      # Generated files (created by make)
```

## Learning Goals

This demonstration explores:

1. **Coordination automation**: How Make decides what to run and when
2. **Correctness automation**: What linters and type-checkers can/cannot verify
3. **Limits of automation**: Data quality, boundary agreements, bootstrapping
4. **Abstraction boundaries**: How tools communicate through files

## Key Concepts

### Coordination Decisions (Make automates these)
- What to rebuild when files change
- What order to run tools in
- When to skip work that's already done

### Correctness Decisions (Partially automatable)
- ✓ Syntax and style checking (rules we define)
- ✓ Type consistency (annotations we provide)
- ✗ Semantic correctness (requires domain knowledge)
- ✗ Data quality (requires assumptions we must specify)

### Design Decisions (Cannot automate)
- What counts as correct?
- What assumptions are safe?
- What dependencies exist?
- What boundary agreements make sense?

## Additional Resources

- **[INSTRUCTOR_NOTES.md](INSTRUCTOR_NOTES.md)**: Full walkthrough with narration and pedagogical notes
- **[REFERENCE.md](REFERENCE.md)**: Detailed technical exercises (from previous version)
- **[data/README.md](data/README.md)**: Explanation of error datasets
- **[scripts/examples/README.md](scripts/examples/README.md)**: What linters and type-checkers catch

## Troubleshooting

**"make: command not found"** → Install make (see setup above)

**"pdflatex: command not found"** → Install LaTeX distribution

**"pgfplots.sty not found"** (if using BasicTeX):
```bash
sudo tlmgr update --self
sudo tlmgr install pgfplots
```

**Build succeeds but no PDF?** → Check the `build/` directory

**"ruff: command not found"** → Install with `pip install ruff` (optional)

**"mypy: command not found"** → Install with `pip install mypy` (optional)

## Questions or Feedback?

This is a pedagogical tool designed for a CS course on abstraction and automation. If you have suggestions for improvements, feel free to open an issue or discuss with the instructor.
