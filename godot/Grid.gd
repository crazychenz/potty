extends Reference

class_name Grid

# This must only be called once a complete transaction has been applied
#signal updated()

var grid_array : Dictionary = {}
var _rows
var _cols


func _fini() -> void:
    for x in range(0, _cols):
        for y in range(0, _rows):
            if is_instance_valid(grid_array[x][y]):
                grid_array[x][y].call_deferred("free")
                grid_array[x][y] = null

# Debug function for troubleshooting movement
func as_string() -> String:
    var state_string = ""
    for y in range(0, _rows):
        for x in range(0, _cols):
            if grid_array[x][y] == null:
                state_string += ". "
            else:
                state_string += "%s " % grid_array[x][y].type[0]
        state_string += "\n"
    state_string += "\n"
    return state_string

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
    if obj != null:
        obj.grid_position = Vector2(x, y)


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
 

