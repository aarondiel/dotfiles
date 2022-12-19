#!/bin/python

from subprocess import PIPE, Popen
from sys import argv
from concurrent.futures import ThreadPoolExecutor as Pool

def trash(file: str) -> bool:
    return Popen(["trash", file]).wait(32) == 0

def prompt_delete(file: str) -> bool:
    response = Popen(
        ["gum", "confirm", f"do you want to delete \"{file}\"?"],
        stdin=PIPE
    ).wait()

    if response != 0:
        return False

    trash(file)

    return True

def prompt_delete_all(files: list[str]) -> bool:
    for file in files:
        print(file)

    response = Popen(
        ["gum", "confirm", "do you want to delete these files?"],
        stdout=PIPE,
        stdin=PIPE
    ).wait()

    if response != 0:
        return False

    with Pool() as pool:
        pool.map(trash, files)
        
    return True
    

def prompt_deletion(files: list[str], after="") -> list[str] | None:
    skipped = []
    to_delete = []
    delete_all = False

    for file in files:
        if delete_all:
            to_delete.append(file)
            continue

        print(f"\"{file}\"{after}")

        response, _ = Popen(
            ["gum", "choose", "delete", "skip", "delete all", "exit"],
            stdout=PIPE,
            stdin=PIPE,
            text=True
        ).communicate()

        response = response.strip()

        if response == "delete":
            to_delete.append(file)
        elif response == "delete all":
            to_delete.append(file)
            delete_all = True
        elif response == "exit":
            return None
        else:
            skipped.append(file)

    with Pool() as pool:
        pool.map(trash, to_delete)

    return skipped


if __name__ == "__main__":
    files: list[str] = argv[1].splitlines()

    if len(files) == 1:
        prompt_delete(files[0])
    else:
        prompt_delete_all(files)
