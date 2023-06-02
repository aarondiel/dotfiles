#!/bin/python

import utils
from os import path
from sys import argv
from shutil import make_archive

def get_filename() -> str:
    return utils.get_command_output(
        "gum",
        "input",
        "--placeholder",
        "name of the zip archive (without .zip)"
    )

def to_zip(file: str) -> None:
    filename = get_filename()
    dirname = path.dirname(file)
    output_file = path.join(dirname, filename)

    if utils.file_exists(output_file):
        return

    make_archive(output_file, "zip", file, path.dirname(file))


if __name__ == "__main__":
    files: list[str] = argv[1].splitlines()

    for file in files:
        to_zip(file)
