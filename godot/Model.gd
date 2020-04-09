extends Node

signal game_over

const GRID_ROWS = 8
const GRID_COLS = 8

const TYPE_EMPTY = "Empty"
const TYPE_NPC = "Npc"
const TYPE_GRASS = "Grass"
const TYPE_BRICKWALL = "BrickWall"
const TYPE_DUCK = "Duck"
const TYPE_CHICKEN = "Chicken"
const TYPE_POTTY = "Potty"
const TYPE_BABY = "Baby"

#var Player = preload("res://Player.gd")
var Grid = load("res://Grid.gd")

var bg_grid = Grid.new()
var grid = Grid.new()

var player
var potty

var last_grid_updated = 0

onready var view = get_node("View")

var levels := {
	'demo': {
		'layout': [
			[' ', '*', ' ', ' ', ' ', ' ', ' ', ' '],
			[' ', 'D', ' ', ' ', ' ', ' ', ' ', ' '],
			[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
			[' ', ' ', ' ', ' ', ' ', 'T', ' ', ' '],
			[' ', ' ', ' ', ' ', 'W', ' ', ' ', ' '],
			[' ', ' ', ' ', ' ', ' ', 'C', ' ', ' '],
			[' ', ' ', ' ', ' ', ' ', 'C', ' ', ' '],
			[' ', ' ', ' ', ' ', ' ', ' ', ' ', 'P'],

		]
	},
	1: {
		'layout': [
			['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
			['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
			['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
			[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
			[' ', '*', ' ', 'T', ' ', ' ', 'P', ' '],
			[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
			['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
			['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
		]
	},
	2: {
		'layout': [
			['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
			['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
			['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
			[' ', ' ', ' ', 'W', 'W', 'W', 'W', 'W'],
			[' ', '*', ' ', 'D', 'T', ' ', 'P', ' '],
			[' ', ' ', ' ', 'W', 'W', 'W', 'W', 'W'],
			['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
			['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
		]
	},
	3: {
		'layout': [
			[' ', ' ', ' ', ' ', 'W', 'W', 'W', 'W'],
			[' ', ' ', ' ', ' ', 'W', 'W', 'W', 'W'],
			[' ', '*', ' ', ' ', 'T', 'W', 'W', 'W'],
			[' ', ' ', ' ', ' ', 'W', 'W', 'W', 'W'],
			[' ', ' ', ' ', ' ', 'W', 'W', 'W', 'W'],
			[' ', ' ', ' ', ' ', 'P', 'W', 'W', 'W'],
			[' ', ' ', ' ', ' ', 'W', 'W', 'W', 'W'],
			[' ', ' ', ' ', ' ', 'W', 'W', 'W', 'W'],
		]
	},
	4: {
		'layout': [
			[' ', ' ', ' ', ' ', 'W', 'W', 'W', 'W'],
			[' ', '*', ' ', ' ', 'W', 'W', 'W', 'W'],
			[' ', ' ', ' ', ' ', 'T', 'W', 'W', 'W'],
			['W', 'W', 'W', ' ', 'W', 'W', 'W', 'W'],
			['W', 'W', 'W', 'D', 'W', 'W', 'W', 'W'],
			['W', 'W', 'W', 'P', 'W', 'W', 'W', 'W'],
			['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
			['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
		]
	},
	5: {
		'layout': [
			['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
			['P', 'D', ' ', 'D', ' ', 'D', 'T', ' '],
			['W', ' ', 'W', ' ', 'W', ' ', 'W', ' '],
			['W', ' ', 'W', ' ', 'W', ' ', 'W', ' '],
			['W', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
			['W', 'W', 'W', 'W', 'W', 'W', 'W', ' '],
			['W', '*', ' ', ' ', ' ', ' ', ' ', ' '],
			['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
		]
	},
	6: {
		'layout': [
			['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
			['P', 'D', ' ', 'C', ' ', 'D', ' ', ' '],
			['W', ' ', 'W', ' ', 'W', 'T', 'W', ' '],
			['W', ' ', 'W', ' ', 'W', ' ', 'W', ' '],
			['W', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
			['W', 'W', 'W', 'W', 'W', 'W', 'W', ' '],
			['W', '*', ' ', ' ', ' ', ' ', ' ', ' '],
			['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
		]
	},
	7: {
		'layout': [
			['*', ' ', 'T', ' ', ' ', ' ', ' ', ' '],
			['W', 'W', 'W', 'W', 'W', 'W', ' ', ' '],
			['W', 'W', 'W', 'W', 'W', ' ', ' ', ' '],
			[' ', ' ', 'C', ' ', ' ', ' ', ' ', 'C'],
			[' ', ' ', ' ', 'W', 'W', 'W', 'W', 'W'],
			[' ', ' ', 'W', 'W', 'W', 'W', 'W', 'W'],
			[' ', ' ', 'C', ' ', ' ', ' ', ' ', 'P'],
			['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
		]
	},
}

func init_level_demo() -> void:
	player = GridObject.new(TYPE_NPC, Vector2(1, 2), grid)
	grid.set_position(player.get_position(), player)

	var wall = GridObject.new(TYPE_BRICKWALL, Vector2(4, 4), grid)
	wall.set_interact(funcref(wall, "static_interact"))
	grid.set_position(wall.get_position(), wall)

	var duck = GridObject.new(TYPE_DUCK, Vector2(1, 3), grid)
	grid.set_position(duck.get_position(), duck)

	var baby = GridObject.new(TYPE_BABY, Vector2(5, 3), grid)
	baby.set_interact(funcref(baby, "baby_interact"))
	grid.set_position(baby.get_position(), baby)

	var chicken = GridObject.new(TYPE_CHICKEN, Vector2(5, 5), grid)
	chicken.set_interact(funcref(chicken, "consumable_interact"))
	grid.set_position(chicken.get_position(), chicken)

	chicken = GridObject.new(TYPE_CHICKEN, Vector2(5, 6), grid)
	chicken.set_interact(funcref(chicken, "consumable_interact"))
	grid.set_position(chicken.get_position(), chicken)

	potty = GridObject.new(TYPE_POTTY, Vector2(7, 7), grid)
	potty.set_interact(funcref(potty, "potty_interact"))
	grid.set_position(potty.get_position(), potty)

func init_level(key) -> void:
	var layout = levels[key].layout

	var obj_map = {
		'*': {
			'sprite': TYPE_NPC,
			'behavior': ''
		},
		'P': {
			'sprite': TYPE_POTTY,
			'behavior': 'potty_interact'
		},
		'W': {
			'sprite': TYPE_BRICKWALL,
			'behavior': 'static_interact'
		},
		'C': {
			'sprite': TYPE_CHICKEN,
			'behavior': 'consumable_toy_interact'
		},
		'T': {
			'sprite': TYPE_BABY,
			'behavior': 'baby_interact'
		},
		'D': {
			'sprite': TYPE_DUCK,
			'behavior': 'move_action_event'
		}
	}

	for y in range(len(layout)):
		for x in range(len(layout[y])):
			if layout[y][x] == ' ':
				continue
			var obj = GridObject.new(obj_map[layout[y][x]].sprite, Vector2(x, y), grid)
			if obj_map[layout[y][x]].behavior != '':
				obj.set_interact(funcref(obj, obj_map[layout[y][x]].behavior))
			grid.set_position(obj.get_position(), obj)
			if layout[y][x] == '*':
				player = obj
			elif layout[y][x] == 'P':
				potty = obj


func _init() -> void:
	grid.init_empty_grid(GRID_ROWS, GRID_COLS)
	bg_grid.init_empty_grid(GRID_ROWS, GRID_COLS)

	#init_level_demo()
	init_level(LevelState.current_level)


func player_move_right(pulling = false):
	player.handle_action(ActionEventMove.new(player, ActionEventMove.RIGHT, pulling))


func player_move_left(pulling = false):
	player.handle_action(ActionEventMove.new(player, ActionEventMove.LEFT, pulling))


func player_move_up(pulling = false):
	player.handle_action(ActionEventMove.new(player, ActionEventMove.UP, pulling))


func player_move_down(pulling = false):
	player.handle_action(ActionEventMove.new(player, ActionEventMove.DOWN, pulling))


func _process(delta: float) -> void:
	var updated = grid.get_last_updated()
	if updated > last_grid_updated:
		view.update_view()
		last_grid_updated = updated
