# Setup

## Prerequisites

- GNU Octave, or MATLAB for source-checkout usage
- git
- make and Python 3 for developer packaging commands

## Quick Install From Source

```bash
git clone https://github.com/SidRichardsQuantum/Quantum_Error_Correction Quantum_Error_Correction
cd Quantum_Error_Correction

sudo apt update
sudo apt install -y octave

octave --no-gui --eval "qec_setup; qec_about"
```

`qec_setup.m` adds `src/` and `examples/` to the current Octave/MATLAB path for a cloned checkout.

## Install As An Octave Package

Build a local package archive:

```bash
make package
```

Install and load it in Octave:

```bash
octave --no-gui --eval "pkg install dist/qec-0.2.0.tar.gz"
octave --no-gui --eval "pkg load qec; qec_about"
```

Once loaded, functions such as `encode_bitflip`, `recover_steane`, `surface_layout`, and `sweep_surface_distance_logical_error` are available on the Octave path.

## Development Commands

```bash
make test      # run tests/run_all_tests.m
make examples  # run text examples
make report    # regenerate docs/SIMULATION_REPORT.md
make images    # smoke-test generated PNGs
make validate  # test + examples + report + image checks
make site      # rebuild _site/
make check-links # rebuild _site/ and check internal links
make package   # build dist/qec-0.2.0.tar.gz
```

## Notes

- Examples write output to `images/`.
- The Octave package archive is built under `dist/`, which is ignored by git.
- See [Repository Layout](REPOSITORY_LAYOUT.md) for how the development tree is staged into the Octave package archive.
- No extra Octave packages are required.
- Use `"$BROWSER" <url>` to open files from the container in the host browser.
