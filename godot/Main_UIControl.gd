extends Control

var controller
var presentation

onready var MainMenuButton = find_node("MainMenuButton")
onready var PlayAgainButton = find_node("PlayAgainButton")
onready var ReturnButton = find_node("ReturnButton")

onready var GridOutput = find_node("GridOutput")

#onready var BladderValue : ProgressBar = find_node("BladderValue")
#onready var HappinessValue : ProgressBar = find_node("HappinessValue")

func ready(presentation_param):
    presentation = presentation_param
    presentation.connect("updated_state_string", self, "_on_updated_state_string")


func controller_ready(controller_param):
    controller = controller_param
    MainMenuButton.connect("pressed", controller, "_on_MainMenuButton_pressed")
    PlayAgainButton.connect("pressed", controller, "_on_PlayAgainButton_pressed")
    ReturnButton.connect("pressed", controller, "_on_MainMenuButton_pressed")


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
