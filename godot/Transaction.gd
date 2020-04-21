extends Reference

class_name Transaction

"""
A transaction object is an object that contains a group of Actions
that must all be completed/committed at once or all fail at once.
"""

var commands = []

func add_command(command):
    commands.append(command)

func size() -> int:
    return len(commands)