from subprocess import Popen

def get_confirmation(message: str):
    response = Popen([ "gum", "confirm", message ]).wait()

    return response == 0
