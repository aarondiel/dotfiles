#!/bin/python

from sys import argv
from typing import Iterable
from subprocess import Popen
from os import listdir, path, environ
from utils import get_confirmation
from prompt_deletion import prompt_deletion
from tempfile import NamedTemporaryFile
from concurrent.futures import ThreadPoolExecutor as Pool

def longest_common_path(files: list[str]) -> tuple[Iterable[str], str]:
    common_path = (
        path.dirname(files[0])
        if len(files) == 1
        else path.commonpath(files)
    )

    if not common_path.endswith("/"):
        common_path += "/"

    return (
        (file[len(common_path):] for file in files),
        common_path
    )


def get_new_filenames(filenames: Iterable[str]) -> Iterable[str]:
    with NamedTemporaryFile(mode="w+") as temp_file:
        temp_file.write("\n".join(filenames))
        temp_file.flush()

        editor = environ.get("EDITOR")
        if editor == None:
            editor = "vi"

        Popen([editor, temp_file.name]).wait()

        temp_file.seek(0)

        return (
            line.removesuffix("\n")
            for line in temp_file.readlines()
        )


def create_temp_dir(common_path: str) -> str | None:
    directory_path = path.join(common_path, ".lf")

    if path.exists(directory_path):
        return None

    Popen(["mkdir", "-p", directory_path]).wait(32)

    return directory_path


def remove_temp_dir(temp_dir: str) -> None:
    if len(listdir(temp_dir)) != 0:
        print("something went wrong!")
        print(f"please recover the files in \"{temp_dir}\"")
        return

    Popen(["rmdir", temp_dir])


def move(from_file: str, to_file: str) -> None:
    Popen(["mv", from_file, to_file]).wait()


if __name__ == "__main__":
    files: list[str] = argv[1].splitlines()
    shortened_files, common_path = longest_common_path(files)
    renamed_files = list(get_new_filenames(shortened_files))

    if (len(files) != len(renamed_files)):
        print("unmatched number of files")
        exit(1)

    for from_file, to_file in zip(files, renamed_files):
          print(f"\"{from_file}\" -> \"{to_file}\"")

    if not get_confirmation("do you want to rename these files?"):
        exit(0)

    temp_dir = create_temp_dir(common_path)
    if temp_dir == None:
        temp_dir_path = path.join(common_path, ".lf")
        print(f"could not create temporary directory at \"{temp_dir_path}\"")
        exit(2)

    with Pool() as pool:
        temp_files = [
            path.join(temp_dir, f"{hex(abs(hash(file)))} - {path.basename(file)}")
            for file in files
        ]

        pool.map(move, files, temp_files)

        to_files = [common_path + file for file in renamed_files]

        move_tuple = lambda operation: move(operation[0], operation[1])
        while True:
            to_delete = (file for file in to_files if path.exists(file))
            skipped = prompt_deletion(to_delete, " already exists")

            if skipped == None:
                pool.map(move, temp_files, files)
                remove_temp_dir(temp_dir)
                exit(0)

            if len(skipped) == 0:
                break

            move_back = (
                (from_file, to_file)
                for from_file, to_file in zip(temp_files, to_files)
                if to_file in skipped
            )

            pool.map(move_tuple, move_back)

            keep = (
                (temp_file, to_file)
                for temp_file, to_file in zip(temp_files, to_files)
                if to_file not in skipped
            )

            temp_files = [file for file, _ in keep]
            to_files = [file for _, file in keep]

        pool.map(move, temp_files, to_files)

    remove_temp_dir(temp_dir)
