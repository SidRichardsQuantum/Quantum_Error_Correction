# 5-Qubit Perfect Code

The 5-qubit perfect code is the smallest distance-3 stabilizer code that
corrects an arbitrary single-qubit Pauli error. This repository implements
state-vector encoding through stabilizer projection and syndrome-table recovery.

## Stabilizers

`fivequbit_stabilizers()` returns:

```text
XZZXI
IXZZX
XIXZZ
ZXIXZ
```

These four generators define a two-dimensional code space inside the
five-qubit Hilbert space.

## Logical States

`encode_fivequbit(alpha_beta)` constructs `|0_L>` by projecting a computational
basis seed into the stabilizer +1 eigenspace and the logical-Z +1 eigenspace.
It then applies logical X:

```text
XXXXX
```

to construct `|1_L>`. The returned encoded state is:

```text
alpha|0_L> + beta|1_L>
```

The implementation uses:

```text
logical Z = ZZZZZ
logical X = XXXXX
```

## Syndrome And Recovery

`syndrome_fivequbit(psi)` measures the four stabilizer generators.

`correct_fivequbit(psi, syndrome)` searches all single-qubit Pauli errors:

```text
X, Y, Z on qubits 1 through 5
```

For each candidate error, it computes the expected syndrome with
`pauli_error_syndrome(...)`. When the expected syndrome matches the measured
one, it applies the same Pauli as the correction.

The high-level recovery helper is:

```matlab
[psi_corr, syndrome] = recover_fivequbit(psi_noisy);
```

The tests verify recovery from every single-qubit X, Y, and Z error on an
arbitrary encoded logical state.

## Main Files

- `src/fivequbit_stabilizers.m`
- `src/encode_fivequbit.m`
- `src/syndrome_fivequbit.m`
- `src/correct_fivequbit.m`
- `src/recover_fivequbit.m`
- `src/pauli_error_syndrome.m`

## Examples

The 5-qubit implementation is covered by the text example runner:

```bash
octave --no-gui examples/run_text_examples.m
```

The recovery functions can also be called directly after adding `src/` to the
Octave path.

## Tests

The main checks live in:

- `tests/test_stabilizer_codes.m`

Run them through:

```bash
octave --no-gui tests/run_all_tests.m
```

## Current Limits

- Recovery is designed and tested for single-qubit Pauli errors.
- The implementation uses exact state-vector operations and stabilizer
  projection, not an encoding circuit.
- Logical gates and fault-tolerant measurement circuits are not implemented.
