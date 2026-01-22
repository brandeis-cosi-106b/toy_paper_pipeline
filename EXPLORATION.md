# Paper Pipeline: Exploration Notes

**Name**: ______________________

**Instructions**: Work through the investigations below, taking brief notes as you go. At the end, you'll submit a short summary via Google Form for attendance.

---

## Investigation 1: First Build

Run these commands and observe what happens:
```bash
ls -R
make
ls build/
```

**Quick notes** (what happened? any errors?):
```


```

**Key observation**: What new files/directories appeared after `make`?
```

```

---

## Investigation 2: The Rebuild Puzzle

Run `make` again (without changing anything):
```bash
make
```

**What happened?**
```

```

Now run it twice more and observe:
```bash
make
make
```

**Pattern you noticed**:
```

```

---

## Investigation 3: Testing Rebuilds

Try this experiment:
```bash
make clean && make      # Full build
touch data/results.csv  # Change timestamp on data file
make                    # What rebuilds?
```

**What rebuilt?** (check all that apply)
- [ ] Python script ran
- [ ] Figure regenerated
- [ ] Paper recompiled
- [ ] Nothing happened

**Try another experiment**:
```bash
make clean && make
touch paper/sections/intro.tex
make
```

**What rebuilt this time?**
- [ ] Python script ran
- [ ] Figure regenerated
- [ ] Paper recompiled
- [ ] Nothing happened

**Your hypothesis**: How does Make decide what to rebuild?
```


```

---

## Investigation 4: Dependency Chain

Draw a simple diagram showing what depends on what:

```
data/results.csv → __________ → __________ → __________ → build/paper.pdf
```

Hint: Look at what rebuilt in Investigation 3.

---

## Investigation 5: Intermediate Files

After a successful build, look at what's in `build/`:
```bash
ls -lh build/
```

**List 3-4 files you see** (besides paper.pdf):
```


```

**Pick one mysterious file**. What do you think it's for?

File: __________________
Purpose guess:
```

```

---

## Investigation 6: Multi-Pass Mystery

Look at the output from `make`. You should see:
```
[1/4] First pdflatex pass...
[2/4] Running bibtex...
[3/4] Second pdflatex pass...
[4/4] Final pdflatex pass...
```

**Question**: Why does pdflatex run 3 times instead of just once?

Your theory:
```


```

Evidence (look at files in build/, or think about citations):
```

```

---

## Investigation 7: Tool Communication

Look at these two files:
```bash
cat paper/figures/plot_data.dat
cat build/analysis.txt
```

**Questions**:
1. Which tool created `plot_data.dat`? _______________
2. Which tool uses it? _______________
3. How do Python and LaTeX communicate?
```

```

---

## Investigation 8: Reading the Makefile

Open `Makefile` and find the line that starts with:
```make
$(BUILD_DIR)/paper.pdf:
```

**What files does paper.pdf depend on?** (Look after the `:`)
```


```

**What does Make actually know?**
- [ ] What pdflatex does internally
- [ ] What Python does internally
- [ ] Which files depend on which other files
- [ ] Why citations need multiple passes

---

## Summary Questions (Submit These to Google Form)

Answer briefly (1-2 sentences each):

### 1. What problem does Make solve?
```


```

### 2. How does Make decide what to rebuild?
```


```

### 3. Name one thing you found surprising or interesting:
```


```

### 4. Installation experience (optional)
Did you have trouble installing any tools? Which ones? Did you partner with someone?
```


```

---

## Submit Your Responses

Copy your answers to **Summary Questions (1-4)** into the Google Form:

**→ [Attendance Form](https://docs.google.com/forms/d/e/1FAIpQLSeoRSIy132DE0ApunYFslCZPI4WD9mJEN5G_XlyJ7O-7PBxhQ/viewform)**

You can keep this worksheet for your own reference.

---

## Optional Challenges (If You Finish Early)

**Challenge A**: Comment out one line in the Makefile (add `#` at the start). What breaks?

**Challenge B**: Add more data to `data/results.csv`. What changes in the final paper?

**Challenge C**: Find a way to force Make to rebuild everything even though nothing changed.
