extends Control

@onready var items_container = $NinePatchRect/ScrollContainer/VBoxContainer/Items
@onready var take_button = $NinePatchRect/Button
var fixable_items
# Called when the node enters the scene tree for the first time.
func _ready():
	update_view()
	Game.ready_added.connect(update_view)
	Game.ready_removed.connect(update_view)
	pass # Replace with function body.
func add_fixable_item(fixable : FixableResource):
	var fixable_view = ResourceLoader.load("res://Scenes/User Interface/ReadyTable/fixable_item_ready_ui.tscn").instantiate()
	fixable_view.set_fixable(fixable)
	items_container.add_child(fixable_view)

func set_fixable_items(arr : Array[FixableResource]):
	fixable_items = arr

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_view():
	for node in items_container.get_children():
		node.queue_free()
	
	fixable_items = Game.on_ready
	for fixable in fixable_items:
		add_fixable_item(fixable)
		
