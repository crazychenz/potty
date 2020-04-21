extends Command

# Given at new()
var destination : Vector2

# Given later
#var model : Model
var actor : Actor
var model


func _init(actor_param, dest: Vector2, model_param):
    destination = dest
    actor = actor_param
    model = model_param


func perform():
    model.grid._set_coords(destination.x, destination.y, actor)

