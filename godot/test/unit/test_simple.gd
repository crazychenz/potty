extends "res://addons/gut/test.gd"
func before_each():
	gut.p("ran setup", 2)

func after_each():
	gut.p("ran teardown", 2)

func before_all():
	# Load the initial scene.
	g.change_scene(ProjectSettings.get('application/run/main_scene'))
	gut.p("ran run setup", 2)

func after_all():
	gut.p("ran run teardown", 2)
	g.remove_node(self)

func test_title_scene_loaded():
	# Simple signature check of scene being loaded.
	assert_not_null(g.get_current_scene().find_node("PottyTimeLabel"), "PottyTimeLabel Check")

func test_credits_scene_load_unload():
	# Show credits
	var button = g.get_current_scene().find_node("CreditsButton")
	button.emit_signal("pressed")
	assert_not_null(g.get_current_scene().find_node("CreditsLabel"), "CreditsLabel Check")

	# Return to main menu
	button = g.get_current_scene().find_node("MainMenuButton")
	button.emit_signal("pressed")
	assert_not_null(g.get_current_scene().find_node("PottyTimeLabel"), "PottyTimeLabel Check")

func test_game_load_unload():
	# Start new game.
	var button = g.get_current_scene().find_node("NewGameButton")
	button.emit_signal("pressed")
	assert_not_null(g.get_current_scene().find_node("GameOverPanel"), "GameOverPanel Check")

	# Return to main menu
	button = g.get_current_scene().find_node("MainMenuButton")
	button.emit_signal("pressed")
	assert_not_null(g.get_current_scene().find_node("PottyTimeLabel"), "PottyTimeLabel Check")
	
	
