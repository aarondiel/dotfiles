#!/bin/python

from sys import argv
from os import environ, system, path, popen, remove, makedirs
from shutil import move
from tempfile import NamedTemporaryFile, TemporaryDirectory

def remove_common_paths(files: list[str]) -> str:
    longest_common_path: list[str] = files[0].split("/")[:-1]

    for file in files[1:]:
        split_path: list[str] = file.split("/")[:-1]

        minimum_length = min(len(longest_common_path), len(split_path))

        for i in range(minimum_length):
            if longest_common_path[i] == split_path[i]:
                continue

            longest_common_path = longest_common_path[:i]
            break

    return "/".join(longest_common_path) + "/"

def get_new_filenames(filenames: list[str]) -> list[str]:
    with NamedTemporaryFile(mode="w+") as temp_file:
        temp_file.write("\n".join(filenames))
        temp_file.flush()

        editor = environ["EDITOR"]
        if editor == None:
            editor = "vi"

        cmd = editor + " '" + temp_file.name + "'"
        system(cmd)

        temp_file.seek(0)
        new_filenames = [
            line.removesuffix("\n")
            for line in temp_file.readlines()
        ]

        return new_filenames

def remove_file(file_path: str, overwrite_all: bool) -> str:
    if overwrite_all:
        return "yes"

    print(f"file \"{file_path}\" already exists, overwrite it?")
    return popen("gum choose 'yes' 'no' 'overwrite all' 'exit'").read()

def restore_original_files(move_operations: list[tuple[str, str, str]]) -> None:
    for from_file, temp_file, _ in move_operations:
        move(temp_file, from_file)

def remove_existing_paths(
    move_operations: list[tuple[str, str, str]]
) -> list[tuple[str, str, str]] | None:
    result = []
    to_remove = []

    overwrite_all = False
    move_files_back = False

    for from_path, temp_path, to_path in move_operations:
        if not path.exists(to_path):
            result.append((from_path, temp_path, to_path))
            continue

        response = remove_file(to_path, overwrite_all)

        if response == "yes":
            result.append((from_path, temp_path, to_path))
            to_remove.append(to_path)
        elif response == "no":
            pass
        elif response == "overwrite all":
            result.append((from_path, temp_path, to_path))
            to_remove.append(to_path)
            overwrite_all = True
        elif response == "exit":
            move_files_back = True

    if move_files_back:
        restore_original_files(move_operations)
        return None

    for file in to_remove:
        remove(file)

    return result

if __name__ == "__main__":
    files: list[str] = argv[1].splitlines()
    longest_common_path = remove_common_paths(files)
    filenames = [ file.removeprefix(longest_common_path) for file in files ]
    new_filenames = get_new_filenames(filenames)

    if len(filenames) != len(set(new_filenames)):
        print("unmatched number of filenames")


    with TemporaryDirectory() as temp_dir:
        overwrite_all = False

        move_operations: list[tuple[str, str, str]] | None = [ (
            longest_common_path + original_name,
            temp_dir + "/" + new_name,
            longest_common_path + new_name
        ) for original_name, new_name in zip(filenames, new_filenames) ]

        for from_path, temp_path, _ in move_operations:
            makedirs(path.dirname(temp_path), exist_ok=True)
            move(from_path, temp_path) 

        move_operations = remove_existing_paths(move_operations)
        if move_operations == None:
            exit(0)
        
        for _, temp_path, to_path in move_operations:
            move(temp_path, to_path)
