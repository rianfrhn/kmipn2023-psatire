extends Button
class_name GameButton

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.menu_state_changed.connect(change_state)

func change_state():
	if(Game.menu_state == Game.STATE.PAUSED):
		disabled = true
	else:
		disabled = false
