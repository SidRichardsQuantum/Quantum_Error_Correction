# Generic Surface-Layout Decoder

The generic surface-layout helpers add a variable odd-distance path alongside
the fixed `surface3_*` prototype. They are intended for small code-capacity
experiments and decoder comparisons.

## Layout

`surface_layout(d)` builds an odd `d` by `d` data-qubit grid numbered row-major.
It returns:

- `layout.data`: the data-qubit grid,
- `layout.x_checks`: 2-by-2 plaquette checks used for Z-error decoding,
- `layout.z_checks`: 2-by-2 plaquette checks used for X-error decoding,
- `layout.logical_x` and `layout.logical_z`: row and column logical-line
  representatives.

Distances must be odd integers at least 3.

## Syndrome And Decoding

`surface_syndrome(error, d, kind)` computes the plaquette parity syndrome for a
binary error vector. Use `kind = 'z'` for X-error decoding and `kind = 'x'` for
Z-error decoding.

`decode_surface_min_weight(s, d, kind)` uses two strategies:

- for `d <= 3`, exhaustive minimum-weight lookup,
- for larger odd distances, exact single-error lookup followed by
  `decode_surface_union_find(...)`, a lightweight peeling heuristic.

The larger-distance branch is a compact teaching decoder, not a calibrated MWPM
or threshold-quality union-find implementation.

## Simulation

`simulate_surface_pauli_once(d, p)` samples independent Pauli errors and decodes
X and Z components separately. `sweep_surface_distance_logical_error(...)`
compares logical-failure estimates across distances, for example:

```matlab
results = sweep_surface_distance_logical_error([3 5], [0.01 0.03 0.05], 100, 7);
```

## Main Files

- `src/surface_layout.m`
- `src/surface_checks.m`
- `src/surface_syndrome.m`
- `src/surface_logical_failure.m`
- `src/decode_surface_min_weight.m`
- `src/decode_surface_union_find.m`
- `src/simulate_surface_pauli_once.m`
- `src/sweep_surface_distance_logical_error.m`

## Example

```bash
octave --no-gui examples/minimal_surface_distance_decoder.m
```

## Tests

```bash
octave --no-gui tests/run_all_tests.m
```

`tests/test_surface_distance.m` checks the layout metadata, single-error
syndrome correction for `d = 3` and `d = 5`, zero-noise simulation, and a small
distance-comparison sweep.
