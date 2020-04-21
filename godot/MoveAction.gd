extends Action

class_name MoveAction

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
        xaction.append(self)

        # Check if there is an object, wall, etc
        # If wall, return a do nothing return
        # If nothing, return a transaction of 1 action
        # If something(s) that can be pushed, return transaction

    return xaction




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
