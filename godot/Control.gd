extends Node

onready var model = get_node("Model")

func _ready() -> void:
    # Setup initial state
    model.grid.set_position(0, 0, "white")
    model.grid.set_position(3, 3, "BrickRedGray")


func _input(event: InputEvent) -> void:
    if Input.is_action_just_pressed("ui_right"):
        model.npc_move_right()
    if Input.is_action_just_pressed("ui_left"):
        model.npc_move_left()
    if Input.is_action_just_pressed("ui_up"):
        model.npc_move_up()
    if Input.is_action_just_pressed("ui_down"):
        model.npc_move_down()
