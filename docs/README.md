# Quantum_Error_Correction

MATLAB/Octave implementations of simple quantum error‑correction (QEC) codes and visualization scripts.
This repo is a learning / demo project: encode, simulate noise, decode, and visualize.

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

- 3‑qubit repetition (bit‑flip) code simulations
- Simple multi‑code experiments (repetition, Shor-style prototypes)
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
"$BROWSER" file:///workspaces/Quantum_Error_Correction/images/plot_confusion.png
```

Run tests
```bash
octave --no-gui --eval "runtests('tests')"
```

## Usage

From the repo root in a terminal:

```bash
octave --no-gui examples/plot_logical_vs_p.m
```

Each script saves its figure in images/ as a .png.
For example, running all four example scripts produces:
- images/plot_logical_vs_p.png
- images/plot_syndrome_hist.png
- images/plot_confusion.png
- images/plot_error_weight.png

## Tests

Basic unit tests are in tests/test_bitflip.m. Run with:

```
octave --no-gui --eval "runtests('tests')"
```

---

📘 Author: Sid Richards (SidRichardsQuantum)

<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/linkedin/linkedin-original.svg" width="20" /> LinkedIn: https://www.linkedin.com/in/sid-richards-21374b30b/

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
