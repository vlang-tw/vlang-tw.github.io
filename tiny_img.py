#!/usr/bin/env python

"""Using TinyPng API (Tinify) to compress images.
"""

from pathlib import Path
from tempfile import TemporaryDirectory
from shutil import copyfile
import tinify

path_here = Path(__file__).parent
key_file = path_here / "TINIFY_API_KEY"

with key_file.open("r") as f:
    tinify.key = f.readline()


class Compressor:
    @classmethod
    def _walk(cls, p: Path, handler):
        for child in p.iterdir():
            if not child.is_file():
                return cls._walk(child, handler)
            if child.suffix not in (".jpg", ".png"):
                continue
            if callable(handler):
                handler(child)

    def __init__(self, src_dir: Path, dist_dir: Path):
        self._src_dir = src_dir
        self._dist_dir = dist_dir
        self._tmpdir = TemporaryDirectory(prefix="vlang-tw.github.io__")
        self._tmp_path = Path(self._tmpdir.name)

    def __call__(self, curr_file: Path):
        rel = curr_file.relative_to(self._src_dir)
        result_path = self._tmp_path.joinpath(rel)
        dist_path = self._dist_dir.joinpath(rel)
        print("compress : ", curr_file)
        if not result_path.parent.exists():
            result_path.parent.mkdir(parents=True)
        tinify.from_file(str(curr_file)).to_file(str(result_path))
        print(">> copy to:", dist_path)
        if not dist_path.parent.exists():
            dist_path.parent.mkdir(parents=True)
        copyfile(result_path, dist_path)

    def run(self):
        print("=== Temp directory `", self._tmp_path, "` stores compressed images ===")
        self._walk(self._src_dir, self)
        self._tmpdir.cleanup()
        print("=== Clean up the temp directory ===")


compressor = Compressor(path_here / "assets/img", path_here / "docs/assets/img")
compressor.run()
