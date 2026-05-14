# Algorithm Index

This index maps each implemented QEC scheme or decoder to its documentation,
source files, examples, tests, and current modeling limits.

| Scheme | Protects against / purpose | Main files | Examples | Tests | Limits |
| --- | --- | --- | --- | --- | --- |
| [3-qubit bit-flip repetition](algorithms/BITFLIP.md) | One Pauli-X error on three physical qubits | `encode_bitflip.m`, `syndrome_bitflip.m`, `correct_bitflip.m`, `recover_bitflip.m` | `minimal_bitflip_recovery.m`, `plot_logical_vs_p.m`, `plot_noisy_syndrome_rounds.m` | `test_bitflip.m`, `test_decoders_and_simulations.m` | Bit-flip protection only; noisy syndrome mode models classical readout flips |
| [3-qubit phase-flip repetition](algorithms/PHASEFLIP.md) | One Pauli-Z error using X-basis repetition | `encode_phaseflip.m`, `syndrome_phaseflip.m`, `correct_phaseflip.m`, `recover_phaseflip.m` | `minimal_phaseflip_recovery.m` | `test_phaseflip.m` | Phase-flip protection only; no dedicated plot script |
| [5-qubit perfect code](algorithms/FIVE_QUBIT.md) | Any single-qubit Pauli X/Y/Z error | `fivequbit_stabilizers.m`, `encode_fivequbit.m`, `syndrome_fivequbit.m`, `correct_fivequbit.m`, `recover_fivequbit.m` | `minimal_fivequbit_recovery.m` | `test_stabilizer_codes.m` | State-vector stabilizer projection, not an encoding circuit |
| [7-qubit Steane code](algorithms/STEANE.md) | Any single-qubit Pauli X/Y/Z error with CSS checks | `steane_parity_check.m`, `encode_steane.m`, `syndrome_steane.m`, `correct_steane.m`, `recover_steane.m` | `minimal_steane_recovery.m` | `test_stabilizer_codes.m` | Direct projective checks; transversal gates are not implemented |
| [7-qubit triangular color code](algorithms/COLOR7.md) | Smallest triangular color code; any single-qubit Pauli X/Y/Z error | `color7_layout.m`, `color7_stabilizers.m`, `encode_color7.m`, `recover_color7.m`, `recover_color7_pauli.m` | `minimal_color7_recovery.m` | `test_color7.m` | Uses the standard Steane-equivalent [7,1,3] color-code representation |
| [9-qubit Shor code](algorithms/SHOR.md) | Any single-qubit Pauli X/Y/Z error using bit/phase repetition structure | `encode_shor.m`, `syndrome_shor.m`, `correct_shor.m`, `recover_shor.m` | `minimal_shor_recovery.m` | `test_stabilizer_codes.m` | No fault-tolerant syndrome-extraction circuit |
| [3x3 Bacon-Shor subsystem code](algorithms/BACON_SHOR.md) | Single-qubit Pauli errors in a compact subsystem-code Pauli-frame model | `bacon_shor_x_syndrome.m`, `bacon_shor_z_syndrome.m`, `decode_bacon_shor_x.m`, `decode_bacon_shor_z.m`, `recover_bacon_shor_pauli.m` | `minimal_bacon_shor_recovery.m` | `test_bacon_shor.m` | Tracks Pauli-frame logical success rather than full gauge-state fidelity |
| [1D repetition decoder](algorithms/REPETITION_DECODER.md) | Minimum-weight binary chain compatible with a parity syndrome | `decode_repetition_min_weight.m`, `decode_majority.m` | `minimal_repetition_decoder.m` | `test_decoders_and_simulations.m` | Binary nearest-neighbor parity decoder only; no soft information |
| [Surface-3 prototype](SURFACE3.md) | Compact surface-code-style X/Z/Pauli code-capacity and noisy-syndrome studies | `surface3_*`, `decode_surface3_*`, `simulate_surface3_*`, `sweep_surface3_*` | `minimal_surface3_syndrome.m`, `minimal_surface3_circuit_level.m`, `surface3_walkthrough.m` | `test_surface3.m` | Educational prototype, not a calibrated threshold simulator |
| [Generic surface-layout decoder](algorithms/SURFACE_DISTANCE.md) | Odd-distance square layout and lightweight decoder comparisons | `surface_layout.m`, `surface_syndrome.m`, `decode_surface_min_weight.m`, `decode_surface_union_find.m`, `sweep_surface_distance_logical_error.m` | `minimal_surface_distance_decoder.m` | `test_surface_distance.m` | Code-capacity parity model; larger-distance decoder is a lightweight peeling heuristic |

## Validation Commands

Run all unit tests:

```bash
octave --no-gui tests/run_all_tests.m
```

Run all text examples:

```bash
octave --no-gui examples/run_text_examples.m
```

Regenerate the compact simulation report:

```bash
octave --no-gui examples/generate_simulation_report.m
```
