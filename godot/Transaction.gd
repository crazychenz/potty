extends Object

class_name Transaction

"""
A transaction object is an object that contains a group of Actions
that must all be completed/committed at once or all fail at once.
"""

var actions = []

func add_action(action):
    actions.append(action)
