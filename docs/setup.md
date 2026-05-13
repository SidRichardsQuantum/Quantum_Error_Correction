# Setup

## Prerequisites
- GNU Octave (or MATLAB)
- Xvfb (for headless plotting)
- git

## Quick install (Ubuntu 24.04)
```bash
# clone into /workspaces so examples' paths match
cd /workspaces
git clone <https://github.com/SidRichardsQuantum/Quantum_Error_Correction> Quantum_Error_Correction
cd Quantum_Error_Correction

# install system deps
sudo apt update
sudo apt install -y octave xvfb
```

## Notes and recommendations
- Examples write output to `images/` (e.g. `images/bitflip_decoder_confusion_matrix.png`).
- Run tests with `octave --no-gui tests/run_all_tests.m`.
- For reproducible dev environments, add a `devcontainer/` or Dockerfile that installs Octave + Xvfb.
- If specific Octave packages are required, list `pkg install` commands here.
- Use `"$BROWSER" <url>` to open files from the container in the host browser.
