# 7-Qubit Triangular Color Code

The smallest triangular 2D color code is the standard `[7,1,3]` CSS code,
locally equivalent to the Steane code. This repository exposes it through
color-code-facing helpers while reusing the same state-vector stabilizer
machinery used by the Steane implementation.

## Layout And Stabilizers

`color7_layout()` returns seven data qubits, three colored face supports, and
weight-seven logical representatives. `color7_stabilizers()` builds six CSS
generators from the Hamming parity-check matrix:

- three Z-type checks detect X components of data errors,
- three X-type checks detect Z components of data errors.

## Recovery Flow

The state-vector recovery helper is:

```matlab
[psi_corr, syndrome] = recover_color7(psi_noisy);
```

The Pauli-frame helper is:

```matlab
out = recover_color7_pauli('IIIIYII');
```

For a Y error, both the X-error and Z-error syndrome parts are nonzero.

## Main Files

- `src/color7_layout.m`
- `src/color7_stabilizers.m`
- `src/encode_color7.m`
- `src/syndrome_color7.m`
- `src/correct_color7.m`
- `src/recover_color7.m`
- `src/recover_color7_pauli.m`
- `src/simulate_color7_pauli_once.m`

## Example

```bash
octave --no-gui examples/minimal_color7_recovery.m
```

## Tests

```bash
octave --no-gui tests/run_all_tests.m
```

The tests verify state-vector and Pauli-frame recovery for every single-qubit
X, Y, and Z error.

## Current Limits

- This is the smallest triangular color code, so it is intentionally equivalent
  to the Steane code at the stabilizer level.
- Recovery is single-qubit Pauli recovery, not a full color-code decoder family.
- Gauge fixing and transversal logical gates are not implemented.
