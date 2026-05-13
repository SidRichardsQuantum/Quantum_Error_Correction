# Surface-3 Prototype

This repository includes a compact distance-3 surface-code-style model for studying syndrome lookup and logical failure under simple Pauli noise. The main helpers are code-capacity models where errors are applied directly to data qubits. A separate lightweight circuit-level prototype adds ancilla qubits, ordered check measurements, data errors between rounds, and hook-like gate faults.

## Model Assumptions

- The 3x3 layout is a compact educational prototype, not a full canonical rotated-surface-code circuit.
- Z-check supports detect X-type data errors.
- X-check supports are low-weight commuting checks chosen to distinguish all single-Z errors in this compact model.
- Logical failure is detected by odd overlap with row or column representatives after correction.
- The noisy-syndrome helpers model classical readout flips on syndrome bits.
- `simulate_surface3_circuit_level_once(...)` models repeated ancilla-check rounds with data errors between rounds and hook-like correlated faults from the check schedule.
- The circuit-level model tracks Pauli-frame X/Z error bits instead of full state-vector circuit evolution.

## Layout

Data qubits use a 3x3 row-major grid:

```text
1 2 3
4 5 6
7 8 9
```

The prototype uses four Z-check plaquette supports:

```text
[1 2 4 5]
[2 3 5 6]
[4 5 7 8]
[5 6 8 9]
```

`surface3_z_checks()` returns these supports for detecting X-type data errors.

The companion X-check supports are:

```text
[3 6 7 8]
[3 4 5 9]
[2 5 7 9]
[1 5 6 7]
```

`surface3_x_checks()` returns these supports for detecting Z-type data errors. These low-weight supports are chosen to commute with the Z checks and to give unique syndromes for single-Z errors in this compact prototype.

## Syndromes And Decoders

- `surface3_x_syndrome(e)` computes the Z-check syndrome caused by an X-error chain `e`.
- `decode_surface3_x_matching(s)` returns a minimum-weight X correction for that syndrome.
- `surface3_z_syndrome(e)` computes the X-check syndrome caused by a Z-error chain `e`.
- `decode_surface3_z_matching(s)` returns a minimum-weight Z correction for that syndrome.

The decoders exhaustively cache the lowest-weight correction for each of the 16 possible syndromes in memory. For this tiny layout, that gives the same lookup behavior expected from a minimum-weight matching-style decoder.

## Logical Operators

Rows and columns are treated as length-3 logical-chain representatives:

```text
Rows:    [1 2 3], [4 5 6], [7 8 9]
Columns: [1 4 7], [2 5 8], [3 6 9]
```

`surface3_logical_failure(residual)` reports failure when the post-correction residual chain has odd overlap with any representative. Stabilizer-like plaquette residuals have even overlap with these representatives and are not counted as logical failures.

## Noise Models

- `simulate_surface3_x_once(p)` samples independent X errors and decodes with Z-check syndromes.
- `simulate_surface3_z_once(p)` samples independent Z errors and decodes with X-check syndromes.
- `simulate_surface3_pauli_once(p)` samples independent Pauli X/Y/Z errors. Y errors contribute to both the X and Z components, which are decoded independently.
- `simulate_surface3_x_noisy_syndrome_once(p_data, p_meas, rounds)` repeats noisy Z-check syndrome measurements for X errors.
- `simulate_surface3_z_noisy_syndrome_once(p_data, p_meas, rounds)` repeats noisy X-check syndrome measurements for Z errors.

`noisy_syndrome_surface3(s, q)` flips each reported syndrome bit with probability `q`. Repeated recovery helpers majority-vote each syndrome bit before decoding.

## Circuit-Level Schedule Prototype

`surface3_measurement_schedule()` returns the compact measurement schedule:

- data qubits: `1:9`
- Z-check ancillas: `10:13`
- X-check ancillas: `14:17`
- check interaction order: the listed support order for each check

`simulate_surface3_circuit_level_once(p_data, p_meas, p_gate, rounds)` runs one Pauli-frame trial. In each round it:

1. samples independent data Pauli errors with probability `p_data`,
2. measures all Z-check ancillas to detect X-type data errors,
3. measures all X-check ancillas to detect Z-type data errors,
4. applies measurement flips with probability `p_meas`,
5. applies hook-like correlated data faults from each scheduled ancilla interaction with probability `p_gate`,
6. majority-votes the syndrome history and decodes X and Z components independently.

The output includes the schedule, X/Z syndrome histories, voted syndromes, corrections, residuals, hook-event records, and logical-success flags.

Example:

```bash
octave --no-gui examples/minimal_surface3_circuit_level.m
```

The hook model is intentionally simple: a scheduled ancilla interaction can flip a pair of adjacent data-error bits in that check order and flip the reported ancilla bit. This exposes why check order matters without pretending to be a device-calibrated circuit-noise model.

## Result Caching

Longer surface-3 Monte Carlo sweeps are cached under `cache/` as `.mat` files. The cache key includes the experiment type, trial count, seed, and cache schema version. Cached data also stores Octave version and generation time.

The plotting scripts use the cache by default:

- `surface3_cached_channel_sweep(...)`
- `surface3_cached_noisy_syndrome_sweep(...)`

Set `force_cache = true` in the calling workspace before running a plot script to regenerate cached data.

The comparison plot is generated with:

```bash
octave --no-gui examples/plot_surface3_channel_comparison.m
```

It writes:

```text
images/surface3_channel_logical_error_comparison.png
```

Repeated noisy syndrome rounds are plotted with:

```bash
octave --no-gui examples/plot_surface3_noisy_syndrome_rounds.m
```

It writes:

```text
images/surface3_noisy_syndrome_rounds.png
```

## Current Limits

The circuit-level path is still a prototype. It does not simulate full stabilizer-state circuit dynamics, leakage, idle errors, reset errors, biased noise, detector graphs, or a space-time matching decoder. The noisy-syndrome helpers remain simpler classical readout-error models on already-computed syndrome bits.
