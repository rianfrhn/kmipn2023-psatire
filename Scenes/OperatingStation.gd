extends Station

@onready var trigger = $Trigger
@onready var items_place = $Items
# Called when the node enters the scene tree for the first time.
func _ready():
	initial(items_place)
	set_trigger(trigger)
	Game.operation_added.connect(update_table)
	Game.operation_removed.connect(update_table)
	Game.operation_updated.connect(update_table)

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
		
	
