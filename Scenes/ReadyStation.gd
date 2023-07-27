extends Station

@onready var trigger = $Trigger
@onready var items_place = $Items

var ready_position
# Called when the node enters the scene tree for the first time.
func _ready():
	outline = $"Ready Station/Ready Station2/MeshInstance3D"
	table_name.text = "Meja Siap"
	table_name.add_theme_color_override("font_color", Color("#5fca23"))
	
	set_items(Game.on_ready)
	initial(items_place)
	set_trigger(trigger)
	Game.ready_added.connect(update_items)
	Game.ready_removed.connect(update_items)
	get_viewport().size_changed.connect(resolution_changed)
	
	mouse_entered.connect(show_outline)
	mouse_exited.connect(hide_outline)
	trigger.body_entered.connect(ready_enter)
	context_label.text = "Taruh perbaikan yang selesai"
	ready_position = get_viewport().get_camera_3d().unproject_position(global_position) - Vector2(0, 40)

func _unhandled_input(event):
	if event.is_action_pressed("game_interact"):
		if !waiting_prompt: return
		Game.player_object.set_target_rotation_global(global_position)
		if Game.on_hand == null:
			Game.open_menu(menu)
		else:
			var obj = Game.on_hand
			place_object(obj)
		

func place_object(fixable : FixableResource):
	Game.remove_hand()
	Game.add_ready(fixable)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func ready_enter(body):
	if body is Player:
		prompt_image.position = ready_position

func set_label_position():
	table_name.position = ready_position - Vector2(-50, 50)

func resolution_changed():
	ready_position = get_viewport().get_camera_3d().unproject_position(global_position) - Vector2(0, 40)
	change_position(ready_position, Vector2.ZERO, Vector2(-50, 50))
