# Repository Layout

The repository keeps a development layout and builds the Octave package layout during release packaging.

## Development Layout

- `src/`: loadable MATLAB/Octave functions.
- `examples/`: runnable demos, plots, report generation, and benchmark scripts.
- `tests/`: Octave-compatible regression tests.
- `docs/`: source documentation used by GitHub Pages and package docs.
- `images/`: generated PNG figures used by docs and the website.
- `tools/`: build, packaging, and site-validation scripts.
- `cache/`, `_site/`, `dist/`: generated local output ignored by git.

This layout keeps source, tests, examples, and docs easy to inspect in a cloned checkout.

## Package Layout

Octave packages expect loadable `.m` files in an `inst/` directory inside the package archive. The repository does not keep a checked-in `inst/` copy because that would duplicate every source file in `src/`.

Instead, `tools/build_octave_package.py` stages the release archive:

- `src/*.m` -> `inst/*.m`
- `docs/` -> `doc/`
- `examples/` -> `doc/examples/`
- `tests/` -> `doc/tests/`
- `images/` -> `doc/images/`
- `DESCRIPTION`, `INDEX`, and `COPYING` -> package metadata

Build the package with:

```bash
make package
```

The generated archive is written to `dist/qec-0.2.0.tar.gz` and can be attached to a GitHub Release.

## Why Not Move `src/` To `inst/`?

Keeping `src/` in the repository is friendlier for contributors and for the existing examples/tests, while the release artifact still follows Octave package conventions. The package builder is the boundary between the contributor layout and the installable layout.
