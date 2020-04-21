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

    var new_pos = actor.get_grid_position() + direction

    var target = model.get_entity_at(new_pos)
    if target == null:
        xaction.append(MoveAction)

		# Check if there is an object, wall, etc
		# If wall, return a do nothing return
		# If nothing, return a transaction of 1 action
        # If something(s) that can be pushed, return transaction

    return xaction