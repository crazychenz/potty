extends Control

onready var MainMenuButton = find_node("MainMenuButton")
onready var PlayAgainButton = find_node("PlayAgainButton")
onready var ReturnButton = find_node("ReturnButton")

onready var BladderValue : ProgressBar = find_node("BladderValue")
onready var HappinessValue : ProgressBar = find_node("HappinessValue")

func _ready() -> void:
	MainMenuButton.connect("pressed", self, "_on_MainMenuButton_pressed")
	PlayAgainButton.connect("pressed", self, "_on_PlayAgainButton_pressed")
	ReturnButton.connect("pressed", self, "_on_MainMenuButton_pressed")

	LevelState.connect("happiness_decreased", self, "_on_LevelState_happiness_decreased")
	LevelState.connect("happiness_increased", self, "_on_LevelState_happiness_increased")
	LevelState.connect("bladder_increased", self, "_on_LevelState_bladder_increased")

	LevelState.reset_state()


func _on_MainMenuButton_pressed() -> void:
	g.change_scene("res://Title.tscn")


func _on_PlayAgainButton_pressed() -> void:
	g.change_scene("res://Main.tscn")


func _on_LevelState_happiness_decreased(value):
	HappinessValue.value = value

func _on_LevelState_happiness_increased(value):
	HappinessValue.value = value


func _on_LevelState_bladder_increased(value):
	BladderValue.value = value
