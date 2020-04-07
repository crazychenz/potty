extends Node

onready var model = get_node("Model")


func _input(event: InputEvent) -> void:
    if event is InputEventKey:
        _on_keyboard_input(event)
    elif event is InputEventMouse:
        _on_mouse_input(event)


func _on_keyboard_input(event: InputEvent) -> void:
    if Input.is_action_just_pressed("ui_right"):
        model.player_move_right(Input.is_action_pressed("ui_select"))
    if Input.is_action_just_pressed("ui_left"):
        model.player_move_left(Input.is_action_pressed("ui_select"))
    if Input.is_action_just_pressed("ui_up"):
        model.player_move_up(Input.is_action_pressed("ui_select"))
    if Input.is_action_just_pressed("ui_down"):
        model.player_move_down(Input.is_action_pressed("ui_select"))


func _on_mouse_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        var grid_pos = ((event.position - model.view.board_offset) / model.view.tile_dims).round()
        if model.grid.is_valid_position(grid_pos):
            if event.pressed == true:
                #print("Mouse down at: %s" % grid_pos)
                pass
            else:
                #print("Mouse up at: %s" % grid_pos)
                pass
