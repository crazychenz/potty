extends Object

#class_name Grid

var grid_array : Array
var last_updated : int

func init_empty_grid(rows : int, cols : int) -> void:
    self.grid_array = []
    for x in cols:
        var col = []
        for y in rows:
            col.append(null)
        self.grid_array.append(col)

func is_empty(p1, p2 = null) -> bool:
    if p1 is Vector2 and p2 == null:
        return self.grid_array[p1.x][p1.y] == null
    elif p1 is int and p2 is int:
        return self.grid_array[p1][p2] == null
    push_error("Invalid parameters in Grid.is_empty()")
    return false # Required for static typed signature.

func get_position(p1, p2 = null):
    if p1 is Vector2 and p2 == null:
        return self.grid_array[p1.x][p1.y]
    elif p1 is int and p2 is int:
        return self.grid_array[p1][p2]
    push_error("Invalid parameters in Grid.get_position()")

func set_position(p1, p2, p3 = null) -> void:
    if p1 is Vector2 and p3 == null:
        self.grid_array[p1.x][p1.y] = p2
        last_updated = OS.get_ticks_usec()
    elif p1 is int and p2 is int:
        self.grid_array[p1][p2] = p3
        last_updated = OS.get_ticks_usec()
    push_error("Invalid parameters in Grid.set_position()")

func get_last_updated() -> int:
    return last_updated

#static func create_empty_grid(rows : int, cols : int) -> Grid:
#    var obj := Grid.new()
#    obj.init_empty_grid(rows, cols)
#    return obj
