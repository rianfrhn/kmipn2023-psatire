extends Station

@onready var trigger = $Trigger
@onready var items_place = $Items
# Called when the node enters the scene tree for the first time.
func _ready():
	set_items(Game.on_ready)
	initial(items_place)
	set_trigger(trigger)
	Game.ready_added.connect(update_items)
	Game.ready_removed.connect(update_items)

func _unhandled_input(event):
	if event.is_action_pressed("game_interact"):
		if !waiting_prompt: return
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
