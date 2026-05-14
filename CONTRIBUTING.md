# Contributing

Contributions are welcome when they keep the repository educational, reproducible, and Octave-compatible.

## Development Setup

Install GNU Octave, then run:

```bash
make validate
```

Build the Octave package archive with:

```bash
make package
```

Check generated website links with:

```bash
make check-links
```

If `make` is unavailable, run the same checks directly:

```bash
octave --no-gui tests/run_all_tests.m
octave --no-gui examples/run_text_examples.m
octave --no-gui examples/generate_simulation_report.m
octave --no-gui examples/check_generated_images.m
```

## Code Guidelines

- Keep new MATLAB/Octave code compatible with GNU Octave.
- Prefer small functions in `src/` with focused examples in `examples/`.
- Add or update tests when changing decoder, recovery, or simulation behavior.
- Keep Monte Carlo defaults small enough for local and CI runs.
- Document modeling assumptions clearly, especially for surface-code and circuit-level approximations.
- Update `DESCRIPTION`, `INDEX`, and `src/qec_version.m` together when changing the package version.

## Generated Outputs

Plots are written to `images/`. The compact report is generated at `docs/SIMULATION_REPORT.md`.

Surface-3 sweep caches live under `cache/`, which is ignored by git.

Octave package archives are built under `dist/`, which is ignored by git.
