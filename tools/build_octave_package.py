#!/usr/bin/env python3
"""Build an Octave package archive from the repository layout."""

from __future__ import annotations

import shutil
import tarfile
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DIST = ROOT / "dist"
NAME = "qec"
VERSION = "0.2.0"


def copy_file(src: Path, dst: Path) -> None:
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(src, dst)


def copy_tree(src: Path, dst: Path) -> None:
    if src.exists():
        shutil.copytree(
            src,
            dst,
            dirs_exist_ok=True,
            ignore=shutil.ignore_patterns("__pycache__", "*.pyc", "doc-cache", "octave-workspace"),
        )


def main() -> None:
    DIST.mkdir(exist_ok=True)
    archive = DIST / f"{NAME}-{VERSION}.tar.gz"

    with tempfile.TemporaryDirectory(prefix="qec-package-") as tmp:
        package_root = Path(tmp) / f"{NAME}-{VERSION}"
        package_root.mkdir()

        for filename in ["DESCRIPTION", "COPYING", "INDEX", "README.md", "CITATION.cff"]:
            copy_file(ROOT / filename, package_root / filename)

        inst = package_root / "inst"
        inst.mkdir()
        for source in sorted((ROOT / "src").glob("*.m")):
            copy_file(source, inst / source.name)

        copy_tree(ROOT / "docs", package_root / "doc")
        copy_tree(ROOT / "examples", package_root / "doc" / "examples")
        copy_tree(ROOT / "tests", package_root / "doc" / "tests")
        copy_tree(ROOT / "images", package_root / "doc" / "images")

        if archive.exists():
            archive.unlink()
        with tarfile.open(archive, "w:gz") as tar:
            tar.add(package_root, arcname=package_root.name)

    print(f"Wrote {archive}")


if __name__ == "__main__":
    main()
