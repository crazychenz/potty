extends Reference

class_name Action

var type : String

func set_type(type_param : String):
    type = type_param

"""
Public entrypoint for initial Actions.
"""
func perform(p1) -> Transaction:
    return null

"""
Proviate action performer that is used internally
by Actions to generate transactions.
"""
func _perform(actor, xaction) -> bool:
    return false
