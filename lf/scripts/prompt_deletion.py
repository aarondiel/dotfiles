#!/bin/python

from sys import argv
from os import environ
from typing import Iterable
from utils import get_confirmation
from subprocess import PIPE, Popen
from concurrent.futures import ThreadPoolExecutor as Pool

def trash(file: str) -> bool:
    return Popen(["trash", file]).wait(32) == 0

def rm(file: str) -> bool:
    return Popen(["rm", "-rf", file]).wait(32) == 0

def prompt_delete(file: str) -> bool:
    response = get_confirmation(f"do you want to delete \"{file}\"?")

    if response:
        if environ.get("NO_TRASH") == "true":
            rm(file)
        else:
            trash(file)

    return response

def prompt_delete_all(files: list[str]) -> bool:
    for file in files:
        print(file)

    response = get_confirmation("do you want to delete these files?")

    if not response:
        return False

    with Pool() as pool:
        if environ.get("NO_TRASH") == "true":
            pool.map(rm, files)
        else:
            pool.map(trash, files)
            
    return True
    

def prompt_deletion(files: Iterable[str], after="") -> list[str] | None:
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
