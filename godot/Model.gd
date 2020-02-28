extends Node

const GRID_ROWS = 10
const GRID_COLS = 10

var Grid = preload("res://Grid.gd")

var grid = Grid.new()

var last_grid_updated = 0

onready var view = get_node("View")

func _init() -> void:
    grid.init_empty_grid(GRID_ROWS, GRID_COLS)

func _process(delta: float) -> void:
    var updated = grid.get_last_updated()
    if updated > last_grid_updated:
        view.update_view()
        last_grid_updated = updated
