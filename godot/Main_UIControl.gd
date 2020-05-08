extends Control

var controller
var presentation

onready var MainMenuButton = find_node("MainMenuButton")
onready var PlayAgainButton = find_node("PlayAgainButton")
onready var NextLevelButton = find_node("NextLevelButton")
onready var ReturnButton = find_node("ReturnButton")
onready var GameOverLabel = find_node("GameOverLabel")
onready var GridOutput = find_node("GridOutput")
onready var HappinessValue = find_node("HappinessValue")
onready var BladderValue = find_node("BladderValue")

#onready var BladderValue : ProgressBar = find_node("BladderValue")
#onready var HappinessValue : ProgressBar = find_node("HappinessValue")

func ready(presentation_param):
    presentation = presentation_param
    presentation.connect("updated_state_string", self, "_on_updated_state_string")
    presentation.connect("goal_reached", self, "_on_goal_reached")
    presentation.connect("timescale_change", self, "_on_timescale_change")
    presentation.connect("game_beat", self, "_on_game_beat")
    presentation.connect("happiness_updated", self, "_on_happiness_updated")
    presentation.connect("bladder_updated", self, "_on_bladder_updated")


func _on_happiness_updated(value):
    HappinessValue.value = value


func _on_bladder_updated(value):
    BladderValue.value = value


func _on_timescale_change():
    $Timescale.text = "Time Scale: %s" % Engine.time_scale


func _on_game_beat():
    GameOverLabel.text = "Game Complete"
    NextLevelButton.visible = false
    $GameOverPanel.set_visible(true)


func _on_goal_reached():
    GameOverLabel.text = "Level Complete"
    $GameOverPanel.set_visible(true)


func controller_ready(controller_param):
    controller = controller_param
    MainMenuButton.connect("pressed", controller, "_on_MainMenuButton_pressed")
    NextLevelButton.connect("pressed", controller, "_on_NextLevelButton_pressed")
    PlayAgainButton.connect("pressed", controller, "_on_PlayAgainButton_pressed")
    ReturnButton.connect("pressed", controller, "_on_MainMenuButton_pressed")
    
    controller.model.connect("meta_update", self, "_on_meta_update")
    

func _on_meta_update(info):
    $MetaInfo.text = info


func _on_updated_state_string(string, width, height):
    var grid_text = ""
    for y in range(0, height):
        for x in range(0, width):
            grid_text += string[y * height + x]
        grid_text += "\n"
    GridOutput.text = grid_text

#func _ready() -> void:

#
#	LevelState.connect("happiness_decreased", self, "_on_LevelState_happiness_decreased")
#	LevelState.connect("happiness_increased", self, "_on_LevelState_happiness_increased")
#	LevelState.connect("bladder_increased", self, "_on_LevelState_bladder_increased")
#
#	LevelState.reset_state()
#
#
#func _on_LevelState_happiness_decreased(value):
#	HappinessValue.value = value
#
#func _on_LevelState_happiness_increased(value):
#	HappinessValue.value = value
#
#
#func _on_LevelState_bladder_increased(value):
#	BladderValue.value = value
