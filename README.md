# Paper Pipeline

A build system that coordinates multiple tools to produce a research paper from data.

## Setup

You'll need these installed:
- **make** - Build automation
- **python3** - Data processing (no extra packages needed)
- **LaTeX** - Document compilation (pdflatex, bibtex, pgfplots package)

### Installation Help

**macOS**:
- make: Should be pre-installed, or install with `xcode-select --install`
- LaTeX: **Two options**
  - **Option 1 - BasicTeX** (~100MB, faster):
    1. Download and install [BasicTeX](https://www.tug.org/mactex/morepackages.html)
    2. Install required packages:
       ```bash
       sudo tlmgr update --self
       sudo tlmgr install pgfplots
       ```
  - **Option 2 - MacTeX** (~4GB, includes everything): Install [MacTeX](https://www.tug.org/mactex/)

**Linux**:
- make: `sudo apt install build-essential`
- LaTeX: `sudo apt install texlive-latex-extra texlive-fonts-recommended`
  - Note: `texlive-latex-extra` includes pgfplots

**Windows**:
- Recommended: Use WSL (Windows Subsystem for Linux), then follow Linux instructions
- Alternative: [MiKTeX](https://miktex.org/) for LaTeX, MinGW for make

**Note**: If you can't get LaTeX installed, partner with someone who has it working. Observing the build process is still valuable.

## Usage

```bash
make        # Build the paper
make clean  # Remove all generated files
```

## What to Explore

See [EXPLORATION.md](EXPLORATION.md) for the investigation worksheet.

The goal is to understand:
- How Make coordinates different tools
- What gets rebuilt when files change
- How tools communicate through files
- Why build systems exist

## Structure

```
paper-pipeline/
├── Makefile           # Build system
├── data/              # Input data
├── scripts/           # Python analysis
├── paper/             # LaTeX source
└── build/             # Generated files (created by make)
```

## Troubleshooting

**"make: command not found"** → Install make (see setup above)

**"pdflatex: command not found"** → Install LaTeX distribution

**"pgfplots.sty not found"** (if using BasicTeX):
```bash
sudo tlmgr update --self
sudo tlmgr install pgfplots
```

**Build succeeds but no PDF?** → Check the `build/` directory

**tlmgr: command not found** → Make sure LaTeX bin directory is in your PATH:
```bash
export PATH="/Library/TeX/texbin:$PATH"
```

**Other errors?** → Read the error message carefully - it tells you what's missing or what failed
