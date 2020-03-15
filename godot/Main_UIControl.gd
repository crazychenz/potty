extends Control

onready var MainMenuButton = find_node("MainMenuButton")
onready var PlayAgainButton = find_node("PlayAgainButton")
onready var ReturnButton = find_node("ReturnButton")


func _ready() -> void:
    MainMenuButton.connect("pressed", self, "_on_MainMenuButton_pressed")
    PlayAgainButton.connect("pressed", self, "_on_PlayAgainButton_pressed")
    ReturnButton.connect("pressed", self, "_on_MainMenuButton_pressed")


func _on_MainMenuButton_pressed() -> void:
    get_tree().change_scene("res://Title.tscn")


func _on_PlayAgainButton_pressed() -> void:
    get_tree().change_scene("res://Main.tscn")
