extends Control

onready var NewGameButton = find_node("NewGameButton")
onready var QuitButton = find_node("QuitButton")

func _ready() -> void:
    NewGameButton.connect("pressed", self, "_on_NewGameButton_pressed")
    QuitButton.connect("pressed", self, "_on_QuitButton_pressed")

func _on_NewGameButton_pressed() -> void:
    get_tree().change_scene("res://Main.tscn")

func _on_QuitButton_pressed() -> void:
    get_tree().quit()
