extends Node2D

var controller
var presentation

func ready(presentation):
    pass

func controller_ready(controller):
    self.controller = controller

    


    # TODO: Setup local signals



#
#
#
#
#
#
#
#onready var model = get_parent()
#
#
##func _fini():
##	for child in get_children():
##		remove_child(child)
##		print("Leaked Freeing %s" % child)
##		child.queue_free()
##
##func _notification(what):
##	if what == NOTIFICATION_PREDELETE:
##		_fini()
#
#func _ready():
#	LevelState.connect("game_over", self, "_on_game_over")
#	LevelState.connect("level_complete", self, "_on_level_complete")
#	LevelState.connect("happiness_gone", self, "_on_LevelState_happiness_gone")
#	LevelState.connect("bladder_full", self, "_on_LevelState_bladder_full")
#
#
#func _on_LevelState_happiness_gone():
#	# TODO: Do some animation?
#	LevelState.game_over()
#
#
#func _on_LevelState_bladder_full():
#	# TODO: Do some animation?
#	LevelState.game_over()
#
#
#func _on_game_over():
#	set_visible(false)
#	get_parent().get_node("UIControl/GameOverPanel").set_visible(true)
#
#
#func _on_level_complete():
#	set_visible(false)
#	get_parent().get_node("UIControl/GameOverPanel").set_visible(true)
#
#
#func create_sprite_with_texture(texture) -> Sprite:
#	var obj = Sprite.new()
#	obj.texture = texture
#	obj.set_scale(Vector2(0.5, 0.5))
#	return obj
#
#
#func add_position(x : int, y : int, obj_type : String) -> void:
#	var obj
#
#	match obj_type:
#		model.TYPE_EMPTY:
#			obj = create_sprite_with_texture(load("res://assets/tiles/grass.png"))
#		model.TYPE_NPC:
#			obj = create_sprite_with_texture(load("res://assets/white.png"))
#		model.TYPE_BRICKWALL:
#			obj = create_sprite_with_texture(load("res://assets/tiles/brickredgray.png"))
#		model.TYPE_DUCK:
#			obj = create_sprite_with_texture(load("res://assets/animals/Duck.png"))
#		model.TYPE_CHICKEN:
#			obj = create_sprite_with_texture(load("res://assets/animals/Chicken.png"))
#		model.TYPE_POTTY:
#			obj = create_sprite_with_texture(load("res://assets/potty.png"))
#		model.TYPE_BABY:
#			obj = create_sprite_with_texture(load("res://assets/baby.png"))
#		_:
#			push_warning("Unknown object added to viewer.")
#			# do nothing
#			return
#
#	obj.set_position(Vector2((x * tile_dims.x), (y * tile_dims.y)) + board_offset)
#	add_child(obj)
#
#
#func update_view() -> void:
#	# Wipe all the old stuff
#	# TODO: Consider using a pool to limit allocations?
#	for child in get_children():
#		remove_child(child)
#		child.queue_free()
#
#	# Display background
#	#for x in range(model.GRID_COLS):
#	#	for y in range(model.GRID_ROWS):
#	#		add_position(x, y, model.TYPE_EMPTY)
#
#	# Display foreground
#	for x in range(model.GRID_COLS):
#		for y in range(model.GRID_ROWS):
#			if not model.grid.is_empty(x, y):
#				var obj = model.grid.get_position(x, y)
#				if not is_instance_valid(obj):
#					print("badness")
#					obj = model.grid.get_position(x, y)
#				add_position(x, y, obj.get_type())
#
#
#
#
#
