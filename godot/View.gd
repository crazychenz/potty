extends Node2D

onready var model = get_parent()

onready var board_offset := Vector2(50, 50)


func _on_game_over():
    set_visible(false)
    get_parent().get_node("GameOverControl").set_visible(true)


func create_sprite_with_texture(texture) -> Sprite:
    var obj = Sprite.new()
    obj.texture = texture
    obj.set_scale(Vector2(0.5, 0.5))
    return obj


func add_position(x : int, y : int, obj_type : String) -> void:
    var obj

    match obj_type:
        model.TYPE_EMPTY:
            obj = create_sprite_with_texture(load("res://assets/tiles/grass.png"))
        model.TYPE_NPC:
            obj = create_sprite_with_texture(load("res://assets/white.png"))
        model.TYPE_BRICKWALL:
            obj = create_sprite_with_texture(load("res://assets/tiles/brickredgray.png"))
        model.TYPE_DUCK:
            obj = create_sprite_with_texture(load("res://assets/animals/Duck.png"))
        model.TYPE_CHICKEN:
            obj = create_sprite_with_texture(load("res://assets/animals/Chicken.png"))
        model.TYPE_POTTY:
            obj = create_sprite_with_texture(load("res://assets/potty.png"))
        model.TYPE_BABY:
            obj = create_sprite_with_texture(load("res://assets/baby.png"))
        _:
            push_warning("Unknown object added to viewer.")
            # do nothing
            return

    obj.set_position(Vector2((x * 64), (y * 64)) + board_offset)
    add_child(obj)


func update_view() -> void:
    # Wipe all the old stuff
    # TODO: Consider using a pool to limit allocations?
    for child in get_children():
        remove_child(child)
        child.queue_free()

    # Display background
    for x in range(model.GRID_COLS):
        for y in range(model.GRID_ROWS):
            add_position(x, y, model.TYPE_EMPTY)

    # Display foreground
    for x in range(model.GRID_COLS):
        for y in range(model.GRID_ROWS):
            if not model.grid.is_empty(x, y):
                var obj = model.grid.get_position(x, y)
                add_position(x, y, obj.get_type())





