extends Node


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
