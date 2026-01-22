# Paper Pipeline Build System

PYTHON := python3
PDFLATEX := pdflatex
BIBTEX := bibtex

PAPER_DIR := paper
BUILD_DIR := build
DATA_DIR := data
SCRIPTS_DIR := scripts

.PHONY: all paper analysis clean

all: paper

paper: $(BUILD_DIR)/paper.pdf

analysis: $(BUILD_DIR)/analysis.txt $(PAPER_DIR)/figures/plot.pdf

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
