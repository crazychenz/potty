extends Node

class_name GridObject

var position : Vector2
var _type : String
var pushable : bool

func set_pushable(v: bool = true):
	pushable = v

func is_pushable() -> bool:
	return pushable

func set_position(pos: Vector2):
	position = pos

func get_position() -> Vector2:
	return position

func set_type(type: String):
	_type = type

func get_type() -> String:
	return _type
