extends Reference

class_name MoveRequest

# Given at new()
var direction

# Given later
var model
var actor

func _init(dir: Vector2):
    direction = dir

func perform(actor) -> Transaction:
    var xaction = Transaction.new()
    _perform(actor, xaction)
    return xaction

func _perform(actor, xaction) -> bool:
    var new_pos = actor.get_grid_position() + direction

    var target = model.get_entity_at(new_pos)
    # If entity can move to location, return true
    if target == null:
        xaction.append(MoveTo.new(new_pos))
        return true

    # Check if there is an object, wall, etc
    if target.can
    # If wall, return a do nothing return
    # If something(s) that can be pushed, return transaction