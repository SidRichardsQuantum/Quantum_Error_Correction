# 3-Qubit Phase-Flip Repetition Code

The phase-flip repetition code is the X-basis counterpart of the bit-flip
repetition code. It protects one logical qubit against a single Pauli-Z error.

## Logical States

The implementation uses:

```text
|+> = (|0> + |1>) / sqrt(2)
|-> = (|0> - |1>) / sqrt(2)

|0_L> = |+++>
|1_L> = |--->
```

For an input state `alpha|0> + beta|1>`, `encode_phaseflip(alpha_beta)` returns:

```text
alpha|+++> + beta|--->
```

## Stabilizers And Syndrome

The implemented stabilizer checks are X-parity checks:

```text
X1 X2
X2 X3
```

In code, these are represented as:

```text
XXI
IXX
```

`syndrome_phaseflip(psi)` measures these checks. A nonzero syndrome identifies
the most likely single-qubit Z error.

## Recovery Flow

The high-level recovery helper is:

```matlab
[psi_corr, syndrome] = recover_phaseflip(psi_noisy);
```

It measures the X-parity syndrome and applies the corresponding Z correction.
Recovery preserves the encoded logical state up to global phase for zero or one
Z error.

## Main Files

- `src/encode_phaseflip.m`
- `src/syndrome_phaseflip.m`
- `src/correct_phaseflip.m`
- `src/recover_phaseflip.m`
- `src/apply_phase_error_pattern.m`

## Examples

The phase-flip implementation is covered by the text example runner:

```bash
octave --no-gui examples/run_text_examples.m
```

The same functions can also be called directly from Octave after adding `src/`
to the path.

## Tests

The main checks live in:

- `tests/test_phaseflip.m`

Run them through:

```bash
octave --no-gui tests/run_all_tests.m
```

## Current Limits

- Corrects Z-type phase flips only.
- Does not correct arbitrary Pauli errors by itself.
- No dedicated plotting script is currently provided for this code.
