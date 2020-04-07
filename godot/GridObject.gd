extends Node

class_name GridObject

signal game_over

var _position : Vector2
var _type : String
var _grid
var preaction
var _interact

var deleteme : Vector2

func _init(type, position, grid, interact = null) -> void:
    _type = type
    _position = position
    _grid = grid

    if interact != null:
        _interact = interact
    else:
        _interact = funcref(self, "move_action_event")


func set_interact(interact):
    _interact = interact


# Just a helper function.
func handle_action(action_event) -> bool:
    return _interact.call_func(action_event)


# Handler for consumable objects.
func consumable_food_interact(action_event) -> bool:
    var actor = action_event.get_object()
    print("%s consumed %s" % [actor.get_type(), get_type()])

    # Note: This isn't ideal, but its quick.
    if actor.get_type() == "Baby":
        LevelState.increase_bladder(50)
    return true


# Handler for consumable objects.
func consumable_toy_interact(action_event) -> bool:
    var actor = action_event.get_object()
    print("%s consumed %s" % [actor.get_type(), get_type()])

    # Note: This isn't ideal, but its quick.
    if actor.get_type() == "Baby":
        LevelState.increase_happiness(50)
    return true


# Handler for immovable objects.
func static_interact(action_event) -> bool:
    # Allow nothing.
    return false


# Handler for potty object.
func potty_interact(action_event):
    var actor = action_event.get_object()
    if actor.get_type() != "Baby":
        return false
    LevelState.level_complete()
    return true


func baby_interact(incoming_event : ActionEvent) -> bool:
    var ret = move_action_event(incoming_event)
    if ret:
        # Decrease baby happiness.
        LevelState.decrease_happiness(10)
    return ret


func move_action_event(incoming_event : ActionEvent) -> bool:
    if incoming_event is ActionEventMove:
        var new_pos = incoming_event.get_direction() + get_position()
        if not _grid.is_valid_position(new_pos):
            # Invalid position.
            return false

        var direction = incoming_event.get_direction()
        var target_object = _grid.get_position(new_pos)
        var outgoing_event : ActionEvent = ActionEventMove.new(self, direction)

        if target_object != _grid.empty and \
            not target_object.handle_action(outgoing_event):
            return false

        # Now that we're prepared to move, prepare to pull if applicable.
        var pulled_object = null
        var outgoing_event2 : ActionEvent
        if incoming_event.is_pulling():
            var rot_dir = direction.rotated(deg2rad(180)).round()
            var pos = get_position()
            var pull_pos = rot_dir + get_position()
            if _grid.is_valid_position(pull_pos):
                pulled_object = _grid.get_position(pull_pos)
                outgoing_event2 = ActionEventMove.new(self, direction)

        # Perform the move.
        _grid.__move(get_position(), new_pos, self)

        # Perform the pull.
        if pulled_object != null and incoming_event.is_pulling():
            pulled_object.handle_action(outgoing_event2)
#        else:
#            for y in range(8):
#                var line_str = ""
#                for x in range(8):
#                    line_str += "%s " % _grid.get_position(Vector2(x, y))._type[0]
#                print(line_str)
#            print("\n")

        #print("%s Reflected %s" % [direction, direction.rotated(deg2rad(180))])


        return true

    # Couldn't handle the event.
    return false


func set_position(position: Vector2):
    _position = position


func get_position() -> Vector2:
    return _position


func set_type(type: String):
    _type = type


func get_type() -> String:
    return _type
