extends Actor

func _init(position).(position, "player"):
    pass

func pretend(action, model) -> Transaction:
    return action.perform(self)

