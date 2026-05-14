# 3x3 Bacon-Shor Subsystem Code

The Bacon-Shor implementation is a compact Pauli-frame model of the 3x3
subsystem code. It focuses on syndrome algebra, representative corrections,
and logical residual checks rather than full state-vector gauge dynamics.

## Layout

Data qubits use a 3x3 row-major grid:

```text
1 2 3
4 5 6
7 8 9
```

`bacon_shor_layout()` returns this layout as a matrix.

## Stabilizers

The compact stabilizer representatives are:

```text
ZZIZZIZZI
IZZIZZIZZ
XXXXXXIII
IIIXXXXXX
```

The Z-type stabilizers compare neighboring column parities and detect X-error
components. The X-type stabilizers compare neighboring row parities and detect
Z-error components.

## Syndrome Convention

`bacon_shor_x_syndrome(x_error)` returns two bits:

```text
[col1 xor col2, col2 xor col3]
```

where each column value is the parity of X-error components in that column.

`bacon_shor_z_syndrome(z_error)` returns:

```text
[row1 xor row2, row2 xor row3]
```

where each row value is the parity of Z-error components in that row.

The syndrome-to-index convention is the same as the 3-bit repetition decoder:

```text
[1 0] -> first row or column
[1 1] -> second row or column
[0 1] -> third row or column
[0 0] -> no correction
```

## Recovery Flow

The high-level Pauli-frame recovery helper is:

```matlab
out = recover_bacon_shor_pauli(error_string);
```

For an input Pauli string such as `IIIIYIIII`, it separates the X and Z
components, computes row/column syndromes, applies representative X/Z
corrections, and reports whether the residual has logical parity.

The X decoder, `decode_bacon_shor_x(s)`, applies a representative X correction
on the first row of the identified column. The Z decoder,
`decode_bacon_shor_z(s)`, applies a representative Z correction on the first
column of the identified row. Different representatives can differ by gauge
operators; the logical residual check is the invariant quantity used here.

## Logical Failure Check

`bacon_shor_logical_failure(x_residual, z_residual)` reports failure when:

- an X residual has odd parity in any column, or
- a Z residual has odd parity in any row.

This matches the compact subsystem-code Pauli-frame model used by the decoder.

## Noise And Simulation

`simulate_bacon_shor_pauli_once(p)` samples an independent 9-qubit Pauli error
string with `sample_pauli_error_string(9, p)` and runs
`recover_bacon_shor_pauli(...)`.

## Main Files

- `src/bacon_shor_layout.m`
- `src/bacon_shor_stabilizers.m`
- `src/bacon_shor_x_syndrome.m`
- `src/bacon_shor_z_syndrome.m`
- `src/decode_bacon_shor_x.m`
- `src/decode_bacon_shor_z.m`
- `src/bacon_shor_logical_failure.m`
- `src/recover_bacon_shor_pauli.m`
- `src/simulate_bacon_shor_pauli_once.m`

## Examples

```bash
octave --no-gui examples/minimal_bacon_shor_recovery.m
```

The example is also included in:

```bash
octave --no-gui examples/run_text_examples.m
```

## Tests

The main checks live in:

- `tests/test_bacon_shor.m`

Run them through:

```bash
octave --no-gui tests/run_all_tests.m
```

## Current Limits

- This is a Pauli-frame subsystem-code model, not a full state-vector
  simulation of gauge-qubit dynamics.
- Recovery is tested for every single-qubit X, Y, and Z error.
- It does not include noisy gauge-measurement circuits, hook errors, or a
  space-time detector decoder.
