# Environment for the COSI 106B toy_paper_pipeline in-class activity.
#
# Built and pushed to ghcr.io by .github/workflows/build-devcontainer-image.yml
# so that Codespaces only has to *pull* a finished image instead of running
# apt-get on every student's container. Startup is the pull, not the install.

FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ENV DEBIAN_FRONTEND=noninteractive

# make + python3 drive the pipeline; the texlive set covers exactly what the
# paper needs: graphicx, cite, standalone (plot.tex), pgfplots, and bibtex.
RUN apt-get update && apt-get install -y --no-install-recommends \
        make \
        openssh-server \
        python3 \
        python3-pip \
        texlive-latex-base \
        texlive-latex-recommended \
        texlive-latex-extra \
        texlive-pictures \
        texlive-fonts-recommended \
        texlive-bibtex-extra \
    && rm -rf /var/lib/apt/lists/*

# openssh-server above is what lets `gh codespace ssh` attach from a terminal.
# Students in the browser do not need it (the web terminal uses the VS Code
# server), but having it baked in means the container we test from the CLI is
# byte-identical to the one students get.

# Correctness-automation targets (make lint / make typecheck).
RUN pip3 install --break-system-packages --no-cache-dir ruff mypy

# Build-time smoke test: prove the whole pipeline actually runs in this image.
# If a texlive package is missing, the image build fails here rather than in
# front of a classroom.
COPY Makefile /tmp/smoke/Makefile
COPY data /tmp/smoke/data
COPY paper /tmp/smoke/paper
COPY scripts /tmp/smoke/scripts
RUN cd /tmp/smoke \
    && make \
    && test -s build/paper.pdf \
    && make lint \
    && make typecheck \
    && make validate \
    && make demo-bootstrapping \
    && test -s build/paper-incomplete.pdf \
    && rm -rf /tmp/smoke
