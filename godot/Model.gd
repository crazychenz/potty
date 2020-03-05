extends Node

const GRID_ROWS = 8
const GRID_COLS = 8

const TYPE_EMPTY = "Empty"
const TYPE_NPC = "Npc"
const TYPE_GRASS = "Grass"
const TYPE_BRICKWALL = "BrickWall"
const TYPE_PUSHABLE_DUCK = "PushableDuck"

const pushable = [TYPE_PUSHABLE_DUCK]

#var Player = preload("res://Player.gd")
var Grid = preload("res://Grid.gd")

var grid = Grid.new()

var player = GridObject.new()

var last_grid_updated = 0

onready var view = get_node("View")

func _init() -> void:
	grid.init_empty_grid(GRID_ROWS, GRID_COLS)
	
	player.set_position(Vector2(0, 0))
	player.set_type(TYPE_NPC)
	grid.set_position(player.get_position(), player)
	
	var wall = GridObject.new()
	wall.set_position(Vector2(4, 4))
	wall.set_type(TYPE_BRICKWALL)
	wall.set_pushable()
	grid.set_position(wall.get_position(), wall)

#func create_player():
#	return Player.new()

func player_move_right():
	grid.move_right(player)

func player_move_left():
	grid.move_left(player)

func player_move_up():
	grid.move_up(player)

func player_move_down():
	grid.move_down(player)


func _process(delta: float) -> void:
	var updated = grid.get_last_updated()
	if updated > last_grid_updated:
		view.update_view()
		last_grid_updated = updated
