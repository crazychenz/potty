extends Reference

class_name Model

signal updated(xaction)

#var Player = g.import_actor("Player")
#var Potty = g.import_actor("Potty")
#var Actor = g.import_actor("Actor")
#var Toddler = g.import_actor("Toddler")
#
#signal game_over
#
#const GRID_ROWS = 8
#const GRID_COLS = 8
#
#const PLAYER = "player"
#const POTTY = "potty"
#
#const TYPE_EMPTY = "Empty"
#const TYPE_NPC = "Npc"
#const TYPE_GRASS = "Grass"
#const TYPE_BRICKWALL = "BrickWall"
#const TYPE_DUCK = "Duck"
#const TYPE_CHICKEN = "Chicken"
#const TYPE_POTTY = "Potty"
#const TYPE_BABY = "Baby"
#
##var Player = preload("res://Player.gd")
#var Grid = load("res://Grid.gd")
#
#var bg_grid = Grid.new()
#var grid = Grid.new()
#
#var player
#var potty
#
#var last_grid_updated = 0
#
#func fini():
#    if is_instance_valid(player):
#        #player.free()
#        pass
#    if is_instance_valid(potty):
#        #potty.free()
#        pass
#    if is_instance_valid(bg_grid):
#        bg_grid._fini()
#        bg_grid.call_deferred("free")
#    if is_instance_valid(grid):
#        grid._fini()
#        grid.call_deferred("free")
#
#func _notification(what):
#    if what == NOTIFICATION_PREDELETE:
#        pass
#        #print("Removing Model")
#        #fini()
#
#
#func init_level(layout) -> void:
#
#    var obj_map = {
#        '*': {
#            'sprite': TYPE_NPC,
#            'behavior': ''
#        },
#        'P': {
#            'sprite': TYPE_POTTY,
#            'behavior': 'potty_interact'
#        },
#        'W': {
#            'sprite': TYPE_BRICKWALL,
#            'behavior': 'static_interact'
#        },
#        'C': {
#            'sprite': TYPE_CHICKEN,
#            'behavior': 'consumable_toy_interact'
#        },
#        'T': {
#            'sprite': TYPE_BABY,
#            'behavior': 'baby_interact'
#        },
#        'D': {
#            'sprite': TYPE_DUCK,
#            'behavior': 'move_action_event'
#        }
#    }
#
#    for y in range(len(layout)):
#        for x in range(len(layout[y])):
#            if layout[y][x] == ' ':
#                continue
#            var obj
#            if layout[y][x] == '*':
#                obj = Player.new(Vector2(x, y), self)
#                player = obj
#            elif layout[y][x] == 'P':
#                obj = Potty.new(Vector2(x, y), self)
#                potty = obj
#            elif layout[y][x] == 'T':
#                obj = Toddler.new(Vector2(x, y), self)
#            else:
#                obj = Actor.new(Vector2(x, y), layout[y][x], self)
#            grid.set_position(obj.get_grid_position(), obj)
#
#
#func grid_as_string() -> String:
#    return grid.as_string()
#
#
## Move action propogates to other objects.
## Objects are checked if they are movable.
#
#
#func ready(layout) -> void:
#    grid.init_empty_grid(GRID_ROWS, GRID_COLS)
#    bg_grid.init_empty_grid(GRID_ROWS, GRID_COLS)
#    init_level(layout)
#
#func is_valid_position(grid_position) -> bool:
#    return grid.is_valid_position(grid_position)
#
#func get_entity_at(grid_position):
#    if not grid.is_valid_position(grid_position):
#        return null
#    return grid.get_position(grid_position)
#
#func perform_on(action, model, actor) -> Transaction:
#    return action.perform_on(model, actor)
#
#func perform_to(action, model, actor_dst, actor_src) -> Transaction:
#    return action.perform_to(model, actor_dst, actor_src)
#
#func perform(action, model) -> Transaction:
#        return action.perform(model)
#
#func player_perform(action) -> Transaction:
#    return perform_on(action, self, player)
#
## This is where we receive new action transactions.
#func commit_xaction(xaction : Transaction):
#    # Remove all the commanded actors from the grid
#    for command in xaction.commands:
#        var pos = command.actor.grid_position
#        grid._set_coords(pos.x, pos.y, null)
#
#    # Apply all the commands to actors in the grid
#    for command in xaction.commands:
#        command.perform()
#
#    emit_signal("updated", xaction)
#
##func player_move_right(pulling = false):
##	player.handle_action(ActionEventMove.new(player, ActionEventMove.RIGHT, pulling))
##
##
##func player_move_left(pulling = false):
##	player.handle_action(ActionEventMove.new(player, ActionEventMove.LEFT, pulling))
##
##
##func player_move_up(pulling = false):
##	player.handle_action(ActionEventMove.new(player, ActionEventMove.UP, pulling))
##
##
##func player_move_down(pulling = false):
##	player.handle_action(ActionEventMove.new(player, ActionEventMove.DOWN, pulling))
#
##func _process(delta: float) -> void:
##	var updated = grid.get_last_updated()
##	if updated > last_grid_updated:
##		view.update_view()
##		last_grid_updated = updated
