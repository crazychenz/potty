extends Action

# Given at new()
var direction
var model

func _init(dir: Vector2, model_param):
    direction = dir
    model = model_param

func perform(actor) -> Transaction:
    var xaction = Transaction.new()
    var result = _perform(actor, xaction)
    if result == false:
        xaction = null
    return xaction

func _perform(actor, xaction) -> bool:
    var new_pos = actor.get_grid_position() + direction

    if not model.is_valid_position(new_pos):
        return false

    var target = model.get_entity_at(new_pos)
    # If entity can move to location, return true
    if target == null:
        xaction.add_command(MoveCommand.new(actor, new_pos, model))
        return true

    # If there is an object in the way, see if we can
    # forward the same type of action onto it.
    var action = c.MoveDirAction.new(direction, model)
    var result = action._perform(target, xaction)
    if result == true:
        xaction.add_command(MoveCommand.new(actor, new_pos, model))
    return result



#func move_action_event(incoming_event : ActionEvent) -> bool:
#    if incoming_event is ActionEventMove:
#        var new_pos = incoming_event.get_direction() + get_position()
#        if not _grid.is_valid_position(new_pos):
#            # Invalid position.
#            return false
#
#        var direction = incoming_event.get_direction()
#        var target_object = _grid.get_position(new_pos)
#        var outgoing_event : ActionEvent = ActionEventMove.new(self, direction)
#
#        if target_object != _grid.empty and \
#            not target_object.handle_action(outgoing_event):
#            return false
#        #outgoing_event._fini()
#        #outgoing_event.free()
#
#        # Now that we're prepared to move, prepare to pull if applicable.
#        var pulled_object = null
#        var outgoing_event2 : ActionEvent
#        if incoming_event.is_pulling():
#            var rot_dir = direction.rotated(deg2rad(180)).round()
#            var pos = get_position()
#            var pull_pos = rot_dir + get_position()
#            if _grid.is_valid_position(pull_pos):
#                pulled_object = _grid.get_position(pull_pos)
#                outgoing_event2 = ActionEventMove.new(self, direction)
#
#        # Perform the move.
#        _grid.__move(get_position(), new_pos, self)
#
#        # Perform the pull.
#        if pulled_object != null and incoming_event.is_pulling():
#            pulled_object.handle_action(outgoing_event2)
#            #outgoing_event2._fini()
#            #outgoing_event2.free()
##        else:
##            for y in range(8):
##                var line_str = ""
##                for x in range(8):
##                    line_str += "%s " % _grid.get_position(Vector2(x, y))._type[0]
##                print(line_str)
##            print("\n")
#
#        #print("%s Reflected %s" % [direction, direction.rotated(deg2rad(180))])
#
#
#        return true
#
#    # Couldn't handle the event.
#    return false