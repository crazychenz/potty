extends Node

onready var TestRunner = load("res://addons/gutlite/testrunner.gd")
onready var runner = TestRunner.new()
var opts = {
    'tests': [
        'res://test/unit/test_simple.gd'
    ]
}	

func _ready():
    g.call_deferred('change_scene', "res://Title.tscn")
    $Button.connect("pressed", self, "_on_pressed")
    
    

func _on_pressed():
    if not runner in get_parent().get_children():
        get_parent().add_child(runner)
    runner.test_scripts(opts)
