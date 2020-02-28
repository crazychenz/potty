extends Node

const GRID_ROWS = 10
const GRID_COLS = 10
const NPC_TYPE = "white"
const NULL_TYPE = "black"

var Grid = preload("res://Grid.gd")

var grid = Grid.new()

var npc_location = Vector2(0, 0)

var last_grid_updated = 0

onready var view = get_node("View")

func _init() -> void:
    grid.init_empty_grid(GRID_ROWS, GRID_COLS)

func npc_move_up():
    if npc_location.y > 0:
        # Wipe the old position
        grid.set_position(npc_location, null)
        npc_location.y -= 1
        # Add the new position
        grid.set_position(npc_location, NPC_TYPE)

func npc_move_down():
    if npc_location.y < GRID_ROWS - 1:
        # Wipe the old position
        grid.set_position(npc_location, null)
        npc_location.y += 1
        # Add the new position
        grid.set_position(npc_location, NPC_TYPE)

func npc_move_left():
    if npc_location.x > 0:
        # Wipe the old position
        grid.set_position(npc_location, null)
        npc_location.x -= 1
        # Add the new position
        grid.set_position(npc_location, NPC_TYPE)

func npc_move_right():
    if npc_location.x < GRID_COLS - 1:
        # Wipe the old position
        grid.set_position(npc_location, null)
        npc_location.x += 1
        # Add the new position
        grid.set_position(npc_location, NPC_TYPE)


func _process(delta: float) -> void:
    var updated = grid.get_last_updated()
    if updated > last_grid_updated:
        view.update_view()
        last_grid_updated = updated
