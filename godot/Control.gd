extends Node

var presentation
var model

var goal_reached := false

# While tweening, queue the transactions here.
var xaction_queue = []


func ready(presentation_param, model_param):
    presentation = presentation_param
    model = model_param
    
    model.connect("updated", self, "_on_model_updated")
    model.connect("updated_precommit", self, "_on_model_updated_precommit")
    model.connect("goal_reached", self, "_on_goal_reached")
    model.connect("game_failed", self, "_on_game_failed")
    model.connect("game_beat", self, "_on_game_beat")
    model.connect("happiness_updated", self, "_on_happiness_updated")
    model.connect("bladder_updated", self, "_on_bladder_updated")


func _on_happiness_updated(value) -> void:
    presentation.happiness_updated(value)

func _on_bladder_updated(value) -> void:
    presentation.bladder_updated(value)


func _on_game_failed() -> void:
    presentation.game_failed()


func _on_goal_reached(stars) -> void:
    goal_reached = true
    presentation.goal_reached(stars)

func _on_MainMenuButton_pressed() -> void:
    if goal_reached == true:
        # If user went to main menu instead of next level, 
        # we assume next level.
        PottyModel.next_level()
        goal_reached = false
    PottyModel.pause_bladder(true)
    g.change_scene("res://Title.tscn")


func timescale_down():
    Engine.time_scale /= 2
    print("Timescale down: %s" % Engine.time_scale)
    presentation.timescale_change()
    

func timescale_up():
    Engine.time_scale *= 2
    print("Timescale up: %s" % Engine.time_scale)
    presentation.timescale_change()
    

func _on_game_beat(stars) -> void:
    presentation.game_beat(stars)


func _on_PlayAgainButton_pressed() -> void:
    PottyModel.reset_level()
    goal_reached = false
    g.change_scene("res://Main.tscn")


func _on_NextLevelButton_pressed() -> void:
    PottyModel.next_level()
    goal_reached = false
    g.change_scene("res://Main.tscn")


func player_move(direction) -> void:
    model.player_move(direction)
    pass


func player_pull(value) -> void:
    model.player_pull(value)


func grid_ascii_state(position) -> String:
    return model.grid_ascii_state()
    
# TODO: Allow player to set pulling state


func _on_model_updated():
    #print("Got the updated signal") # TODO: uncomment next line
    presentation.update(model.grid_ascii_state(), model.grid_width(), model.grid_height())


func do_commit():
    #print("Doing commit")
    model.do_commit()    
    
var active_tweens = []
func _on_model_updated_precommit(simple_moves : PoolVector2Array):
    presentation.updated_precommit(simple_moves)



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
