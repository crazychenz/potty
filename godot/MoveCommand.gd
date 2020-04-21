extends Command

class_name MoveCommand

# Given at new()
var destination : Vector2

# Given later
var model : Model
var actor : Actor


func _init(actor_param, dest: Vector2, model_param):
    actor = actor_param
    model = model_param
    destination = dest


func perform():
    model.grid._set_coords(destination.x, destination.y, actor)

