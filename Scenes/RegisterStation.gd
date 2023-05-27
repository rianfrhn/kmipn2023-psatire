extends Station

@onready var trigger = $Trigger
# Called when the node enters the scene tree for the first time.
func _ready():
	set_trigger(trigger)

func _unhandled_input(event):
	if event.is_action_pressed("game_interact"):
		if !waiting_prompt: return
		Game.player_object.set_target_rotation_global(global_position)
		Game.open_menu(menu)
		
