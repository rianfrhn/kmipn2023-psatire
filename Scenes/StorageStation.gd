extends Station

@onready var trigger = $Trigger

var storage_position
# Called when the node enters the scene tree for the first time.
func _ready():
	outline = $"Storage_v2/Storage/MeshInstance3D"
	table_name.text = "Penyimpanan"
	table_name.add_theme_color_override("font_color", Color("#8b2fd7"))
	
	set_trigger(trigger)
	trigger.body_entered.connect(storage_enter)
	
	mouse_entered.connect(show_outline)
	mouse_exited.connect(hide_outline)
	get_viewport().size_changed.connect(resolution_changed)
	
	context_label.text = "Lihat Persediaan"
	storage_position = get_viewport().get_camera_3d().unproject_position(global_position) - Vector2(30, 0)

func _unhandled_input(event):
	if event.is_action_pressed("game_interact"):
		if !waiting_prompt: return
		Game.player_object.set_target_rotation_global(global_position)
		Game.open_menu(menu)
		
func storage_enter(body):
	if body is Player:
		prompt_image.position = storage_position

func set_label_position():
	table_name.position = storage_position + Vector2(20, 0)

func resolution_changed():
	storage_position = get_viewport().get_camera_3d().unproject_position(global_position) - Vector2(30, 0)
	change_position(storage_position, Vector2.ZERO, Vector2(-20, 0))
