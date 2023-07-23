extends Station

@onready var trigger = $Trigger
@onready var items_place = $Items
# Called when the node enters the scene tree for the first time.

var queue_position
func _ready():
	outline = $"Queue/Queue2/MeshInstance3D"
	set_items(Game.on_queue)
	initial(items_place)
	set_trigger(trigger)
	mouse_entered.connect(show_outline)
	mouse_exited.connect(hide_outline)
	Game.queue_added.connect(update_items)
	Game.queue_removed.connect(update_items)
	trigger.body_entered.connect(queue_entered)
	context_label.text = "Ambil/taruh barang ke antrian"
	queue_position = get_viewport().get_camera_3d().unproject_position(global_position) - Vector2(80, 70)

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
	

func queue_entered(body):
	if body is Player:
		prompt_image.global_position = queue_position

func show_outline():
	outline.visible = true
