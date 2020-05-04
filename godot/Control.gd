extends Node

var presentation
var model


# While tweening, queue the transactions here.
var xaction_queue = []


func ready(presentation_param, model_param):
    presentation = presentation_param
    model = model_param
    
    model.connect("updated", self, "_on_model_updated")
    model.connect("updated_precommit", self, "_on_model_updated_precommit")


func _on_MainMenuButton_pressed() -> void:
    g.change_scene("res://Title.tscn")


func _on_PlayAgainButton_pressed() -> void:
    g.change_scene("res://Main.tscn")


func player_move(direction) -> void:
    model.player_move(direction)


func grid_ascii_state(position) -> String:
    return model.grid_ascii_state()
    
# TODO: Allow player to set pulling state


func _on_model_updated():
    #print("Got the updated signal") # TODO: uncomment next line
    presentation.update(model.grid_ascii_state(), model.grid_width(), model.grid_height())


func do_commit():
    print("Doing commit")
    model.do_commit()    
    

func _on_model_updated_precommit():
    # TODO: Tell presentation to do tweens and then call do_commit()
    print("got precommit update")
    do_commit()



#
#func drag(down_position, up_position):
#    var grid_pos = ((down_position - presentation.board_offset) / presentation.tile_dims)
#
#    if angle > (180 - 15) and angle < (180 + 15):
#        move_right()
#    elif angle > 15 and angle > (360 - 15):
#        move_left()
#    elif angle > (90 - 15) and angle < (90 + 15):
#        move_up()
#    elif angle > (270 - 15) and angle < (270 + 15):
#        move_down()
#
#
#    if grid_pos != model.player.get_grid_position():
#
#
#func set_touch_origin(origin):
#    var grid_pos = ((origin - presentation.board_offset) / presentation.tile_dims)
#    # Account for the floating point errors
#    grid_pos.x = int(round(grid_pos.x))
#    grid_pos.y = int(round(grid_pos.y))
    
    
        
    

#func player_inline(start, end) -> bool:
#	if (end.x != start.x and end.y != start.y) or \
#			end == start:
#		return false
#
#	var player_pos = model.player.get_position()
#	if end.x != start.x:
#		if start.y != player_pos.y:
#			return false
#		for i in range(min(start.x, end.x), max(start.x, end.x) + 1):
#			if player_pos == Vector2(i, start.y):
#				return true
#	elif end.y != start.y:
#		if start.x != player_pos.x:
#			return false
#		for i in range(min(start.y, end.y), max(start.y, end.y) + 1):
#			if player_pos == Vector2(start.x, i):
#				return true
#
#	return false
#
#var mouse_down_grid_pos
#func _on_mouse_input(event: InputEvent) -> void:
#	if event is InputEventMouseButton:
#		var grid_pos = ((event.position - model.view.board_offset) / model.view.tile_dims)
#		grid_pos.x = int(round(grid_pos.x))
#		grid_pos.y = int(round(grid_pos.y))
#		if event.pressed == true and model.grid.is_valid_position(grid_pos):
#			mouse_down_grid_pos = grid_pos
#			#print("HERE: %s" % mouse_down_grid_pos)
#			return
#		else:
#			var player_pos = model.player.get_position()
#
#			if mouse_down_grid_pos == null:
#				return
#
#			# We only allow moving in a single axis at a time.
#			if (grid_pos.x != mouse_down_grid_pos.x and grid_pos.y != mouse_down_grid_pos.y) or \
#					grid_pos == mouse_down_grid_pos:
#				mouse_down_grid_pos = null
#				return
#
#
#			# Check if we're pulling.
#			var pulling = false
#			if player_inline(mouse_down_grid_pos, grid_pos):
#				pulling = true
#
#			# If we're aren't pulling, ensure we started with player.
#			if not pulling and mouse_down_grid_pos != player_pos:
#				return
#
#			# Looks like we're ready to do the move.
#			if grid_pos.x > mouse_down_grid_pos.x:
#				model.player_move_right(pulling)
#			elif grid_pos.x < mouse_down_grid_pos.x:
#				model.player_move_left(pulling)
#			elif grid_pos.y > mouse_down_grid_pos.y:
#				model.player_move_down(pulling)
#			elif grid_pos.y < mouse_down_grid_pos.y:
#				model.player_move_up(pulling)
#
#			# Clear the mouse down state.
#			mouse_down_grid_pos = null
