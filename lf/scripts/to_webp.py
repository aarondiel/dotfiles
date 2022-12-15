#!/bin/python

from sys import argv
from os import popen, path
from typing import Optional
from multiprocessing import Pool

def get_mime_type(file: str) -> str:
    return popen(f"file --brief --mime-type '{file}'").read()

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
    prompt = popen("gum confirm 'do you want to convert these files?'")

    return prompt.close() == None

def prompt_deletion(files: list[str]) -> Optional[list[str]]:
    skipped = []
    to_delete = []
    delete_all = False

    for file in files:
        if delete_all:
            to_delete.append(file)
            continue

        response = popen("gum choose 'yes' 'skip' 'delete all' 'exit'").read()

        if response == "yes":
            to_delete.append(file)
        elif response == "delete_all":
            to_delete.append(file)
            delete_all = True
        elif response == "exit":
            return None
        else:
            skipped.append(file)

    for file in to_delete:
        popen(f"trash '{file}'")

    return skipped
        

def convert(from_file: str, to_file: str):
    status = popen(f"cwebp -q 100 '{from_file}' -o '{to_file}'") \
        .close()

    if status == None:
        popen(f"trash '{from_file}'")

def convert_files(operations: list[tuple[str, str]]):
    to_delete = [
        to_file
        for (_, to_file) in operations
        if path.exists(to_file)
    ]

    skipped = prompt_deletion(to_delete)

    if skipped == None:
        return

    new_operations: filter[tuple[str, str]] = filter(
        lambda operation: operation[1] not in skipped,
        operations
    )

    with Pool(processes=4) as pool:
        pool.starmap(convert, new_operations)

if __name__ == "__main__":
    files: list[str] = argv[1].splitlines()
    filtered = filter(filter_images, files)
    operations = list(map(to_operations, filtered))

    print_operations(operations)

    if not get_confirmation():
        exit(0)

    convert_files(operations)
