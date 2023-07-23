extends Station

@onready var trigger = $Trigger
@onready var items_place = $Items

var operating_position
# Called when the node enters the scene tree for the first time.
func _ready():
	outline = $"Operation Table/Operation Table2/MeshInstance3D"
	initial(items_place)
	set_trigger(trigger)
	mouse_entered.connect(show_outline)
	mouse_exited.connect(hide_outline)
	Game.operation_added.connect(update_table)
	Game.operation_removed.connect(update_table)
	Game.operation_updated.connect(update_table)
	trigger.body_entered.connect(operating_entered)
	context_label.text = "Perbaiki barang"
	operating_position = get_viewport().get_camera_3d().unproject_position(global_transform.origin) - Vector2(80, 80)

func _unhandled_input(event):
	if event.is_action_pressed("game_interact"):
		if !waiting_prompt: return
		Game.player_object.set_target_rotation_global(global_position)
		if Game.on_hand == null:
			Game.open_menu(menu)
		else:
			if Game.on_operation == null: 
				var obj = Game.on_hand
				place_object(obj)
		

func place_object(fixable : FixableResource):
	Game.remove_hand()
	Game.add_operation(fixable)
	

func update_table():
	var fixable = Game.on_operation
	if fixable == null:
		set_items([])
	else:
		set_items([Game.on_operation])
		
	update_items()
		

func operating_entered(body):
	if body is Player:
		prompt_image.global_position = operating_position

