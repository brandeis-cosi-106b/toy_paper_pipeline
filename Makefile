# Paper Pipeline Build System

PYTHON := python3
PDFLATEX := pdflatex
BIBTEX := bibtex

PAPER_DIR := paper
BUILD_DIR := build
DATA_DIR := data
SCRIPTS_DIR := scripts

# Define which Python files are part of the pipeline vs examples
PIPELINE_PYTHON := $(SCRIPTS_DIR)/analyze.py
EXAMPLE_PYTHON := $(SCRIPTS_DIR)/examples/linter_issues.py $(SCRIPTS_DIR)/examples/type_issues.py

.PHONY: all paper analysis clean lint lint-examples typecheck typecheck-examples check check-examples validate demo-bootstrapping

all: paper

paper: $(BUILD_DIR)/paper.pdf

analysis: $(BUILD_DIR)/analysis.txt $(PAPER_DIR)/figures/plot.pdf

# Correctness automation targets
lint:
	@echo "Running linter on pipeline code: $(PIPELINE_PYTHON)"
	@ruff check $(PIPELINE_PYTHON) && echo "✓ No linter issues found" || echo "⚠ Linter found issues"

lint-examples:
	@echo "Running linter on example files (intentionally problematic):"
	@echo "  $(EXAMPLE_PYTHON)"
	@ruff check $(EXAMPLE_PYTHON) || echo "⚠ Linter found issues (expected)"

typecheck:
	@echo "Running type checker on pipeline code: $(PIPELINE_PYTHON)"
	@mypy --strict $(PIPELINE_PYTHON) && echo "✓ No type issues found" || echo "⚠ Type checker found issues"

typecheck-examples:
	@echo "Running type checker on example files (intentionally problematic):"
	@for file in $(EXAMPLE_PYTHON); do echo "  $$file"; mypy --strict $$file || true; done

check: lint typecheck
	@echo "✓ Main pipeline checks complete"

check-examples: lint-examples typecheck-examples
	@echo "✓ Example checks complete (errors expected)"

# Data validation (demonstrates boundary agreement checking)
validate:
	@echo "Validating data files..."
	@$(PYTHON) $(SCRIPTS_DIR)/validate_data.py $(DATA_DIR)/results.csv

# Bootstrapping problem demonstration
# This target intentionally has INCOMPLETE dependencies to show that Make
# cannot know what's missing unless humans explicitly declare it.
#
# Try this experiment:
#   1. make clean
#   2. make demo-bootstrapping
#   3. touch data/results.csv
#   4. make demo-bootstrapping  (Will say "nothing to be done" - WRONG!)
#
# The problem: This target doesn't list data/results.csv as a dependency,
# so Make doesn't know to rebuild when data changes.
#
# This is the BOOTSTRAPPING PROBLEM: Make cannot infer dependencies.
# Humans must correctly specify them.
$(BUILD_DIR)/paper-incomplete.pdf: $(PAPER_DIR)/main.tex $(PAPER_DIR)/figures/plot.pdf
	@echo "Building paper with INCOMPLETE dependency tracking..."
	@echo "(This intentionally omits sections/*.tex and references.bib)"
	@mkdir -p $(BUILD_DIR)
	@cd $(PAPER_DIR) && $(PDFLATEX) -interaction=nonstopmode -output-directory=../$(BUILD_DIR) main.tex > /dev/null
	@cp $(PAPER_DIR)/references.bib $(BUILD_DIR)/
	@cd $(BUILD_DIR) && $(BIBTEX) main > /dev/null
	@cd $(PAPER_DIR) && $(PDFLATEX) -interaction=nonstopmode -output-directory=../$(BUILD_DIR) main.tex > /dev/null
	@cd $(PAPER_DIR) && $(PDFLATEX) -interaction=nonstopmode -output-directory=../$(BUILD_DIR) main.tex > /dev/null
	@cp $(BUILD_DIR)/main.pdf $(BUILD_DIR)/paper-incomplete.pdf
	@echo "✓ Built: $(BUILD_DIR)/paper-incomplete.pdf"
	@echo ""
	@echo "⚠️  This target has incomplete dependencies!"
	@echo "Try: touch paper/sections/intro.tex && make demo-bootstrapping"
	@echo "Make will say 'nothing to be done' even though intro.tex changed."

demo-bootstrapping: $(BUILD_DIR)/paper-incomplete.pdf

clean:
	@echo "Cleaning build artifacts..."
	rm -rf $(BUILD_DIR)
	rm -f $(PAPER_DIR)/*.aux $(PAPER_DIR)/*.log $(PAPER_DIR)/*.bbl $(PAPER_DIR)/*.blg $(PAPER_DIR)/*.out
	rm -f $(PAPER_DIR)/figures/plot.pdf $(PAPER_DIR)/figures/plot.aux $(PAPER_DIR)/figures/plot.log
	rm -f $(PAPER_DIR)/figures/plot_data.dat
	@echo "Clean complete."

$(BUILD_DIR)/analysis.txt $(PAPER_DIR)/figures/plot_data.dat: $(DATA_DIR)/results.csv $(SCRIPTS_DIR)/analyze.py
	@echo "Running analysis..."
	$(PYTHON) $(SCRIPTS_DIR)/analyze.py

$(PAPER_DIR)/figures/plot.pdf: $(PAPER_DIR)/figures/plot.tex $(PAPER_DIR)/figures/plot_data.dat
	@echo "Generating figure..."
	cd $(PAPER_DIR)/figures && $(PDFLATEX) -interaction=nonstopmode plot.tex > /dev/null
	@echo "✓ Figure generated: $(PAPER_DIR)/figures/plot.pdf"

$(BUILD_DIR)/paper.pdf: $(PAPER_DIR)/main.tex \
                        $(PAPER_DIR)/sections/intro.tex \
                        $(PAPER_DIR)/sections/discussion.tex \
                        $(PAPER_DIR)/references.bib \
                        $(PAPER_DIR)/figures/plot.pdf
	@echo "Compiling paper (this takes multiple passes)..."
	@mkdir -p $(BUILD_DIR)
	@echo "  [1/4] First pdflatex pass..."
	cd $(PAPER_DIR) && $(PDFLATEX) -interaction=nonstopmode -output-directory=../$(BUILD_DIR) main.tex > /dev/null
	@cp $(PAPER_DIR)/references.bib $(BUILD_DIR)/
	@echo "  [2/4] Running bibtex..."
	cd $(BUILD_DIR) && $(BIBTEX) main > /dev/null
	@echo "  [3/4] Second pdflatex pass..."
	cd $(PAPER_DIR) && $(PDFLATEX) -interaction=nonstopmode -output-directory=../$(BUILD_DIR) main.tex > /dev/null
	@echo "  [4/4] Final pdflatex pass..."
	cd $(PAPER_DIR) && $(PDFLATEX) -interaction=nonstopmode -output-directory=../$(BUILD_DIR) main.tex > /dev/null
	@cp $(BUILD_DIR)/main.pdf $(BUILD_DIR)/paper.pdf
	@echo "✓ Paper built successfully: $(BUILD_DIR)/paper.pdf"
