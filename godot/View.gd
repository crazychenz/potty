extends Node2D

var controller
var presentation

func ready(presentation):
    self.presentation = presentation
    presentation.connect("updated_state_string", self, "_on_updated_state_string")

func controller_ready(controller):
    self.controller = controller


#func _ready():
#	LevelState.connect("game_over", self, "_on_game_over")
#	LevelState.connect("level_complete", self, "_on_level_complete")
#	LevelState.connect("happiness_gone", self, "_on_LevelState_happiness_gone")
#	LevelState.connect("bladder_full", self, "_on_LevelState_bladder_full")
#
#
#func _on_LevelState_happiness_gone():
#	# TODO: Do some animation?
#	LevelState.game_over()
#
#
#func _on_LevelState_bladder_full():
#	# TODO: Do some animation?
#	LevelState.game_over()
#
#
#func _on_game_over():
#	set_visible(false)
#	get_parent().get_node("UIControl/GameOverPanel").set_visible(true)
#
#
#func _on_level_complete():
#	set_visible(false)
#	get_parent().get_node("UIControl/GameOverPanel").set_visible(true)
#
#
func create_sprite_with_texture(texture) -> Sprite:
    var obj = Sprite.new()
    obj.texture = texture
    obj.set_scale(Vector2(0.5, 0.5))
    return obj

const TYPE_EMPTY = '.'     #"Empty"
const TYPE_NPC = '*'       #"Npc"
const TYPE_GRASS = '.'     #"Grass"
const TYPE_BRICKWALL = 'W' #"BrickWall"
const TYPE_DUCK = 'R'      #"Duck"
const TYPE_CHICKEN = 'C'   #"Chicken"
const TYPE_POTTY = 'P'     #"Potty"
const TYPE_BABY = 'T'      #"Baby"

var typeTextureMap = {
    TYPE_EMPTY: load("res://assets/tiles/grass.png"),
    TYPE_NPC: load("res://assets/white.png"),
    TYPE_GRASS: load("res://assets/tiles/grass.png"),
    TYPE_BRICKWALL: load("res://assets/tiles/brickredgray.png"),
    TYPE_DUCK: load("res://assets/animals/Duck.png"),
    TYPE_CHICKEN: load("res://assets/animals/Chicken.png"),
    TYPE_POTTY: load("res://assets/potty.png"),
    TYPE_BABY: load("res://assets/baby.png"),
}

func add_position(x : int, y : int, obj_type : String) -> void:
    var obj = create_sprite_with_texture(typeTextureMap[obj_type])
    obj.set_name("x%dy%d" % [x, y])
    obj.set_position(Vector2((x * presentation.tile_dims.x), (y * presentation.tile_dims.y)) + presentation.board_offset)
    add_child(obj)


func _on_updated_state_string(ascii_state, width, height) -> void:
    # Wipe all the old stuff
    # TODO: Consider using a pool to limit allocations?

    for child in get_children():
        remove_child(child)
        child.queue_free()

    # Display background
    for y in range(height):
       for x in range(width):
           add_position(x, y, TYPE_EMPTY)

    # Display foreground
    for y in range(height):
        for x in range(width):
            var value = ascii_state[y * height + x]
            if not value == '.':
                add_position(x, y, value)
