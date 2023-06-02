from subprocess import Popen, PIPE
import os

def get_command_output(*args: str) -> str:
    command = list(args)
    return Popen(command, text=True, stdout=PIPE) \
        .communicate()[0] \
        .strip()

def get_confirmation(message: str):
    response = Popen([ "gum", "confirm", message ]).wait()

    return response == 0

def file_exists(file: str) -> bool:
    """
    test if file exists.
    if the file exists prompts the user if they want to delete that file.

    returns `True` if the file exists and the user does not want to delete it,
    `False` otherwise
    """

    if not os.path.exists(file):
        return False

    response = get_confirmation(
        f"file {file} already exists, do you want to delete it?"
    )

    if response:
        os.remove(file)
        return False

    return True
