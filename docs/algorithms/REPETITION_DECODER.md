# 1D Repetition Minimum-Weight Decoder

The 1D repetition decoder is a small classical decoder used to connect parity
syndromes with minimum-weight correction chains. It is independent of the
3-qubit state-vector recovery helpers and works directly on binary error and
syndrome vectors.

## Syndrome Convention

For a length-`n` binary error chain `e`, the repetition-code syndrome has length
`n - 1` and is defined by neighboring parity differences:

```text
s(k) = e(k) xor e(k + 1)
```

This syndrome records domain walls in the error chain.

## Decoder Behavior

`decode_repetition_min_weight(s)` reconstructs two compatible chains:

- one assuming the first error bit is `0`,
- one assuming the first error bit is `1`.

It returns whichever compatible chain has lower Hamming weight. Ties are broken
in favor of the chain that starts with `0`.

Example:

```matlab
s = [1 1 0];
ehat = decode_repetition_min_weight(s);
```

The result is a binary correction chain whose neighboring parities reproduce
`s`.

## Relationship To QEC

This is the classical decoding problem behind repetition-code correction:

1. parity checks reveal where neighboring bits disagree,
2. the decoder chooses a low-weight error pattern compatible with that
   syndrome,
3. applying that correction removes the inferred error chain.

For the tiny 3-qubit bit-flip code, `correct_bitflip(...)` uses a direct
syndrome-to-qubit lookup. `decode_repetition_min_weight(...)` is the more
general variable-length version of the same minimum-weight idea.

## Main Files

- `src/decode_repetition_min_weight.m`
- `src/binary_syndrome_index.m`
- `src/decode_majority.m`

## Examples

The decoder is exercised by the text examples and simulation tests:

```bash
octave --no-gui examples/run_text_examples.m
octave --no-gui tests/run_all_tests.m
```

## Tests

The main checks live in:

- `tests/test_decoders_and_simulations.m`

Run them through:

```bash
octave --no-gui tests/run_all_tests.m
```

## Current Limits

- The decoder is a 1D binary repetition decoder, not a general stabilizer-code
  decoder.
- It assumes independent binary chain errors and nearest-neighbor parity
  syndromes.
- It does not use probabilities or soft information; it only minimizes Hamming
  weight.
