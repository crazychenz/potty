extends "res://addons/gutlite/test.gd"

var Model = load("res://Model.gd")
var model

var test_level = 'demo'

# DEMO REFERENCE
#[
#	[' ', '*', ' ', ' ', ' ', ' ', ' ', ' '],
#	[' ', 'D', ' ', ' ', ' ', ' ', ' ', ' '],
#	[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
#	[' ', ' ', ' ', ' ', ' ', 'T', ' ', ' '],
#	[' ', ' ', ' ', ' ', 'W', ' ', ' ', ' '],
#	[' ', ' ', ' ', ' ', ' ', 'C', ' ', ' '],
#	[' ', ' ', ' ', ' ', ' ', 'C', ' ', ' '],
#	[' ', ' ', ' ', ' ', ' ', ' ', ' ', 'P'],
#]

func before_each():
	pass
	
func after_each():
	pass
	
func before_all():
	model = Model.new()
	model.ready(test_level)
	yield(get_tree().create_timer(0.1), "timeout")
	
func after_all():
	pass
	model.call_deferred("free")
	model = null

"""
Things to test:
 - ready
 - init_level
 - check_action
 - check_action_recursive
 - perform_transaction
 - check
 - fini

DONE class Action:
DONE	Transaction perform()

#class Controller:
#	# Given user input:
#	#   - MoveAction
#	#   - PullAction

DONE class Player extends Actor:
DONE	Transaction perform(Action action):
DONE		return action.perform(self)

#class MoveAction extends Action:
#	Direction dir
#
#	Transaction perform(Action):
#		var pos = actor.pos + dir
#		# Check if there is an object, wall, etc
#		# If wall, return a do nothing return
#		# If nothing, return a transaction of 1 action
#		# If something(s) that can be pushed, return transaction

 """

func test_allocation():
	# Simple signature check of scene being loaded.
	assert_not_null(model, "Model load and allocation check")

func test_check_action():
	var action
	var xaction

	# Create action to move play right 1 space.
	action = MoveAction.new(Vector2(1, 0), model)
	xaction = model.player_pretend(action)

	action.unreference()
	action.unreference()
	xaction.unreference()
	xaction.unreference()
	#model.commit(xaction)

	#assert_true(model.check_action(action), "Check action to move play right 1 space.")

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
