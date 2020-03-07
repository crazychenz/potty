extends Node

onready var model = get_node("Model")

func _ready() -> void:
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
