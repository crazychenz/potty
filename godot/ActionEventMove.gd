extends ActionEvent

class_name ActionEventMove

const RIGHT = Vector2(1, 0)
const LEFT = Vector2(-1, 0)
const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)

var _object
var _direction : Vector2

func _init(object, direction).("move"):
    set_object(object)
    set_direction(direction)

func set_object(object):
    _object = object

func get_object():
    return _object

func set_direction(direction):
    _direction = direction

func get_direction() -> Vector2:
    return _direction


