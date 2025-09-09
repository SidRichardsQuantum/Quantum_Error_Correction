# Quantum_Error_Correction

MATLAB/Octave implementation of simple quantum error correction codes, starting from the 3-qubit repetition (bit-flip) code.
This repo is intended as a learning project: build the codebase step by step, simulate noise and correction, and visualize results.

## Structure

```
Quantum_Error_Correction/
├── docs/
├── src/       # Core functions for encoding, noise, correction, etc.
├── images/    # Generated pngs
├── examples/  # Scripts that run simulations and produce plots
└── tests/     # Unit tests
```

### Capabilities

- Encode and decode the 3-qubit repetition (bit-flip) code.
- Simulate independent bit-flip noise on each qubit.
- Measure stabilizer syndromes and apply correction.
- Run Monte Carlo sweeps to estimate logical error rate.
- Generate visualizations:
  - Logical error probability vs physical error probability.
  - Syndrome frequency histograms.
  - Confusion matrix of true vs inferred errors.
  - Distribution of error weights (0,1,2,3 flips).

## Requirements

- [GNU Octave](https://www.gnu.org/software/octave/) (tested in GitHub Codespaces)  
  or MATLAB R2021b+ (if you have a MathWorks license).  
- Standard linear algebra and plotting functionality only.

## Usage

From the repo root in a terminal:

```bash
octave --no-gui examples/plot_logical_vs_p.m
```

Each script saves its figure in docs/ as a .png.
For example, running all four example scripts produces:
- docs/plot_logical_vs_p.png
- docs/plot_syndrome_hist.png
- docs/plot_confusion.png
- docs/plot_error_weight.png

## Tests

Basic unit tests are in tests/test_bitflip.m. Run with:

```
octave --no-gui --eval "runtests('tests')"
```

---

📘 Author: Sid Richards (SidRichardsQuantum)

<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/linkedin/linkedin-original.svg" width="20" /> LinkedIn: https://www.linkedin.com/in/sid-richards-21374b30b/

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
