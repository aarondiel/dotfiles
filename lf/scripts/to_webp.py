#!/bin/python

from sys import argv
from os import path
from subprocess import DEVNULL, PIPE, Popen
from prompt_deletion import prompt_deletion, trash
from concurrent.futures import ThreadPoolExecutor as Pool

def get_mime_type(file: str) -> str:
    return Popen(
        ["file", "--brief", "--mime-type", file],
        stdout=PIPE,
        text=True
    ).communicate()[0]

def filter_images(file: str) -> bool:
    return get_mime_type(file).startswith("image")

def to_operations(file: str) -> tuple[str, str]:
    to = path.splitext(file)[0]
    to += ".webp"

    return (file, to)

def print_operations(operations: list[tuple[str, str]]) -> None:
    for (from_file, to_file) in operations:
        print(f"{from_file} -> {to_file}")

def get_confirmation() -> bool:
    return Popen(
        ["gum", "confirm", "do you want to convert these files?"],
        stdout=PIPE,
        stdin=PIPE
    ).wait() == 0


def convert(from_file: str, to_file: str):
    status = Popen(
        ["cwebp", "-q", "100", from_file, "-o", to_file],
        stdout=DEVNULL,
        stderr=DEVNULL
    ).wait(32)

    if status == 0:
        trash(from_file)

def convert_files(operations: list[tuple[str, str]]):
    to_delete = [
        to_file
        for (_, to_file) in operations
        if path.exists(to_file)
    ]

    skipped = prompt_deletion(to_delete, after=" already exists")

    if skipped == None:
        return

    new_operations: filter[tuple[str, str]] = filter(
        lambda operation: operation[1] not in skipped,
        operations
    )

    tuple_convert = lambda operation: convert(operation[0], operation[1])

    with Pool() as pool:
        pool.map(tuple_convert, new_operations)

if __name__ == "__main__":
    files: list[str] = argv[1].splitlines()
    filtered = filter(filter_images, files)
    operations = list(map(to_operations, filtered))

    print_operations(operations)

    if not get_confirmation():
        exit(0)

    convert_files(operations)
