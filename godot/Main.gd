extends Node

"""
Architecture Synopsis:
Model <-> Control -> Presentation -> View -> [Control]

The general idea here is that the controller never references the View, but the view may signal to the controller.
Controller may manipulate the DomainModel and PresentationModel.
The DomainModel may signal to the Controller.

"""

func _ready():
    # Deterministic startup procedure:
    
    # TODO: This should probably be an object stored in a singleton
    # Controller depends on DomainModel
    $Model.ready()
    # View depends on PresentationModel
    $Presentation.ready()
    $ViewCanvas.ready($Presentation)
    $ViewWidgets.ready($Presentation)
    # Controller initialization allows user interaction
    $Controller.ready($Presentation, $Model)
    $ViewWidgets.controller_ready($Controller)
    $ViewCanvas.controller_ready($Controller)
    $HIDInput.controller_ready($Controller)
