extends Node

#var MoveDirAction = g.import_action("MoveDirAction")

var controller


func disable_all_processing():
    # We want no processing until controller_ready()
    set_process(false)
    set_process_input(false)
    set_process_unhandled_input(false)
    set_process_unhandled_key_input(false)


func enable_all_processing():
    set_process(true)
    set_process_input(true)
    set_process_unhandled_input(true)
    set_process_unhandled_key_input(true)


func _init():
    disable_all_processing()


func _ready():
    disable_all_processing()


func controller_ready(controller):
    self.controller = controller

    # TODO: Setup local signals
    
    enable_all_processing()


# All HID input should hit this function
func _input(event: InputEvent) -> void:
    if event is InputEventKey:
        _on_keyboard_input(event)
    elif event is InputEventMouse:
        _on_mouse_input(event)


"""
We put this here instead of Controller because we want just one set of
input handling code, whereas this can handle many different sources of
input.

For example: We use Input class for keyboard at the moment, but we
could easily add a touchscreen keyboard or a controller and have buttons
mapped to the same controller actions.
"""
# Handle keyboard inputs
func _on_keyboard_input(event: InputEvent) -> void:

    # TODO: This could be done better.

    if Input.is_action_just_pressed("ui_right"):
        controller.player_move(Vector2(1, 0));
    elif Input.is_action_just_pressed("ui_left"):
        controller.player_move(Vector2(-1, 0))
    elif Input.is_action_just_pressed("ui_up"):
        controller.player_move(Vector2(0, -1))
    elif Input.is_action_just_pressed("ui_down"):
        controller.player_move(Vector2(0, 1))
        
    elif Input.is_action_just_released("ui_right"):
        controller.player_move(Vector2(0, 0));
    elif Input.is_action_just_released("ui_left"):
        controller.player_move(Vector2(0, 0))
    elif Input.is_action_just_released("ui_up"):
        controller.player_move(Vector2(0, 0))
    elif Input.is_action_just_released("ui_down"):
        controller.player_move(Vector2(0, 0))






#    if Input.is_action_just_pressed("ui_right"):
#        controller.player_move(Vector2(1, 0));
#    elif Input.is_action_just_pressed("ui_left"):
#        controller.player_move(Vector2(-1, 0))
#    elif Input.is_action_just_pressed("ui_up"):
#        controller.player_move(Vector2(0, -1))
#    elif Input.is_action_just_pressed("ui_down"):
#        controller.player_move(Vector2(0, 1))




    #elif Input.is_action_just_pressed("ui_select"):
    #    controller.set_pulling(true)
    #elif Input.is_action_just_released("ui_select"):
    #    controller.set_pulling(false)
    pass

# Handle mouse inputs
var mouse_down_pos : Vector2
func _on_mouse_input(event: InputEvent) -> void:
#    if event is InputEventMouseButton:
#        if event.pressed == true:
#            mouse_down_pos = event.position
#            #print("Down at: %s" % mouse_down_pos)
#            return
#        else:
#            if mouse_down_pos == null:
#                return
#            if mouse_down_pos.distance_to(event.position) < 4:
#                # No single click actions supported at this time.
#                pass
#            else:
#                # We dragged something
#                var angle = rad2deg(mouse_down_pos.angle_to_point(event.position))
#                #print("Angle To: %s" % [angle])
#                controller.set_touch_origin(mouse_down_pos)
#                if angle > (180 - 15) and angle < (180 + 15):
#                    controller.player_perform(MoveDirAction.right())
#                elif angle > 15 and angle > (360 - 15):
#                    controller.player_perform(MoveDirAction.left())
#                elif angle > (90 - 15) and angle < (90 + 15):
#                    controller.player_perform(MoveDirAction.up())
#                elif angle > (270 - 15) and angle < (270 + 15):
#                    controller.player_perform(MoveDirAction.down())
    pass                    

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
