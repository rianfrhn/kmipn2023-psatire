extends Station

@onready var trigger = $Trigger
@onready var items_place = $Items
# Called when the node enters the scene tree for the first time.
func _ready():
	set_items(Game.on_queue)
	initial(items_place)
	set_trigger(trigger)
	Game.queue_added.connect(update_items)
	Game.queue_removed.connect(update_items)

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
