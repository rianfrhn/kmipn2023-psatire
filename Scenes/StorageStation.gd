extends Station

@onready var trigger = $Trigger
var storage_position
# Called when the node enters the scene tree for the first time.
func _ready():
	set_trigger(trigger)
	trigger.body_entered.connect(storage_enter)
	context_label.text = "Lihat Persediaan"
	storage_position = get_viewport().get_camera_3d().unproject_position(global_position) - Vector2(30, 0)

func _unhandled_input(event):
	if event.is_action_pressed("game_interact"):
		if !waiting_prompt: return
		Game.player_object.set_target_rotation_global(global_position)
		Game.open_menu(menu)
		
func storage_enter(body):
	if body is Player:
		prompt_image.global_position = storage_position
