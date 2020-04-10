extends Control

onready var NewGameButton = find_node("NewGameButton")
onready var QuitButton = find_node("QuitButton")
onready var CreditsButton = find_node("CreditsButton")


func _ready() -> void:
    NewGameButton.connect("pressed", self, "_on_NewGameButton_pressed")
    QuitButton.connect("pressed", self, "_on_QuitButton_pressed")
    CreditsButton.connect("pressed", self, "_on_CreditsButton_pressed")


func _on_NewGameButton_pressed() -> void:
    g.change_scene("res://Main.tscn")


func _on_QuitButton_pressed() -> void:
    g.quit()


func _on_CreditsButton_pressed() -> void:
    g.change_scene("res://Credits.tscn")
