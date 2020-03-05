extends Node

onready var model = get_node("Model")

func _ready() -> void:
	# Setup initial state
	#model.grid.set_position(6, 6, model.create_player())
	#model.grid.set_position(0, 0, model.TYPE_NPC)
	#model.grid.set_position(3, 3, model.TYPE_BRICKWALL)
	#model.grid.set_position(4, 2, model.TYPE_PUSHABLE_DUCK)
	pass


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_right"):
		model.player_move_right()
	if Input.is_action_just_pressed("ui_left"):
		model.player_move_left()
	if Input.is_action_just_pressed("ui_up"):
		model.player_move_up()
	if Input.is_action_just_pressed("ui_down"):
		model.player_move_down()
