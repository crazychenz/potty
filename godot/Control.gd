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


func player_inline(start, end) -> bool:
    if (end.x != start.x and end.y != start.y) or \
            end == start:
        return false

    var player_pos = model.player.get_position()
    if end.x != start.x:
        if start.y != player_pos.y:
            return false
        for i in range(min(start.x, end.x), max(start.x, end.x) + 1):
            if player_pos == Vector2(i, start.y):
                return true
    elif end.y != start.y:
        if start.x != player_pos.x:
            return false
        for i in range(min(start.y, end.y), max(start.y, end.y) + 1):
            if player_pos == Vector2(start.x, i):
                return true

    return false

var mouse_down_grid_pos
func _on_mouse_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        var grid_pos = ((event.position - model.view.board_offset) / model.view.tile_dims)
        grid_pos.x = int(round(grid_pos.x))
        grid_pos.y = int(round(grid_pos.y))
        if event.pressed == true and model.grid.is_valid_position(grid_pos):
            mouse_down_grid_pos = grid_pos
            #print("HERE: %s" % mouse_down_grid_pos)
            return
        else:
            var player_pos = model.player.get_position()

            if mouse_down_grid_pos == null:
                return

            # We only allow moving in a single axis at a time.
            if (grid_pos.x != mouse_down_grid_pos.x and grid_pos.y != mouse_down_grid_pos.y) or \
                    grid_pos == mouse_down_grid_pos:
                mouse_down_grid_pos = null
                return


            # Check if we're pulling.
            var pulling = false
            if player_inline(mouse_down_grid_pos, grid_pos):
                pulling = true

            # If we're aren't pulling, ensure we started with player.
            if not pulling and mouse_down_grid_pos != player_pos:
                return

            # Looks like we're ready to do the move.
            if grid_pos.x > mouse_down_grid_pos.x:
                model.player_move_right(pulling)
            elif grid_pos.x < mouse_down_grid_pos.x:
                model.player_move_left(pulling)
            elif grid_pos.y > mouse_down_grid_pos.y:
                model.player_move_down(pulling)
            elif grid_pos.y < mouse_down_grid_pos.y:
                model.player_move_up(pulling)

            # Clear the mouse down state.
            mouse_down_grid_pos = null
