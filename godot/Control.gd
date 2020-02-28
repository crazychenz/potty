extends Node

onready var model = get_node("Model")

func _ready() -> void:
    for x in range(model.GRID_COLS):
        for y in range(model.GRID_ROWS):
            model.grid.set_position(x, y, "black")

    # Setup initial state
    model.grid.set_position(0, 0, "white")
    model.grid.set_position(9, 9, "white")



