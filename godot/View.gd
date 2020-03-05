extends Node2D

onready var model = get_parent()

onready var board_offset := Vector2(50, 50)

func create_sprite_with_texture(texture) -> Sprite:
	var obj = Sprite.new()
	obj.texture = texture
	obj.set_scale(Vector2(0.5, 0.5))
	return obj

func add_position(x : int, y : int, obj_type : String) -> void:
	var obj

	match obj_type:
		model.TYPE_EMPTY:
			obj = create_sprite_with_texture(load("res://assets/tiles/grass.png"))
		model.TYPE_NPC:
			obj = create_sprite_with_texture(load("res://assets/white.png"))
		model.TYPE_BRICKWALL:
			obj = create_sprite_with_texture(load("res://assets/tiles/brickredgray.png"))
		model.TYPE_PUSHABLE_DUCK:
			obj = create_sprite_with_texture(load("res://assets/animals/Duck.png"))
		_:
			push_warning("Unknown object added to viewer.")
			# do nothing
			return

	obj.set_position(Vector2((x * 64), (y * 64)) + board_offset)
	add_child(obj)

func update_view() -> void:
	# Wipe all the old stuff
	# TODO: Consider using a pool to limit allocations?
	for child in get_children():
		remove_child(child)
		child.queue_free()

	for x in range(model.GRID_COLS):
		for y in range(model.GRID_ROWS):
			if not model.grid.is_empty(x, y):
				var obj = model.grid.get_position(x, y)
				add_position(x, y, obj.get_type())
			else:
				add_position(x, y, model.TYPE_EMPTY)





