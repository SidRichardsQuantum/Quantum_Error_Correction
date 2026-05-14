# Quantum Error Correction

[![Octave Tests](https://github.com/SidRichardsQuantum/Quantum_Error_Correction/actions/workflows/octave-tests.yml/badge.svg)](https://github.com/SidRichardsQuantum/Quantum_Error_Correction/actions/workflows/octave-tests.yml)
[![GitHub Pages](https://github.com/SidRichardsQuantum/Quantum_Error_Correction/actions/workflows/pages.yml/badge.svg)](https://github.com/SidRichardsQuantum/Quantum_Error_Correction/actions/workflows/pages.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![GNU Octave](https://img.shields.io/badge/GNU%20Octave-compatible-0790C0)](https://www.gnu.org/software/octave/)

Small MATLAB/Octave implementations of quantum error-correction codes, syndrome decoders, and Monte Carlo simulations.

Website: [sidrichardsquantum.github.io/Quantum_Error_Correction](https://sidrichardsquantum.github.io/Quantum_Error_Correction/)

This repository is educational and code-oriented: it uses pure state vectors, Pauli errors, stabilizer measurements, and focused scripts that generate figures under `images/`.

Package archives are built as Octave `.tar.gz` packages. Local builds write to
`dist/`; public release archives should be attached to
[GitHub Releases](https://github.com/SidRichardsQuantum/Quantum_Error_Correction/releases).

## Implemented Codes

| Code or decoder | Physical qubits | What is implemented |
| --- | ---: | --- |
| 3-qubit bit-flip repetition | 3 | Encode, syndrome, correction, Monte Carlo logical error |
| 3-qubit phase-flip repetition | 3 | Encode, X-parity syndrome, Z correction |
| [[4,2,2]] error-detecting code | 4 | Two-logical-qubit encoding, stabilizer syndrome, single-qubit Pauli detection |
| 5-qubit perfect code | 5 | Stabilizer encoding and single-qubit Pauli recovery |
| 7-qubit Steane code | 7 | CSS stabilizer syndrome and single-qubit Pauli recovery |
| 7-qubit triangular color code | 7 | Color-code-facing CSS stabilizer recovery for the smallest triangular code |
| 9-qubit Shor code | 9 | Bit/phase syndrome and single-qubit Pauli recovery |
| 3x3 Bacon-Shor subsystem code | 9 | Pauli-frame row/column syndrome decoder and logical residual check |
| 1D repetition decoder | variable | Minimum-weight syndrome decoder |
| Surface-3 prototype | 9 data qubits + 8 ancillas | X/Z/Pauli code-capacity model, noisy syndrome rounds with detector history, circuit-level schedule prototype, cached minimum-weight lookup |
| Generic surface-layout decoder | odd d | Variable-distance square layout, plaquette syndromes, cached small-pattern lookup, MWPM-style matching baseline, bounded graph-search baseline, peeling fallback, and configurable d=3/5/7 benchmark scripts |

## Quickstart

Install Octave, then load the checkout paths:

```bash
octave --no-gui --eval "qec_setup; qec_about"
```

Run the tests:

```bash
octave --no-gui tests/run_all_tests.m
```

Or use the package archive workflow:

```bash
make package
octave --no-gui --eval "pkg install dist/qec-0.3.0.tar.gz"
octave --no-gui --eval "pkg load qec; qec_about"
```

Published package archives, when available, are listed on
[GitHub Releases](https://github.com/SidRichardsQuantum/Quantum_Error_Correction/releases).

Run an example:

```bash
octave --no-gui examples/plot_logical_vs_p.m
```

Run a minimal recovery example:

```bash
octave --no-gui examples/minimal_bitflip_recovery.m
```

Run a minimal error-detection example:

```bash
octave --no-gui examples/minimal_four_two_two_detection.m
```

Run a Bacon-Shor Pauli-frame recovery example:

```bash
octave --no-gui examples/minimal_bacon_shor_recovery.m
```

Run a triangular color-code recovery example:

```bash
octave --no-gui examples/minimal_color7_recovery.m
```

Run a variable-distance surface-layout decoder example:

```bash
octave --no-gui examples/minimal_surface_distance_decoder.m
```

Run the surface-layout distance benchmark:

```bash
octave --no-gui examples/benchmark_surface_distance_decoder.m
octave --no-gui examples/plot_surface_distance_scaling.m
```

Override surface-layout benchmark settings:

```bash
octave --no-gui examples/benchmark_surface_distance_decoder.m -- --trials=200 --seed=7 --ps="0 0.02 0.04" --distances="3 5" --decoders=min_weight,mwpm,graph_matching
```

Run a longer surface-code walkthrough:

```bash
octave --no-gui examples/surface3_walkthrough.m
```

Run the circuit-level surface-3 schedule example:

```bash
octave --no-gui examples/minimal_surface3_circuit_level.m
```

Run all text examples:

```bash
octave --no-gui examples/run_text_examples.m
```

Run the full local validation set:

```bash
octave --no-gui tests/run_all_tests.m
octave --no-gui examples/run_text_examples.m
octave --no-gui examples/generate_simulation_report.m
octave --no-gui examples/check_generated_images.m
```

Generate the simulation summary:

```bash
octave --no-gui examples/generate_simulation_report.m
```

Regenerate all figures:

```bash
octave --no-gui examples/run_all_plots.m
```

Surface-3 Monte Carlo sweeps cache reusable `.mat` results under `cache/`, which is ignored by git.

## Project Map

- `src/`: QEC implementations, stabilizer helpers, noise models, decoders, and sweeps.
- `tests/`: Octave-compatible correctness checks.
- `examples/`: Plot, figure regeneration, and report scripts.
- `docs/`: Longer usage, theory, setup, and results notes.
- `docs/algorithms/`: Per-code implementation notes for the bit-flip,
  phase-flip, [[4,2,2]], Shor, Steane, 5-qubit, triangular color-code, Bacon-Shor,
  generic surface-layout, and 1D repetition decoder helpers.
- `docs/ALGORITHMS.md`: Cross-reference table linking schemes, source files,
  examples, tests, and limits.
- `tools/build_pages_site.py`: GitHub Pages builder, including generated
  `api.html` source-reference output.
- `tools/build_octave_package.py`: Builds an Octave package archive under
  `dist/`.
- `docs/SIMULATION_REPORT.md`: Generated compact simulation table.
- `docs/REPOSITORY_LAYOUT.md`: Development layout and release package layout.
- `docs/ROADMAP.md`: Near-term decoder, modeling, and release priorities.
- `qec_setup.m`: Adds source and example paths for a cloned checkout.
- `DESCRIPTION`, `INDEX`, `COPYING`: Octave package metadata.
- `Makefile`: Shortcuts for tests, examples, reports, figures, site build,
  package build, and validation.
- `images/`: Generated PNG outputs.

## Notes

- The exact recovery tests verify arbitrary logical-state recovery up to global phase.
- Depolarizing-noise examples sample independent X/Y/Z errors after an error event.
- The surface-code model is intentionally compact; it includes code-capacity helpers plus a lightweight circuit-level schedule prototype, not a calibrated hardware threshold simulator. See [docs/SURFACE3.md](docs/SURFACE3.md).

See [docs/USAGE.md](docs/USAGE.md) and [docs/THEORY.md](docs/THEORY.md) for more detail.

---

## Support development

If this repository is useful for research, learning, or experimentation, you can support continued development through GitHub Sponsors:

https://github.com/sponsors/SidRichardsQuantum

Sponsorship supports open-source implementations of quantum algorithms, including better documentation, reproducible workflows, tests, and practical examples for quantum error correction.

## Citation

If you use this repository in a project, cite it as:

Sid Richards (2026). `Quantum_Error_Correction`: MATLAB/Octave implementations of quantum error-correction codes and simulations.

## Author

Sid Richards

- LinkedIn: [sid-richards-21374b30b](https://www.linkedin.com/in/sid-richards-21374b30b/)
- GitHub: [SidRichardsQuantum](https://github.com/SidRichardsQuantum)

## License

MIT. See [LICENSE](LICENSE).
