# 3-Qubit Bit-Flip Repetition Code

The bit-flip repetition code protects one logical qubit against a single
Pauli-X error by encoding the logical state redundantly across three physical
qubits.

## Logical States

```text
|0_L> = |000>
|1_L> = |111>
```

For an input state `alpha|0> + beta|1>`, `encode_bitflip(alpha_beta)` returns:

```text
alpha|000> + beta|111>
```

## Stabilizers And Syndrome

The implemented stabilizer checks are:

```text
Z1 Z2
Z2 Z3
```

In code, these are represented as:

```text
ZZI
IZZ
```

`syndrome_bitflip(psi)` measures the two parity checks. A nonzero syndrome
identifies the most likely single-qubit X error.

The correction convention used by `correct_bitflip(psi, syndrome)` is:

```text
[1 0] -> X on qubit 1
[1 1] -> X on qubit 2
[0 1] -> X on qubit 3
[0 0] -> no correction
```

## Recovery Flow

The high-level recovery helper is:

```matlab
[psi_corr, syndrome] = recover_bitflip(psi_noisy);
```

It measures the syndrome and applies the corresponding X correction. Recovery
preserves the encoded logical state up to global phase for zero or one X error.
Two or three X errors can produce a logical failure.

## Noise And Simulation

The bit-flip Monte Carlo helpers sample independent X errors on the three data
qubits. `simulate_bitflip_once(p)` runs one trial at physical error probability
`p`, and `sweep_logical_error(...)` estimates logical failure rates over a range
of probabilities.

Noisy syndrome examples repeat syndrome extraction and majority-vote each
syndrome bit. This models classical readout flips on the reported syndrome, not
an ancilla-level circuit.

## Main Files

- `src/encode_bitflip.m`
- `src/syndrome_bitflip.m`
- `src/correct_bitflip.m`
- `src/recover_bitflip.m`
- `src/simulate_bitflip_once.m`
- `src/simulate_noisy_syndrome_bitflip_once.m`
- `src/sweep_logical_error.m`
- `src/sweep_noisy_syndrome_bitflip.m`

## Examples

```bash
octave --no-gui examples/minimal_bitflip_recovery.m
octave --no-gui examples/plot_logical_vs_p.m
octave --no-gui examples/plot_noisy_syndrome_rounds.m
```

## Tests

The main checks live in:

- `tests/test_bitflip.m`
- `tests/test_decoders_and_simulations.m`

Run them through:

```bash
octave --no-gui tests/run_all_tests.m
```

## Current Limits

- Corrects X-type bit flips only.
- Does not protect against phase errors.
- Noisy syndrome mode flips classical syndrome bits rather than simulating a
  full measurement circuit.
