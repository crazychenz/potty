extends Node

onready var model = get_node("Model")

func _input(event: InputEvent) -> void:
    if Input.is_action_pressed("ui_select"):
        pass
#        if Input.is_action_just_pressed("ui_right"):
#            model.player_move_right()
#        if Input.is_action_just_pressed("ui_left"):
#            model.player_pull_left()
#        if Input.is_action_just_pressed("ui_up"):
#            model.player_move_up()
#        if Input.is_action_just_pressed("ui_down"):
#            model.player_move_down()
    else:
        if Input.is_action_just_pressed("ui_right"):
            model.player_move_right()
        if Input.is_action_just_pressed("ui_left"):
            model.player_move_left()
        if Input.is_action_just_pressed("ui_up"):
            model.player_move_up()
        if Input.is_action_just_pressed("ui_down"):
            model.player_move_down()
