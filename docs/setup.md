# Setup & running examples

## Prerequisites
- GNU Octave (or MATLAB)
- Xvfb (for headless plotting)
- git

## Quick install (Ubuntu 24.04)
```bash
sudo apt update
sudo apt install -y octave xvfb
```

## Notes and recommendations
- Examples write output to `images/` (e.g. `images/plot_confusion.png`).
- For reproducible dev environments, add a `devcontainer/` or Dockerfile that installs Octave + Xvfb.
- If specific Octave packages are required, list `pkg install` commands here.
- Use `"$BROWSER" <url>` to open files from the container in the host browser.
