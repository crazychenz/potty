extends Node

onready var TestRunner = load("res://addons/gutlite/testrunner.gd")
onready var runner = TestRunner.new()
var opts = {
    'tests': [
        #'res://test/unit/test_simple.gd'
        #'res://test/unit/test_main_controller.gd'
        'res://test/unit/test_grid.gd',
        'res://test/unit/test_model.gd'
    ]
}
var test_timer : Timer = Timer.new()


func _ready():
    g.call_deferred('change_scene', "res://Title.tscn")
    $Button.connect("pressed", self, "_on_pressed")
    test_timer.wait_time = 5
    add_child(test_timer)
    test_timer.connect("timeout", self, "_on_test_timer_timeout")
    test_timer.start()
    
    runner.connect('test_scripts_completed', self, "_on_test_scripts_completed")
    
    # Check command line for testmode argument (for desktop testing)
    for arg in OS.get_cmdline_args():
        if arg == "--testmode":
            var fd := File.new()
            fd.open("user://testmode", File.WRITE)
            fd.store_string("testdata")
            fd.close()
            break


func _on_pressed():
    if not runner in get_parent().get_children():
        get_parent().add_child(runner)
    runner.test_scripts(opts)


func _on_test_timer_timeout():
    # Check file flag that indicates we test (for desktop and mobile)
    if (File.new().file_exists("user://testmode")):
        _on_pressed()
        Directory.new().remove("user://testmode")
    else:
        test_timer.start()


func _on_test_scripts_completed():
    for arg in OS.get_cmdline_args():
        if arg == "-gexit":
            get_tree().quit()
