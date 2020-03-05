extends Object

#class_name Grid

var grid_array : Array
var last_updated : int
var _rows
var _cols

func init_empty_grid(rows : int, cols : int) -> void:
	last_updated += 1
	_rows = rows
	_cols = cols
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

#static func create_empty_grid(rows : int, cols : int) -> Grid:
#    var obj := Grid.new()
#    obj.init_empty_grid(rows, cols)
#    return obj



func move_up(obj : GridObject) -> bool:
	var obj_pos = obj.get_position()
	if obj_pos.y > 0:
		var dest_contains = get_position(obj_pos.x, obj_pos.y - 1)
		#print("Dest contains %s" % dest_contains)
		if dest_contains != null and dest_contains.is_pushable():
			if not move_up(dest_contains):
				return false

		# Wipe the old position
		set_position(obj_pos, null)
		obj_pos.y -= 1
		obj.set_position(obj_pos)
		# Add the new position
		set_position(obj_pos, obj)
		return true
	return false

func move_down(obj : GridObject) -> bool:
	var obj_pos = obj.get_position()
	if obj_pos.y < _rows - 1:
		var dest_contains = get_position(obj_pos.x, obj_pos.y + 1)
		#print("Dest contains %s" % dest_contains)
		if dest_contains != null and dest_contains.is_pushable():
			if not move_down(dest_contains):
				return false

		# Wipe the old position
		set_position(obj_pos, null)
		obj_pos.y += 1
		obj.set_position(obj_pos)
		# Add the new position
		set_position(obj_pos, obj)
		return true
	return false
		
func move_left(obj : GridObject):
	var obj_pos = obj.get_position()
	if obj_pos.x > 0:
		var dest_contains = get_position(obj_pos.x - 1, obj_pos.y)
		#print("Dest contains %s" % dest_contains)
		if dest_contains != null and dest_contains.is_pushable():
			if not move_left(dest_contains):
				return false

		# Wipe the old position
		set_position(obj_pos, null)
		obj_pos.x -= 1
		obj.set_position(obj_pos)
		# Add the new position
		set_position(obj_pos, obj)
		return true
	return false


func move_right(obj : GridObject):
	var obj_pos = obj.get_position()
	if obj_pos.x < _cols - 1:
		var dest_contains = get_position(obj_pos.x + 1, obj_pos.y)
		#print("Dest contains %s" % dest_contains)
		if dest_contains != null and dest_contains.is_pushable():
			if not move_right(dest_contains):
				return false

		# Wipe the old position
		set_position(obj_pos, null)
		obj_pos.x += 1
		obj.set_position(obj_pos)
		# Add the new position
		set_position(obj_pos, obj)
		return true
	return false
