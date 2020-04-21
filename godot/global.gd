extends Node

onready var _root = get_node("/root")
onready var _current_scene : Node  setget , get_current_scene
onready var _current_scene_path : String setget , get_current_scene_path

func import_action(action_name):
    return load("res://classes/actions/%s.gd" % action_name)

func import_actor(actor_name):
    return load("res://classes/actors/%s.gd" % actor_name)

func import_command(command_name):
    return load("res://classes/commands/%s.gd" % command_name)

func remove_node(node: Node) -> void:
    var parent = node.get_parent()
    parent.remove_child(node)
    node.queue_free()
    #node.call_deferred('free')

# Deletes current scene and loads new scene from given path.
func change_scene(path: String, index : int = 0) -> Node:
    
    # TODO: This could be safer:
    #   1. https://www.reddit.com/r/godot/comments/8hp3ok/use_call_deferredfree_instead_of_queue_free/
    #   2. More error checking before committing to removal of old scene.
    
    yield(get_tree(), "idle_frame")
    if _current_scene != null:
        _root.remove_child(_current_scene)
        _current_scene.queue_free()
    _current_scene_path = path
    _current_scene = load(path).instance()
    yield(get_tree(), "idle_frame")
    _root.add_child(_current_scene)
    _root.move_child(_current_scene, index)
    #yield(get_tree().create_timer(1), "timeout")
    
    return _current_scene

func get_current_scene() -> Node:
    return _current_scene

func get_current_scene_path() -> String:
    return _current_scene_path

func quit() -> void:
    #if _current_scene != null:
    #	_root.remove_child(_current_scene)
    #	_current_scene.call_deferred("free")
    #yield(get_tree().create_timer(1), "timeout")
    get_tree().quit()
