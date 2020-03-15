extends Node

class_name GridObject

signal game_over

var _position : Vector2
var _type : String
var _grid
var preaction
var _interact

func _init(type, position, grid, interact = null) -> void:
    _type = type
    _position = position
    _grid = grid

    if interact != null:
        _interact = interact
    else:
        _interact = funcref(self, "default_handle_action_event")

func set_interact(interact):
    _interact = interact

# Handler for consumable objects.
func consumable_interact(action_event) -> bool:
    var actor = action_event.get_object()
    print("%s consumed %s" % [actor.get_type(), get_type()])
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
    emit_signal("game_over")
    return true

func default_handle_action_event(incoming_event : ActionEvent) -> bool:
    if incoming_event is ActionEventMove:
        var new_pos = incoming_event.get_direction() + get_position()
        if not _grid.is_valid_position(new_pos):
            # Invalid position.
            return false

        var direction = incoming_event.get_direction()
        var target_object = _grid.get_position(new_pos)
        var outgoing_event : ActionEvent
        outgoing_event = ActionEventMove.new(self, direction)
        if target_object == _grid.empty or target_object._interact.call_func(outgoing_event):
            _grid.__move(get_position(), new_pos, self)
            # Move successful.
            return true
        # Something stopped the move from happening.
        return false

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
