extends Node

var controller

var board_offset := Vector2(75, 75)
var tile_dims := Vector2(64, 64)


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


func ready():
    pass


func controller_ready(controller_param):
    controller = controller_param
    controller._on_model_updated()
    enable_all_processing()

signal updated_precommit(simple_moves)
func updated_precommit(simple_moves):
    emit_signal("updated_precommit", simple_moves)

# Just a dummy function for testing refactor.
signal updated_state_string(string, width, height)
func update(state_string, width, height):
    emit_signal("updated_state_string", state_string, width, height)
