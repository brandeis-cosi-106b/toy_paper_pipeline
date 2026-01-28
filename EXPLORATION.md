# Paper Pipeline: Exploration Worksheet

**Name**: ______________________

**Instructions**: Work through the investigations below, taking brief notes as you go. Use the **Predict → Run → Explain** pattern: before running each command, predict what will happen, then explain what actually happened and why.

---

## Part 1: Coordination Automation

### Investigation 1.1: First Build

**Before running anything**, look at the repository structure:
```bash
ls -R
```

**List what you see**:
- Directories:
- Key files:

**Predict**: What will appear in a `build/` directory after running `make`?
```

```

**Now run the build**:
```bash
make
```

**What happened?** (Note any stages you see)
```

```

**Check what was created**:
```bash
ls build/
```

**What new files appeared?**
```

```

---

### Investigation 1.2: The Rebuild Puzzle

**Run `make` again** (without changing anything):
```bash
make
```

**What happened?**
```

```

**Hypothesis**: Why didn't it rebuild everything?
```

```

---

### Investigation 1.3: Selective Rebuilds

**Experiment A** - Change the data file timestamp:
```bash
touch data/results.csv
make
```

**What rebuilt?** (check all that apply)
- [ ] Python script ran
- [ ] Figure regenerated
- [ ] Paper recompiled
- [ ] Nothing

**Experiment B** - Change a paper section timestamp:
```bash
touch paper/sections/intro.tex
make
```

**What rebuilt this time?**
- [ ] Python script ran
- [ ] Figure regenerated
- [ ] Paper recompiled
- [ ] Nothing

**Explain the difference**:
```

```

**Draw the dependency chain** (fill in the blanks):
```
data/results.csv → __________ → __________ → build/paper.pdf
                                     ↑
paper/sections/intro.tex ────────────┘
```

---

### Investigation 1.4: Multi-Pass Mystery

Look at the build output. You should see:
```
[1/4] First pdflatex pass...
[2/4] Running bibtex...
[3/4] Second pdflatex pass...
[4/4] Final pdflatex pass...
```

**Question**: Why does pdflatex run 3 times instead of just once?

**Your theory**:
```

```

**Hint**: Think about citations and cross-references. What problem might they create?

---

### Investigation 1.5: How Tools Communicate

Look at these intermediate files:
```bash
cat paper/figures/plot_data.dat
cat build/analysis.txt
```

**Questions**:
1. Which tool created `plot_data.dat`? _______________
2. Which tool uses it? _______________
3. How do Python and LaTeX "talk" to each other?
```

```

---

## Part 2: Correctness Automation

### Investigation 2.1: Linting

A **linter** checks code for style issues, common bugs, and code smells.

**Run the linter on the main pipeline code**:
```bash
make lint
```

**What happened?**
```

```

**Now run the linter on intentionally problematic code**:
```bash
make lint-examples
```

**List 3 issues the linter found**:
1.
2.
3.

**Key question**: Would the problematic code still run? _______________

**What does this tell you about what linters check?**
```

```

---

### Investigation 2.2: Type Checking

A **type checker** verifies that data types are used consistently.

**Run the type checker on main code**:
```bash
make typecheck
```

**What happened?**
```

```

**Run the type checker on intentionally problematic code**:
```bash
make typecheck-examples
```

**List 2 type errors found**:
1.
2.

**What kinds of bugs can type checking catch BEFORE runtime?**
```

```

---

### Investigation 2.3: Limits of Correctness Tools

**Think about it**: What can linters and type-checkers NOT check?

List 3 things these tools cannot verify:
1.
2.
3.

---

## Part 3: Limits of Automation

### Investigation 3.1: Data Quality Errors

In 1999, NASA lost the $125 million Mars Climate Orbiter because one team used metric units and another used imperial units. Both systems ran successfully—but produced wrong results.

**Compare these two files**:
```bash
head data/results.csv
head data/results_wrong_units.csv
```

**What's different?**
```

```

**If we ran the pipeline with `results_wrong_units.csv`**:
- Would Python crash? _______________
- Would LaTeX compile? _______________
- Would the PDF generate? _______________
- Would the results be correct? _______________

**Why can't automation catch this error?**
```

```

---

### Investigation 3.2: Boundary Agreements

Tools communicate through files, but they make **implicit assumptions** about file contents. These are called **boundary agreements**.

**Test the validation script on correct data**:
```bash
make validate
```

**What happened?**
```

```

**Now test data with a blank cell**:
```bash
python3 scripts/validate_data.py data/results_blank_cell.csv
```

**What error was found?**
```

```

**What implicit assumption was violated?**
```

```

**Test data with LaTeX special characters**:
```bash
python3 scripts/validate_data.py data/results_latex_special_chars.csv
```

**What's the problem?**
```

```

**Key insight**: The validation script catches these errors, but who decided what to validate?
```

```

---

### Investigation 3.3: The Bootstrapping Problem

**Reset and build with an intentionally incomplete Makefile target**:
```bash
make clean
make demo-bootstrapping
```

**Did it build successfully?** _______________

**Now change a section file and rebuild**:
```bash
touch paper/sections/intro.tex
make demo-bootstrapping
```

**What did Make say?**
```

```

**But wait** - we just changed `intro.tex`! Why didn't it rebuild?

**Look at the Makefile** (search for `paper-incomplete.pdf`). What dependencies are listed?
```

```

**What dependencies are MISSING?**
```

```

**This is the bootstrapping problem**: Make cannot know dependencies unless...
```

```

---

## Part 4: Synthesis

### Summary Questions

#### 1. What problem does Make solve?
```

```

#### 2. How does Make decide what to rebuild?
```

```

#### 3. Give an example of something a linter CAN check vs something it CANNOT check.

**Can check**:
```

```

**Cannot check**:
```

```

#### 4. What is a "boundary agreement" between tools?
```

```

#### 5. What is the "bootstrapping problem"?
```

```

#### 6. What must humans decide BEFORE automation can help?
```

```

---

### Key Vocabulary

Define each term in your own words:

| Term | Your Definition |
|------|-----------------|
| Coordination automation | |
| Correctness automation | |
| Boundary agreement | |
| Bootstrapping problem | |

---

## Optional Challenges

If you finish early or want to explore more:

**Challenge A**: Open the Makefile and find where the dependencies for `paper.pdf` are listed. Compare it to `paper-incomplete.pdf`. What's different?

**Challenge B**: Add a new row to `data/results.csv` with a response time of `5` (clearly wrong units). Run `make validate`. Does it catch the problem?

**Challenge C**: Try to make the linter happy by fixing the issues in `scripts/examples/linter_issues.py`. Run `make lint-examples` to verify.

**Challenge D**: What would happen if you ran the pipeline with `data/results_latex_special_chars.csv`? (Hint: you can try by temporarily copying it over `results.csv`)

---

## Command Reference

| Command | What it does |
|---------|--------------|
| `ls -R` | List all files recursively |
| `make` | Build the paper |
| `make clean` | Remove all generated files |
| `touch <file>` | Update file's timestamp |
| `make lint` | Check main code style |
| `make lint-examples` | Check example code (has issues) |
| `make typecheck` | Type-check main code |
| `make typecheck-examples` | Type-check examples (has issues) |
| `make validate` | Validate data file format |
| `make demo-bootstrapping` | Demo incomplete dependencies |
