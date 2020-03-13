extends Node

class_name GridObject

signal game_over

var position : Vector2
var _type : String

"""Pushable object can be pushed."""
var pushable : bool = false
"""Movable objects can get pushed ontop of stackable objects"""
var stackable : bool = false
"""Movable objects will consume objects that are consumable"""
var consumable : bool = false

func set_pushable(v: bool = true):
    pushable = v

func is_pushable() -> bool:
    return pushable

func set_stackable(v: bool = true):
    stackable = v

func is_stackable() -> bool:
    return stackable

#Should this be StackableObject?
func stack(obj: GridObject) -> bool:
    if self.get_type() != "Baby":
        return false
    print("%s stacked on %s" % [obj.get_type(), self.get_type()])
    print("GAME OVER")
    emit_signal("game_over")
    return true

func set_consumable(v: bool = true):
    consumable = v

func is_consumable() -> bool:
    return consumable

# Should this be a ConsumableObject?
func consume(obj: GridObject):
    print("%s consumed %s" % [self.get_type(), obj.get_type()])
    # For now, just delete the object.
    obj.queue_free()
    return

func set_position(pos: Vector2):
    position = pos

func get_position() -> Vector2:
    return position

func set_type(type: String):
    _type = type

func get_type() -> String:
    return _type
