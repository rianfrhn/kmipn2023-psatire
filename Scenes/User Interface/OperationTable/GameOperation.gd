extends Control

@onready var items_container = $NinePatchRect/ScrollContainer/VBoxContainer/Items
@onready var take_button = $NinePatchRect/Button
var fixable_item
# Called when the node enters the scene tree for the first time.
func _ready():
	update_view()
	Game.operation_added.connect(update_view)
	Game.operation_removed.connect(update_view)
	Game.operation_updated.connect(update_view)
	pass # Replace with function body.
func add_fixable_item(fixable : FixableResource):
	var fixable_view = ResourceLoader.load("res://Scenes/User Interface/OperationTable/fixable_item_operation_ui.tscn").instantiate()
	fixable_view.set_fixable(fixable)
	fixable_view.button_pressed.connect(destroy_this)
	items_container.add_child(fixable_view)

func set_fixable_item(fixable : FixableResource):
	fixable_item = fixable

# Called every frame. 'delta' is the elapsed time since the previous frame.
func destroy_this():
	queue_free()

func update_view():
	for node in items_container.get_children():
		node.queue_free()
	
	fixable_item = Game.on_operation
	if fixable_item == null: return
	add_fixable_item(fixable_item)
		
