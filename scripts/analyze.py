#!/usr/bin/env python3
"""
Analyze experimental data and generate outputs for the paper.

This script:
1. Reads data/results.csv
2. Computes summary statistics
3. Generates analysis.txt with findings
4. Generates plot_data.dat for LaTeX to visualize

No external dependencies required - uses only Python standard library.
"""

import csv
from pathlib import Path

def main():
    # Read the data using standard library
    baseline_times = []
    treatment_times = []
    baseline_accuracy = []
    treatment_accuracy = []

    with open('data/results.csv', 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            rt = float(row['response_time_ms'])
            acc = int(row['accuracy'])

            if row['condition'] == 'baseline':
                baseline_times.append(rt)
                baseline_accuracy.append(acc)
            else:
                treatment_times.append(rt)
                treatment_accuracy.append(acc)

    # Compute statistics
    baseline_mean = sum(baseline_times) / len(baseline_times)
    treatment_mean = sum(treatment_times) / len(treatment_times)
    baseline_acc = sum(baseline_accuracy) / len(baseline_accuracy)
    treatment_acc = sum(treatment_accuracy) / len(treatment_accuracy)

    # Write analysis results
    Path('build').mkdir(exist_ok=True)
    with open('build/analysis.txt', 'w') as f:
        f.write("Experimental Analysis Results\n")
        f.write("=" * 40 + "\n\n")
        f.write(f"Baseline condition:\n")
        f.write(f"  Mean response time: {baseline_mean:.1f} ms\n")
        f.write(f"  Accuracy: {baseline_acc:.1%}\n\n")
        f.write(f"Treatment condition:\n")
        f.write(f"  Mean response time: {treatment_mean:.1f} ms\n")
        f.write(f"  Accuracy: {treatment_acc:.1%}\n\n")
        f.write(f"Difference: {baseline_mean - treatment_mean:.1f} ms faster in treatment\n")

    print(f"✓ Analysis complete: build/analysis.txt")

    # Write plot data for LaTeX to consume
    # This demonstrates Python as a preprocessor - it computes values,
    # then hands off to LaTeX for visualization
    Path('paper/figures').mkdir(parents=True, exist_ok=True)
    with open('paper/figures/plot_data.dat', 'w') as f:
        f.write("condition mean\n")
        f.write(f"Baseline {baseline_mean:.1f}\n")
        f.write(f"Treatment {treatment_mean:.1f}\n")

    print(f"✓ Plot data prepared: paper/figures/plot_data.dat")

if __name__ == '__main__':
    main()
