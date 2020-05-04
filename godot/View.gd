extends Node2D

var controller
var presentation

func ready(presentation):
    self.presentation = presentation
    presentation.connect("updated_state_string", self, "_on_updated_state_string")
    presentation.connect("updated_precommit", self, "_on_updated_precommit")

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

func grid_to_pos(vec : Vector2):
    return Vector2((vec.x * presentation.tile_dims.x), (vec.y * presentation.tile_dims.y)) + presentation.board_offset

var active_tweens = []
func _on_updated_precommit(simple_moves):
    # TODO: Tell presentation to do tweens and then call do_commit()
    #print("got precommit update")
    #print(simple_moves)
    for i in range(0, len(simple_moves), 2):
        #print("Tween from %s -> %s" % [simple_moves[i], simple_moves[i+1]])
        var tween = Tween.new()
        var sprite = get_node("fg-x%dy%d" % [simple_moves[i].x, simple_moves[i].y])
        var start = grid_to_pos(simple_moves[i])
        var end = grid_to_pos(simple_moves[i+1])
        tween.interpolate_property(sprite, "position", start, end, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
        active_tweens.append(tween)
        tween.connect("tween_all_completed", self, "_on_tween_complete", [tween])
        add_child(tween)
        tween.start()
        
func _on_tween_complete(tween : Tween):
    active_tweens.erase(tween)
    remove_child(tween)
    tween.queue_free()
    if len(active_tweens) == 0:
        #print("All tweens complete, doing commit")
        controller.do_commit()

    #tween.start()
    
    # TODO: Setup tweens for each move.
    # TODO: After all tweens complete, do commit().
    
    # BUG/NOTICE: We allow a keyboard/controller user
    # to hold down a direction for subsequent moves. If
    # there is no delay, it can move VERY fast. This needs
    # to be slowed down when there is no tween or other
    # timed blocker. For now .25s should do it.
    # BUG: This could also be the result of not finding
    # conflicts in the DLL appropriately.
    #yield(get_tree().create_timer(.1), "timeout")
    #do_commit()


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

func add_position(x : int, y : int, obj_type : String, prefix : String = "fg") -> void:
    var obj = create_sprite_with_texture(typeTextureMap[obj_type])
    obj.set_name("%s-x%dy%d" % [prefix, x, y])
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
           add_position(x, y, TYPE_EMPTY, "bg")

    # Display foreground
    for y in range(height):
        for x in range(width):
            var value = ascii_state[y * height + x]
            if not value == '.':
                add_position(x, y, value, "fg")
