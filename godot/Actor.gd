extends Reference

class_name Actor

var grid_position : Vector2 setget set_grid_position, get_grid_position
var type : String setget set_type, get_type

func _init(position : Vector2, typ : String = "unknown"):
    grid_position = position
    type = typ


func set_grid_position(position: Vector2):
    grid_position = position


func get_grid_position() -> Vector2:
    return grid_position


func set_type(actor_type: String):
    type = actor_type


func get_type() -> String:
    return type


func pretend(action: Action) -> Transaction:
    return action.perform(self)