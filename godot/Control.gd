extends Node

onready var model = get_node("Model")


func _input(event: InputEvent) -> void:
    if Input.is_action_just_pressed("ui_right"):
        model.player_move_right(Input.is_action_pressed("ui_select"))
    if Input.is_action_just_pressed("ui_left"):
        model.player_move_left(Input.is_action_pressed("ui_select"))
    if Input.is_action_just_pressed("ui_up"):
        model.player_move_up(Input.is_action_pressed("ui_select"))
    if Input.is_action_just_pressed("ui_down"):
        model.player_move_down(Input.is_action_pressed("ui_select"))
