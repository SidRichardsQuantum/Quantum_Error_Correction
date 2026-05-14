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

`decode_surface_min_weight(s, d, kind)` uses three strategies:

- for `d = 3`, cached exhaustive minimum-weight lookup,
- for `d = 5`, cached bounded lookup through weight-2 data errors,
- for larger odd distances, exact single-error lookup followed by
  `decode_surface_union_find(...)`, a vectorized peeling heuristic.

`decode_surface_graph_matching(s, d, kind)` is a bounded syndrome-graph search
baseline. It reuses the same cached lookup machinery, but stops after the
configured candidate weight instead of peeling unresolved syndromes. This makes
it useful as a clearer comparison point for small error patterns.

Both decoders are compact teaching decoders. The lookup branches are exact only
within their searched candidate weight, and the larger-distance peeling branch
is not a calibrated MWPM or threshold-quality union-find implementation.

## Simulation

`simulate_surface_pauli_once(d, p, decoder)` samples independent Pauli errors
and decodes X and Z components separately. `decoder` can be `min_weight`,
`graph_matching`, or `union_find`. `sweep_surface_distance_logical_error(...)`
compares logical-failure estimates across distances, for example:

```matlab
results = sweep_surface_distance_logical_error([3 5], [0.01 0.03 0.05], 100, 7, 'graph_matching');
```

For a compact d=3/5/7 decoder comparison:

```bash
octave --no-gui examples/benchmark_surface_distance_decoder.m
octave --no-gui examples/plot_surface_distance_scaling.m
```

Both scripts accept command-line overrides:

```bash
octave --no-gui examples/benchmark_surface_distance_decoder.m -- --trials=200 --seed=7 --ps="0 0.02 0.04" --distances="3 5" --decoders=min_weight,graph_matching
```

The same settings can be supplied with `QEC_SURFACE_TRIALS`,
`QEC_SURFACE_SEED`, `QEC_SURFACE_PS`, `QEC_SURFACE_DISTANCES`, and
`QEC_SURFACE_DECODERS`.

## Main Files

- `src/surface_layout.m`
- `src/surface_checks.m`
- `src/surface_syndrome.m`
- `src/surface_logical_failure.m`
- `src/surface_decoder_lookup.m`
- `src/decode_surface_min_weight.m`
- `src/decode_surface_graph_matching.m`
- `src/decode_surface_union_find.m`
- `src/surface_benchmark_options.m`
- `src/simulate_surface_pauli_once.m`
- `src/sweep_surface_distance_logical_error.m`
- `examples/benchmark_surface_distance_decoder.m`
- `examples/plot_surface_distance_scaling.m`

## Example

```bash
octave --no-gui examples/minimal_surface_distance_decoder.m
```

## Tests

```bash
octave --no-gui tests/run_all_tests.m
```

`tests/test_surface_distance.m` checks the layout metadata, single-error
syndrome correction for `d = 3` and `d = 5`, graph-baseline correction for
representative `d = 3`, `d = 5`, and `d = 7` patterns, representative
two-error correction for `d = 5` and `d = 7`, zero-noise simulation, and small
distance-comparison sweeps.
