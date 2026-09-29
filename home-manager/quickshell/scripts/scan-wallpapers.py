"""Emit a media library as JSON; never interpret filenames as shell input."""

import json
import os
import sys
from pathlib import Path

IMAGES = {".png", ".jpg", ".jpeg", ".webp", ".bmp", ".tif", ".tiff", ".avif"}
VIDEOS = {".mp4", ".webm", ".mkv", ".mov", ".m4v", ".avi", ".mpg", ".mpeg"}


def scan(roots):
    entries, warnings = [], []
    seen_files, seen_dirs = set(), set()

    def warn(error):
        warnings.append(str(error))

    for directory in roots:
        root = Path(directory).expanduser().absolute()
        if not root.is_dir():
            warnings.append(f"Directory unavailable: {root}")
            continue
        # os.walk follows a symlink passed as the root, but not nested directory
        # symlinks. This supports HM's ~/wallpapers link without recursive cycles.
        for parent, dirs, files in os.walk(root, followlinks=False, onerror=warn):
            canonical_dir = os.path.realpath(parent)
            if canonical_dir in seen_dirs:
                dirs[:] = []
                continue
            seen_dirs.add(canonical_dir)
            dirs.sort()
            for name in sorted(files):
                path = Path(parent) / name
                extension = path.suffix.lower()
                kind = (
                    "gif"
                    if extension == ".gif"
                    else "image"
                    if extension in IMAGES
                    else "video"
                    if extension in VIDEOS
                    else None
                )
                if kind is None:
                    continue
                try:
                    canonical = path.resolve(strict=True)
                    if not canonical.is_file() or not os.access(canonical, os.R_OK):
                        continue
                    if canonical in seen_files:
                        continue
                    seen_files.add(canonical)
                    entries.append(
                        {
                            "name": name,
                            "relativePath": str(path.relative_to(root)),
                            "root": str(root),
                            "path": str(canonical),
                            "url": canonical.as_uri(),
                            "kind": kind,
                        }
                    )
                except (OSError, RuntimeError) as error:
                    warn(error)
    entries.sort(key=lambda entry: (entry["name"].casefold(), entry["path"]))
    return {"entries": entries, "warnings": warnings}


if __name__ == "__main__":
    json.dump(scan(sys.argv[1:]), sys.stdout)
    sys.stdout.write("\n")
