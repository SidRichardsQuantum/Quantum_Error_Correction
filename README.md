# Quantum Error Correction

Small MATLAB/Octave implementations of quantum error-correction codes, syndrome decoders, and Monte Carlo simulations.

This repository is educational and code-oriented: it uses pure state vectors, Pauli errors, stabilizer measurements, and focused scripts that generate figures under `images/`.

## Implemented Codes

| Code or decoder | Physical qubits | What is implemented |
| --- | ---: | --- |
| 3-qubit bit-flip repetition | 3 | Encode, syndrome, correction, Monte Carlo logical error |
| 3-qubit phase-flip repetition | 3 | Encode, X-parity syndrome, Z correction |
| 5-qubit perfect code | 5 | Stabilizer encoding and single-qubit Pauli recovery |
| 7-qubit Steane code | 7 | CSS stabilizer syndrome and single-qubit Pauli recovery |
| 9-qubit Shor code | 9 | Bit/phase syndrome and single-qubit Pauli recovery |
| 1D repetition decoder | variable | Minimum-weight syndrome decoder |
| Surface-3 prototype | 9 data qubits | X/Z/Pauli code-capacity model, noisy syndrome rounds, cached minimum-weight lookup |

## Quickstart

Install Octave, then run the tests:

```bash
octave --no-gui tests/run_all_tests.m
```

Run an example:

```bash
octave --no-gui examples/plot_logical_vs_p.m
```

Run a minimal recovery example:

```bash
octave --no-gui examples/minimal_bitflip_recovery.m
```

Run a longer surface-code walkthrough:

```bash
octave --no-gui examples/surface3_walkthrough.m
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
- `docs/SIMULATION_REPORT.md`: Generated compact simulation table.
- `images/`: Generated PNG outputs.

## Notes

- The exact recovery tests verify arbitrary logical-state recovery up to global phase.
- Depolarizing-noise examples sample independent X/Y/Z errors after an error event.
- The surface-code model is intentionally compact; it is a code-capacity prototype decoder, not a full circuit-level simulator. See [docs/SURFACE3.md](docs/SURFACE3.md).

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
