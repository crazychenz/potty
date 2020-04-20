extends Action

class_name MoveAction

var direction
var model

func _init(dir, model_param):
    direction = dir
    model = model_param

func perform(actor) -> Transaction:
    var xaction = Transaction.new()

    #var pos = actor.pos + direction
		# Check if there is an object, wall, etc
		# If wall, return a do nothing return
		# If nothing, return a transaction of 1 action
        # If something(s) that can be pushed, return transaction

    return xaction
