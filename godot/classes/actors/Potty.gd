extends Actor

func _init(position, model_param).(position, "Potty", model_param):
    pass



# model.perform_to(Thing, Potty, MoveDirAction)
# 


func action_allowed(action, actor = null) -> bool:
    # Until we have a toddler actor, no actions allowed.
    if actor.get_type() == "Toddler":
        
    return false
