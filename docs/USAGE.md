# Quantum_Error_Correction

MATLAB/Octave implementations of small quantum error-correction (QEC) codes and visualization scripts.
This repo is a learning project: encode logical states, simulate Pauli errors, measure stabilizer syndromes, correct, decode, and visualize.

## Structure

```
Quantum_Error_Correction/
├── docs/
├── src/       # Core functions for encoding, noise, correction, etc.
├── images/    # Generated pngs
├── examples/  # Scripts that run simulations and produce plots
└── tests/     # Unit tests
```

## Capabilities

- 3-qubit repetition bit-flip code
- 3-qubit repetition phase-flip code
- 9-qubit Shor code single-Pauli recovery
- 5-qubit perfect code single-Pauli recovery
- 7-qubit Steane code single-Pauli recovery
- Minimum-weight decoder for 1D repetition-code syndromes
- Projective stabilizer measurements for +/-1 Pauli observables
- Independent depolarizing-noise simulations
- Repeated noisy syndrome measurement simulations
- Small distance-3 surface-code prototype with a minimum-weight matching-style decoder
- Monte‑Carlo sweeps and confusion matrices
- Publication‑quality PNG outputs (saved to images/)

## Requirements

- [GNU Octave](https://www.gnu.org/software/octave/) (tested in GitHub Codespaces)  
  or MATLAB R2021b+ (if you have a MathWorks license).  
- Standard linear algebra and plotting functionality only.

## Quickstart (Codespace / dev container)

Prerequisites
- GNU Octave (or MATLAB R2021b+)
- Xvfb (for headless plotting)
- git

Install (Ubuntu)
```bash
sudo apt update
sudo apt install -y octave xvfb
```

Run an example (headless)
```bash
# from repo root
xvfb-run octave --eval "addpath('examples'); try; plot_confusion; catch; disp(lasterr); exit(1); end; exit(0);"
"$BROWSER" file:///workspaces/Quantum_Error_Correction/images/bitflip_decoder_confusion_matrix.png
```

Run tests
```bash
octave --no-gui tests/run_all_tests.m
```

Generate a compact simulation report
```bash
octave --no-gui examples/generate_simulation_report.m
```

Regenerate all figures
```bash
octave --no-gui examples/run_all_plots.m
```

## Usage

From the repo root in a terminal:

```bash
octave --no-gui examples/plot_logical_vs_p.m
```

Each script saves its figure in images/ as a .png.
For example, running the plotting scripts produces:
- images/bitflip_logical_error_vs_physical_error.png
- images/bitflip_syndrome_distribution.png
- images/bitflip_decoder_confusion_matrix.png
- images/bitflip_error_weight_distribution.png
- images/bitflip_monte_carlo_demo.png
- images/qec_recovery_failure_by_error_weight.png
- images/qec_depolarizing_logical_error_comparison.png
- images/bitflip_noisy_syndrome_rounds.png
- images/surface3_logical_error_vs_x_error.png

The generated report is written to docs/SIMULATION_REPORT.md.

## Tests

Unit tests are in tests/. Run with:

```
octave --no-gui tests/run_all_tests.m
```
