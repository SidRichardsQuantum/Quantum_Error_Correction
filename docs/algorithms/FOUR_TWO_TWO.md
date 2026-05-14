# [[4,2,2]] Error-Detecting Code

The `[[4,2,2]]` stabilizer code encodes two logical qubits into four physical
qubits. Its distance is 2, so it detects any single-qubit Pauli error but does
not correct arbitrary single-qubit errors.

## Stabilizers

`four_two_two_stabilizers()` returns:

```text
XXXX
ZZZZ
```

The simultaneous +1 eigenspace has dimension 4, corresponding to two logical
qubits.

## Logical Basis

`encode_four_two_two(alpha_beta)` accepts four amplitudes ordered as:

```text
|00>, |01>, |10>, |11>
```

It maps them to the complement-pair basis:

```text
|00_L> = (|0000> + |1111>) / sqrt(2)
|01_L> = (|0011> + |1100>) / sqrt(2)
|10_L> = (|0101> + |1010>) / sqrt(2)
|11_L> = (|0110> + |1001>) / sqrt(2)
```

Each basis state is stabilized by `XXXX` and `ZZZZ`.

## Syndrome And Detection

`syndrome_four_two_two(psi)` measures the two stabilizers.

`detect_four_two_two(input)` accepts either a state vector or a Pauli error
string. It returns true when the syndrome is nonzero:

```matlab
[detected, syndrome] = detect_four_two_two('IXII');
```

Every single-qubit `X`, `Y`, or `Z` error anticommutes with at least one
stabilizer and is detected. Zero-syndrome logical operators such as `XXII` or
`ZIZI` are not detected, which is expected: this is an error-detecting code,
not a correction procedure.

## Main Files

- `src/four_two_two_stabilizers.m`
- `src/encode_four_two_two.m`
- `src/syndrome_four_two_two.m`
- `src/detect_four_two_two.m`
- `src/pauli_error_syndrome.m`

## Example

```bash
octave --no-gui examples/minimal_four_two_two_detection.m
```

The example is also included in:

```bash
octave --no-gui examples/run_text_examples.m
```

## Tests

The main checks live in:

- `tests/test_stabilizer_codes.m`

Run them through:

```bash
octave --no-gui tests/run_all_tests.m
```

## Current Limits

- The implementation detects single-qubit Pauli errors but does not recover
  them.
- The encoder constructs exact state vectors directly, not an encoding circuit.
- Erasure decoding and post-selected workflows are not implemented yet.
