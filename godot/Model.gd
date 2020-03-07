extends Node

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

var player = GridObject.new()

var last_grid_updated = 0

onready var view = get_node("View")

func _init() -> void:
    grid.init_empty_grid(GRID_ROWS, GRID_COLS)
    bg_grid.init_empty_grid(GRID_ROWS, GRID_COLS)

    player.set_position(Vector2(0, 0))
    player.set_type(TYPE_NPC)
    grid.set_position(player.get_position(), player)

    var wall = GridObject.new()
    wall.set_position(Vector2(4, 4))
    wall.set_type(TYPE_BRICKWALL)
    grid.set_position(wall.get_position(), wall)

    var duck = GridObject.new()
    duck.set_position(Vector2(3, 3))
    duck.set_type(TYPE_DUCK)
    duck.set_pushable()
    grid.set_position(duck.get_position(), duck)

    var baby = GridObject.new()
    baby.set_position(Vector2(5, 3))
    baby.set_type(TYPE_BABY)
    baby.set_pushable()
    grid.set_position(baby.get_position(), baby)

    var chicken = GridObject.new()
    chicken.set_position(Vector2(5, 5))
    chicken.set_type(TYPE_CHICKEN)
    chicken.set_consumable()
    grid.set_position(chicken.get_position(), chicken)

    var potty = GridObject.new()
    potty.set_position(Vector2(7, 7))
    potty.set_type(TYPE_POTTY)
    potty.set_stackable()
    grid.set_position(potty.get_position(), potty)


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
