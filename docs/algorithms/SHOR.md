# 9-Qubit Shor Code

The Shor code combines phase-error protection with bit-flip repetition blocks.
This repository implements state-vector encoding, syndrome extraction, and
single-qubit Pauli recovery.

## Logical States

`encode_shor(alpha_beta)` builds logical states from three GHZ-like repetition
blocks:

```text
|GHZ+> = (|000> + |111>) / sqrt(2)
|GHZ-> = (|000> - |111>) / sqrt(2)

|0_L> = |GHZ+>|GHZ+>|GHZ+>
|1_L> = |GHZ->|GHZ->|GHZ->
```

For an input state `alpha|0> + beta|1>`, the encoded state is:

```text
alpha|0_L> + beta|1_L>
```

## Stabilizers And Syndrome

The stabilizer generators returned by `stabilizers_for_code('shor')` are:

```text
ZZIIIIIII
IZZIIIIII
IIIZZIIII
IIIIZZIII
IIIIIIZZI
IIIIIIIZZ
XXXXXXIII
IIIXXXXXX
```

The first six checks detect bit flips within each 3-qubit block. The final two
checks compare the phase parity of neighboring blocks.

`syndrome_shor(psi)` returns a structured syndrome with:

- `syn.bit`: three local two-bit repetition syndromes, one per block.
- `syn.phase`: a two-bit syndrome identifying the likely block affected by a
  phase error.

## Recovery Flow

The high-level recovery helper is:

```matlab
[psi_corr, syndrome] = recover_shor(psi_noisy);
```

`correct_shor(psi, syndrome)` applies X corrections inside each block based on
the local bit syndromes. If the phase syndrome identifies a block, it applies a
Z correction to the first qubit of that block. That block-level Z correction is
equivalent, on the code space, to correcting the phase component of a
single-qubit Pauli error in the block.

The tests verify recovery from every single-qubit X, Y, and Z error on an
arbitrary encoded logical state.

## Main Files

- `src/encode_shor.m`
- `src/syndrome_shor.m`
- `src/correct_shor.m`
- `src/recover_shor.m`
- `src/stabilizers_for_code.m`

## Examples

The Shor implementation is covered by the text example runner:

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
- The implementation uses projective stabilizer measurements on state vectors,
  not a fault-tolerant syndrome-extraction circuit.
- It does not simulate encoded gates or logical-state preparation circuits.
