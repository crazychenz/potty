extends "res://addons/gutlite/test.gd"

var Model = load("res://Model.gd")
var model

func before_each():
    pass
    
func after_each():
    pass
    
func before_all():
    model = Model.new()
    model.ready()
    yield(get_tree().create_timer(0.1), "timeout")
    
func after_all():
    pass
    model.queue_free()
    model = null
    
func test_first():
    # Simple signature check of scene being loaded.
    assert_not_null(model, "Model load and allocation check")

    

#func test_credits_scene_load_unload():
#    # Show credits
#    var button = g.get_current_scene().find_node("CreditsButton")
#    button.emit_signal("pressed")
#    yield(get_tree().create_timer(0.1), "timeout")
#
#    assert_not_null(g.get_current_scene().find_node("CreditsLabel"), "CreditsLabel Check")
#
#    # Return to main menu
#    button = g.get_current_scene().find_node("MainMenuButton")
#    button.emit_signal("pressed")	
#    yield(get_tree().create_timer(0.1), "timeout")
#
#    assert_not_null(g.get_current_scene().find_node("PottyTimeLabel"), "PottyTimeLabel Check")
#
#func test_game_load_unload():
#    # Start new game.
#    var button = g.get_current_scene().find_node("NewGameButton")
#    button.emit_signal("pressed")
#    yield(get_tree().create_timer(0.1), "timeout")
#
#    assert_not_null(g.get_current_scene().find_node("GameOverPanel"), "GameOverPanel Check")
#
#    # Return to main menu
#    button = g.get_current_scene().find_node("MainMenuButton")
#    button.emit_signal("pressed")
#    yield(get_tree().create_timer(0.1), "timeout")
#
#    assert_not_null(g.get_current_scene().find_node("PottyTimeLabel"), "PottyTimeLabel Check")
#
#
