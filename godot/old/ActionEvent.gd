extends Object

class_name ActionEvent

var _type = "NoAction"

func _init(type):
    set_type(type)

func get_type() -> String:
    return _type

func set_type(type : String):
    _type = type
