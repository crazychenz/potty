extends Control

onready var NewGameButton = find_node("NewGameButton")
onready var QuitButton = find_node("QuitButton")
onready var CreditsButton = find_node("CreditsButton")
onready var ContinueGameButton = find_node("ContinueGameButton")

func _ready() -> void:
    # If user was playing a game, allow user to continue.
    ContinueGameButton.visible = PottyModel.currently_playing()
    
    ContinueGameButton.connect("pressed", self, "_on_ContinueGameButton_pressed")
    NewGameButton.connect("pressed", self, "_on_NewGameButton_pressed")
    QuitButton.connect("pressed", self, "_on_QuitButton_pressed")
    CreditsButton.connect("pressed", self, "_on_CreditsButton_pressed")


func _on_ContinueGameButton_pressed() -> void:
    PottyModel.pause_bladder(false)
    g.change_scene("res://Main.tscn")


func _on_NewGameButton_pressed() -> void:
    PottyModel.start_new_game()
    g.change_scene("res://Main.tscn")


func _on_QuitButton_pressed() -> void:
    g.quit()


func _on_CreditsButton_pressed() -> void:
    g.change_scene("res://Credits.tscn")
