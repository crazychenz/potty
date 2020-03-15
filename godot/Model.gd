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

var player = GridObject.new(TYPE_NPC, Vector2(0, 0), grid)
var potty = GridObject.new(TYPE_POTTY, Vector2(7, 7), grid)

var last_grid_updated = 0

onready var view = get_node("View")


func _ready() -> void:
    potty.connect("game_over", view, "_on_game_over")


func _init() -> void:
    grid.init_empty_grid(GRID_ROWS, GRID_COLS)
    bg_grid.init_empty_grid(GRID_ROWS, GRID_COLS)

    grid.set_position(player.get_position(), player)

    var wall = GridObject.new(TYPE_BRICKWALL, Vector2(4, 4), grid)
    wall.set_interact(funcref(wall, "static_interact"))
    grid.set_position(wall.get_position(), wall)

    var duck = GridObject.new(TYPE_DUCK, Vector2(1, 1), grid)
    grid.set_position(duck.get_position(), duck)

    var baby = GridObject.new(TYPE_BABY, Vector2(5, 3), grid)
    grid.set_position(baby.get_position(), baby)

    var chicken = GridObject.new(TYPE_CHICKEN, Vector2(5, 5), grid)
    chicken.set_interact(funcref(chicken, "consumable_interact"))
    grid.set_position(chicken.get_position(), chicken)

    potty.set_interact(funcref(potty, "potty_interact"))
    grid.set_position(potty.get_position(), potty)


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
