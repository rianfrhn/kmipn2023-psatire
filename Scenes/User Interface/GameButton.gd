extends Button
class_name GameButton

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.game_state_changed.connect(change_state)
	Game.menu_state_changed.connect(change_state)
	
func change_state():
	if(Game.game_state == Game.STATE.PAUSED || Game.menu_state == Game.STATE.PAUSED):
		disabled = true
	else:
		disabled = false

