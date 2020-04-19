extends Node

var controller


func controller_ready(controller):
	self.controller = controller

	# TODO: Setup local signals


# All HID input should hit this function
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		_on_keyboard_input(event)
	elif event is InputEventMouse:
		_on_mouse_input(event)


func _on_keyboard_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_right"):
		controller.player_move_right(Input.is_action_pressed("ui_select"))
	if Input.is_action_just_pressed("ui_left"):
		controller.player_move_left(Input.is_action_pressed("ui_select"))
	if Input.is_action_just_pressed("ui_up"):
		controller.player_move_up(Input.is_action_pressed("ui_select"))
	if Input.is_action_just_pressed("ui_down"):
		controller.player_move_down(Input.is_action_pressed("ui_select"))


var mouse_down_pos : Vector2
func _on_mouse_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed == true:
			mouse_down_pos = event.position
			print("Down at: %s" % mouse_down_pos)
			return
		else:
			if mouse_down_pos == null:
				return
			if mouse_down_pos.distance_to(event.position) < 4:
				# No single click actions supported at this time.
				pass
			else:
				# We dragged something
				var angle = rad2deg(mouse_down_pos.angle_to_point(event.position))
				if angle > (180 - 15) and angle < (180 + 15):
					controller.player_move_right(mouse_down_pos)
				elif angle > 15 and angle > (360 - 15):
				   controller.player_move_left(mouse_down_pos)
				elif angle > (90 - 15) and angle < (90 + 15):
				   controller.player_move_up(mouse_down_pos)
				elif angle > (270 - 15) and angle < (270 + 15):
				   controller.player_move_down(mouse_down_pos)
					
				print("Angle To: %s" % [angle])

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
