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
- 3x3 Bacon-Shor subsystem-code Pauli-frame recovery
- Minimum-weight decoder for 1D repetition-code syndromes
- Projective stabilizer measurements for +/-1 Pauli observables
- Independent depolarizing-noise simulations
- Repeated noisy syndrome measurement simulations
- Small distance-3 surface-code prototype with X/Z/Pauli code-capacity sweeps and a minimum-weight matching-style decoder
- Monte‑Carlo sweeps and confusion matrices
- Publication‑quality PNG outputs (saved to images/)

## Requirements

- [GNU Octave](https://www.gnu.org/software/octave/) (tested in GitHub Codespaces)  
  or MATLAB R2021b+ (if you have a MathWorks license).  
- Standard linear algebra and plotting functionality only.

## Quickstart (Codespace / dev container)

Prerequisites
- GNU Octave (or MATLAB R2021b+)
- git

Install (Ubuntu)
```bash
sudo apt update
sudo apt install -y octave
```

Run an example
```bash
# from repo root
octave --no-gui examples/plot_confusion.m
"$BROWSER" file:///workspaces/Quantum_Error_Correction/images/bitflip_decoder_confusion_matrix.png
```

Run a minimal text example
```bash
octave --no-gui examples/minimal_bitflip_recovery.m
```

Run the longer surface-code walkthrough
```bash
octave --no-gui examples/surface3_walkthrough.m
```

Run all text examples
```bash
octave --no-gui examples/run_text_examples.m
```

Run the full local validation set
```bash
octave --no-gui tests/run_all_tests.m
octave --no-gui examples/run_text_examples.m
octave --no-gui examples/generate_simulation_report.m
octave --no-gui examples/check_generated_images.m
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

Short text examples:
- `examples/minimal_bitflip_recovery.m`
- `examples/minimal_phaseflip_recovery.m`
- `examples/minimal_fivequbit_recovery.m`
- `examples/minimal_steane_recovery.m`
- `examples/minimal_shor_recovery.m`
- `examples/minimal_bacon_shor_recovery.m`
- `examples/minimal_repetition_decoder.m`
- `examples/minimal_surface3_syndrome.m`

Longer walkthrough:
- `examples/surface3_walkthrough.m`

Example runners:
- `examples/run_text_examples.m`
- `examples/check_generated_images.m`

Surface-3 Monte Carlo plots cache sweep data under `cache/`. Delete that directory or set `force_cache = true` before running a plot script to force regeneration.

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
- images/surface3_channel_logical_error_comparison.png
- images/surface3_noisy_syndrome_rounds.png

The generated report is written to docs/SIMULATION_REPORT.md.

## Tests

Unit tests are in tests/. Run with:

```
octave --no-gui tests/run_all_tests.m
```

---

## Citation

If you use this repository in a project, cite it as:

Sid Richards (2026). `Quantum_Error_Correction`: MATLAB/Octave implementations of quantum error-correction codes and simulations.

## Author

Sid Richards

- LinkedIn: [sid-richards-21374b30b](https://www.linkedin.com/in/sid-richards-21374b30b/)
- GitHub: [SidRichardsQuantum](https://github.com/SidRichardsQuantum)

## License

MIT. See [LICENSE](LICENSE).
