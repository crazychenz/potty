extends Reference

class_name Actor

var MoveDirAction = g.import_action("MoveDirAction")

var default_move_action = MoveDirAction

var grid_position : Vector2 setget set_grid_position, get_grid_position
var type : String setget set_type, get_type
var model

func _init(position : Vector2, typ : String = "Actor", model_param = null):
    grid_position = position
    type = typ
    model = model_param


func set_grid_position(position: Vector2):
    grid_position = position


func get_grid_position() -> Vector2:
    return grid_position


func set_type(actor_type: String):
    type = actor_type


func get_type() -> String:
    return type


func perform(action) -> Transaction:
    return action.perform(self)


# Functions can determine the best way to manage their
# own action permissions. More simple solutions might
# include a blacklist or whitelist. More complex solutions
# may be based on attribute access, although that might
# not be a wise design decision for GDScript.
#
# If actor is null, the action isn't triggered by an
# actor. If actor is set, they are the source actor
# triggering the action.
func action_allowed(action, actor = null) -> bool:
    return true
