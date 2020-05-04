extends Node

"""
Architecture Synopsis:
Model <-> Control -> Presentation -> View -> [Control]

The general idea here is that the controller never references the View, but the view may signal to the controller.
Controller may manipulate the DomainModel and PresentationModel.
The DomainModel may signal to the Controller.

"""

#var Model = load("res://Model.gd")
#var model = Model.new()

func _ready():
    # Deterministic startup procedure:
    
    $Presentation.ready()
    $ViewCanvas.ready($Presentation)
    $ViewWidgets.ready($Presentation)
    
    # Controller depends on DomainModel
    ##model.ready(LevelState.levels[LevelState.current_level]['layout'])
    #$Model.start()
    # View depends on PresentationModel
    
    # Controller initialization allows user interaction
    $Controller.ready($Presentation, $Model)
    $ViewWidgets.controller_ready($Controller)
    $ViewCanvas.controller_ready($Controller)
    $HIDInput.controller_ready($Controller)
    $Presentation.controller_ready($Controller)
    ##model.emit_signal("updated")
    pass
