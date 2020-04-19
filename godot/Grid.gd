extends Object

class_name Grid

# This must only be called once a complete transaction has been applied
signal updated()

var grid_array : Dictionary = {}
var _rows
var _cols


func _fini() -> void:
    for x in range(0, _cols):
        for y in range(0, _rows):
            if is_instance_valid(grid_array[x][y]):
                grid_array[x][y].queue_free()
                grid_array[x][y] = null


func is_valid_coords(p1: int, p2 : int) -> bool:
    return not (p1 < 0 or p1 > (_rows - 1) or p2 < 0 or p2 > (_cols - 1))


func is_valid_position(v : Vector2) -> bool:
    return not (v.x < 0 or v.x > (_rows - 1) or v.y < 0 or v.y > (_cols - 1))


func get_cols():
    return _cols


func get_rows():
    return _rows


func init_empty_grid(rows : int, cols : int) -> void:
    _rows = rows
    _cols = cols
    for x in range(0, cols):
        grid_array[x] = {}
        for y in range(0, rows):
            grid_array[x][y] = null


func is_empty_position(v : Vector2) -> bool:
    return self.grid_array[int(v.x)][int(v.y)] == null


func is_empty_coords(x: int, y: int):
    return self.grid_array[int(x)][int(y)] == null


func get_coords(x: int, y: int):
    return grid_array[int(x)][int(y)]


func get_position(v : Vector2):
    return grid_array[int(v.x)][int(v.y)]


func _set_coords(x: int, y: int, obj):
    self.grid_array[int(x)][int(y)] = obj


func set_coords(x: int, y: int, obj):
    # Uncomment these lines to limit the type of obj to null and GridObject
    #if not (obj == null and obj is GridObject):
    #    push_error("Invalid obj parameter. %s" % obj)
    var grid_slot = self.grid_array[int(x)][int(y)]
    if grid_slot != null and grid_slot is Object and is_instance_valid(grid_slot):
        self.grid_array[int(x)][int(y)].queue_free()
    _set_coords(x, y, obj)


func set_position(v: Vector2, obj):
    set_coords(v.x, v.y, obj)
 

## TODO: This is so ugly.
#func __move(obj_pos, new_pos, obj, new_obj = empty) -> bool:
#    var old : GridObject
#    if new_obj != empty:
#        old = get_position(new_pos)
#    else:
#        old = new_obj
#
#    old.set_position(obj_pos)
#    _set_position(obj_pos, old)
#
#    obj.set_position(new_pos)
#    _set_position(new_pos, obj)
#
#    return true
#
#
#func _move(obj, obj_pos, new_pos, on_edge, push_func):
#    if on_edge:
#        # Invalid move
#        print("invalid move")
#        return false



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


#func move_up(obj : GridObject) -> bool:
#    var obj_pos = obj.get_position()
#    var on_edge: bool = obj_pos.y == 0
#    var new_pos = Vector2(obj_pos.x, obj_pos.y - 1)
#    var push_func = "move_up"
#
#    return _move(obj, obj_pos, new_pos, on_edge, push_func)
#
#
#func move_down(obj : GridObject) -> bool:
#    var obj_pos = obj.get_position()
#    var on_edge: bool = obj_pos.y == _rows - 1
#    var new_pos = Vector2(obj_pos.x, obj_pos.y + 1)
#    var push_func = "move_down"
#
#    return _move(obj, obj_pos, new_pos, on_edge, push_func)
#
#
#func move_left(obj : GridObject):
#    var obj_pos = obj.get_position()
#    var on_edge: bool = obj_pos.x == 0
#    var new_pos = Vector2(obj_pos.x - 1, obj_pos.y)
#    var push_func = "move_left"
#
#    return _move(obj, obj_pos, new_pos, on_edge, push_func)
#
#
#func move_right(obj : GridObject):
#    var obj_pos = obj.get_position()
#    var on_edge: bool = obj_pos.x == _cols - 1
#    var new_pos = Vector2(obj_pos.x + 1, obj_pos.y)
#    var push_func = "move_right"
#
#    return _move(obj, obj_pos, new_pos, on_edge, push_func)
#
