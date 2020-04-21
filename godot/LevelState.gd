extends Node

signal game_over

signal happiness_gone
signal bladder_full
signal level_complete

signal happiness_decreased(amount)
signal happiness_increased(amount)
signal bladder_increased(amount)

# properties
var bladder : float = 0
var bladder_fill_rate : float = 1
var max_bladder : float = 100
var happiness : float = 100
var min_happiness : float = 0
var max_happiness : float = 100

var current_level = 1
var last_level = 7

var levels := {
    'demo': {
        'layout': [
            [' ', '*', ' ', ' ', ' ', ' ', ' ', ' '],
            [' ', 'D', ' ', ' ', ' ', ' ', ' ', ' '],
            [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
            [' ', ' ', ' ', ' ', ' ', 'T', ' ', ' '],
            [' ', ' ', ' ', ' ', 'W', ' ', ' ', ' '],
            [' ', ' ', ' ', ' ', ' ', 'C', ' ', ' '],
            [' ', ' ', ' ', ' ', ' ', 'C', ' ', ' '],
            [' ', ' ', ' ', ' ', ' ', ' ', ' ', 'P'],
        ]
    },
    1: {
        'layout': [
            ['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
            ['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
            ['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
            [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
            [' ', '*', ' ', 'T', ' ', ' ', 'P', ' '],
            [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
            ['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
            ['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
        ]
    },
    2: {
        'layout': [
            ['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
            ['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
            ['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
            [' ', ' ', ' ', 'W', 'W', 'W', 'W', 'W'],
            [' ', '*', ' ', 'D', 'T', ' ', 'P', ' '],
            [' ', ' ', ' ', 'W', 'W', 'W', 'W', 'W'],
            ['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
            ['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
        ]
    },
    3: {
        'layout': [
            [' ', ' ', ' ', ' ', 'W', 'W', 'W', 'W'],
            [' ', ' ', ' ', ' ', 'W', 'W', 'W', 'W'],
            [' ', '*', ' ', ' ', 'T', 'W', 'W', 'W'],
            [' ', ' ', ' ', ' ', 'W', 'W', 'W', 'W'],
            [' ', ' ', ' ', ' ', 'W', 'W', 'W', 'W'],
            [' ', ' ', ' ', ' ', 'P', 'W', 'W', 'W'],
            [' ', ' ', ' ', ' ', 'W', 'W', 'W', 'W'],
            [' ', ' ', ' ', ' ', 'W', 'W', 'W', 'W'],
        ]
    },
    4: {
        'layout': [
            [' ', ' ', ' ', ' ', 'W', 'W', 'W', 'W'],
            [' ', '*', ' ', ' ', 'W', 'W', 'W', 'W'],
            [' ', ' ', ' ', ' ', 'T', 'W', 'W', 'W'],
            ['W', 'W', 'W', ' ', 'W', 'W', 'W', 'W'],
            ['W', 'W', 'W', 'D', 'W', 'W', 'W', 'W'],
            ['W', 'W', 'W', 'P', 'W', 'W', 'W', 'W'],
            ['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
            ['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
        ]
    },
    5: {
        'layout': [
            ['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
            ['P', 'D', ' ', 'D', ' ', 'D', 'T', ' '],
            ['W', ' ', 'W', ' ', 'W', ' ', 'W', ' '],
            ['W', ' ', 'W', ' ', 'W', ' ', 'W', ' '],
            ['W', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
            ['W', 'W', 'W', 'W', 'W', 'W', 'W', ' '],
            ['W', '*', ' ', ' ', ' ', ' ', ' ', ' '],
            ['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
        ]
    },
    6: {
        'layout': [
            ['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
            ['P', 'D', ' ', 'C', ' ', 'D', ' ', ' '],
            ['W', ' ', 'W', ' ', 'W', 'T', 'W', ' '],
            ['W', ' ', 'W', ' ', 'W', ' ', 'W', ' '],
            ['W', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
            ['W', 'W', 'W', 'W', 'W', 'W', 'W', ' '],
            ['W', '*', ' ', ' ', ' ', ' ', ' ', ' '],
            ['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
        ]
    },
    7: {
        'layout': [
            ['*', ' ', 'T', ' ', ' ', ' ', ' ', ' '],
            ['W', 'W', 'W', 'W', 'W', 'W', ' ', ' '],
            ['W', 'W', 'W', 'W', 'W', ' ', ' ', ' '],
            [' ', ' ', 'C', ' ', ' ', ' ', ' ', 'C'],
            [' ', ' ', ' ', 'W', 'W', 'W', 'W', 'W'],
            [' ', ' ', 'W', 'W', 'W', 'W', 'W', 'W'],
            [' ', ' ', 'C', ' ', ' ', ' ', ' ', 'P'],
            ['W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'],
        ]
    },
}

var BladderTimer : Timer = Timer.new()

func _notification(what):
    if what == NOTIFICATION_PREDELETE:
        _fini()

func _fini():
    if is_instance_valid(BladderTimer):
        BladderTimer.free()

func _ready() -> void:
    add_child(BladderTimer)
    BladderTimer.connect("timeout", self, "_on_BladderTimer_timeout")
    reset_state()


func reset_state():
    bladder = 0
    happiness = 100
    BladderTimer.wait_time = 0.7
    BladderTimer.start()


func _on_BladderTimer_timeout():
    increase_bladder(bladder_fill_rate)
    BladderTimer.start()


func decrease_happiness(amount):
    happiness -= amount
    happiness = max(happiness, min_happiness)
    if amount >= 0:
        emit_signal("happiness_decreased", happiness)
    if happiness == min_happiness:
        emit_signal("happiness_gone")
        # Game over


func increase_happiness(amount):
    happiness += amount
    happiness = min(happiness, max_happiness)
    emit_signal("happiness_increased", happiness)


func increase_bladder(amount):
    bladder += amount
    bladder = min(bladder, max_bladder)
    if amount >= 0:
        emit_signal("bladder_increased", bladder)
    if bladder == max_bladder:
        emit_signal("bladder_full")
        # Game over


func level_complete():
    # TODO: Using replay for goto next level for now.
    if current_level == last_level:
        current_level = 1
        game_over()
    else:
        current_level += 1
        game_over()


func game_over():
    emit_signal("game_over")
    BladderTimer.stop()
