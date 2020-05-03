extends Action

var MoveDirAction = g.import_action("MoveDirAction")
var MoveCommand = g.import_command("MoveCommand")

# Given at new()
var direction


func _init(dir: Vector2):
    direction = dir
    .set_type("ConsumeDirAction")


func perform(actor) -> Transaction:
    var xaction = Transaction.new()
    var result = _perform(actor, xaction)
    if result == false:
        xaction = null
    return xaction


# How do we determine if action is allowed on actor?
# - Can actor reject actions?
# - Do actions verify they can do X with actor attributes?

func _perform(actor, xaction) -> bool:
    var model = actor.model
    var new_pos = actor.get_grid_position() + direction

    if not model.is_valid_position(new_pos):
        return false

    var target = model.get_entity_at(new_pos)
    # If entity can move to location, return true
    if target == null:
        xaction.add_command(MoveCommand.new(actor, new_pos, actor.get_grid_position(), model))
        return true

    # XXX: There needs to be a special action implied when player
    #      runs into something. In RPG games it may be attack by default,
    #      in Sokoban it would be to push or move the object. This
    #      default collision action should be provided by the actor.
    
    var action
    if target.default_move_action == null:
        action = MoveDirAction.new(direction)
    else:
        action = target.default_move_action.new()
    
    if not target.action_allowed(action, actor):
        return false
        
    var result = action._perform(target, xaction)
    if result == true:
        xaction.add_command(MoveCommand.new(actor, new_pos, actor.get_grid_position(), model))
    
    return result
