extends Control

onready var MainMenuButton = find_node("MainMenuButton")

func _ready() -> void:
    MainMenuButton.connect("pressed", self, "_on_MainMenuButton_pressed")

func _on_MainMenuButton_pressed() -> void:
    get_tree().change_scene("res://Title.tscn")
