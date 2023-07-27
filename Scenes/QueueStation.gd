extends Station

@onready var trigger = $Trigger
@onready var items_place = $Items
var queue_position
# Called when the node enters the scene tree for the first time.
func _ready():
	outline = $"Queue/Queue2/MeshInstance3D"
	table_name.text = "Meja Inspeksi"
	table_name.add_theme_color_override("font_color", Color("#f8f03e"))
	
	set_items(Game.on_queue)
	initial(items_place)
	set_trigger(trigger)
	Game.queue_added.connect(update_items)
	Game.queue_removed.connect(update_items)
	get_viewport().size_changed.connect(resolution_changed)
	
	mouse_entered.connect(show_outline)
	mouse_exited.connect(hide_outline)
	trigger.body_entered.connect(queue_entered)
	context_label.text = "Ambil/taruh barang ke antrian"
	queue_position = get_viewport().get_camera_3d().unproject_position(global_position) - Vector2(50, 50)

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
	Game.add_queue(fixable)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func queue_entered(body):
	if body is Player:
		prompt_image.global_position = queue_position
func set_label_position():
	table_name.global_position = queue_position - Vector2(-20, 80)

func resolution_changed():
	queue_position = get_viewport().get_camera_3d().unproject_position(global_position) - Vector2(50, 50)
	change_position(queue_position, Vector2.ZERO, Vector2(-20, 80))
