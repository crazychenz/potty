extends Node

onready var tween : Tween = find_node("Tween")
onready var container : ScrollContainer = find_node("ScrollContainer")
onready var MainMenuButton : Button = find_node("MainMenuButton")
onready var CreditsLabel : Label = find_node("CreditsLabel")


func _ready() -> void:
	var creditsSize : Vector2 = CreditsLabel.get_combined_minimum_size()
	MainMenuButton.connect("pressed", self, "_on_MainMenuButton_pressed")
	tween.interpolate_property(container, "scroll_vertical",
		0, creditsSize.y, 10, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func _on_MainMenuButton_pressed() -> void:
	g.change_scene("res://Title.tscn")
