extends Object

class_name Grid

var grid_array : Array
var last_updated : int
var _rows
var _cols

var empty : GridObject

func _init() -> void:
    empty = GridObject.new("Empty", Vector2(-1, -1), self, funcref(self, "empty_interact"))

func empty_interact(action_event) -> bool:
    # Nothing to do.
    return true

func is_valid_position(p1, p2 = null) -> bool:
    if p1 is Vector2 and p2 == null:
        if p1.x < 0 or p1.x > (_rows - 1) or p1.y < 0 or p1.y > (_cols - 1):
            return false
        return true
    elif p1 is int and p2 is int:
        if p1 < 0 or p1 > (_rows - 1) or p2 < 0 or p2 > (_cols - 1):
            return false
        return true
    push_error("Invalid parameters in Grid.is_valid_position()")
    return false # Required for static typed signature.

func get_cols():
    return _cols

func get_rows():
    return _rows

func init_empty_grid(rows : int, cols : int) -> void:
    last_updated += 1
    _rows = rows
    _cols = cols
    self.grid_array = []
    for x in cols:
        var col = []
        for y in rows:
            col.append(empty)
        self.grid_array.append(col)


func is_empty(p1, p2 = null) -> bool:
    if p1 is Vector2 and p2 == null:
        return self.grid_array[p1.x][p1.y] == empty
    elif p1 is int and p2 is int:
        return self.grid_array[p1][p2] == empty
    push_error("Invalid parameters in Grid.is_empty()")
    return false # Required for static typed signature.


func get_position(p1, p2 = null):
    if p1 is Vector2 and p2 == null:
        return self.grid_array[p1.x][p1.y]
    elif (p1 is int and p2 is int) or (p1 is float and p2 is float):
        return self.grid_array[p1][p2]
    push_error("Invalid parameters in Grid.get_position()")


func set_position(p1, p2, p3 = null) -> void:
    if p1 is Vector2 and p3 == null:
        self.grid_array[p1.x][p1.y] = p2
        last_updated = OS.get_ticks_usec()
        return

    if (p1 is int and p2 is int) or (p1 is float and p2 is float):
        self.grid_array[p1][p2] = p3
        last_updated = OS.get_ticks_usec()
        return

    push_error("Invalid parameters in Grid.set_position()")


func get_last_updated() -> int:
    return last_updated


func __move(obj_pos, new_pos, obj) -> bool:
    # Wipe the old position
    set_position(obj_pos, empty)
    obj.set_position(new_pos)
    # Add the new position
    set_position(new_pos, obj)
    return true

func _move(obj, obj_pos, new_pos, on_edge, push_func):
    if on_edge:
        # Invalid move
        print("invalid move")
        return false



#    var dest_contains = get_position(new_pos.x, new_pos.y)
#    if dest_contains == null:
#        push_error("Should never return null.")
#        return false
#
#    return dest_contains.incoming(obj, obj_pos, new_pos)
#
#        # Nothing there
#        # TODO: We could create a single instance of Null and reuse the reference. This way we could call incoming on all valid positions.
#        #print("nothing there")
#        #__move(obj_pos, new_pos, obj)
#        #return true
#    #else:
#    #    # Note: incoming() may have side effects
#    #    if dest_contains.incoming(obj, obj_pos, new_pos) == false:
#    #        pass
#
#    dest_contains
#
##        var dest_contains = get_position(new_pos.x, new_pos.y)
##        #print("Dest contains %s" % dest_contains)
##        if dest_contains != null:
##            if dest_contains.is_consumable():
##                set_position(dest_contains.get_position(), null)
##                obj.consume(dest_contains)
##            elif dest_contains.is_stackable():
##                if not obj.stack(dest_contains):
##                    return false
##            elif dest_contains.is_pushable():
##                if not self.call(push_func, dest_contains):
##                    return false
##            else:
##                return false
##
##        # Wipe the old position
##        set_position(obj_pos, null)
##        obj.set_position(new_pos)
##        # Add the new position
##        set_position(new_pos, obj)
##        return true
#    return false


func move_up(obj : GridObject) -> bool:
    var obj_pos = obj.get_position()
    var on_edge: bool = obj_pos.y == 0
    var new_pos = Vector2(obj_pos.x, obj_pos.y - 1)
    var push_func = "move_up"

    return _move(obj, obj_pos, new_pos, on_edge, push_func)


func move_down(obj : GridObject) -> bool:
    var obj_pos = obj.get_position()
    var on_edge: bool = obj_pos.y == _rows - 1
    var new_pos = Vector2(obj_pos.x, obj_pos.y + 1)
    var push_func = "move_down"

    return _move(obj, obj_pos, new_pos, on_edge, push_func)


func move_left(obj : GridObject):
    var obj_pos = obj.get_position()
    var on_edge: bool = obj_pos.x == 0
    var new_pos = Vector2(obj_pos.x - 1, obj_pos.y)
    var push_func = "move_left"

    return _move(obj, obj_pos, new_pos, on_edge, push_func)


func move_right(obj : GridObject):
    var obj_pos = obj.get_position()
    var on_edge: bool = obj_pos.x == _cols - 1
    var new_pos = Vector2(obj_pos.x + 1, obj_pos.y)
    var push_func = "move_right"

    return _move(obj, obj_pos, new_pos, on_edge, push_func)

