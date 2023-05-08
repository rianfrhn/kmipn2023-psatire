extends Control

@onready var items_container = $NinePatchRect/ScrollContainer/VBoxContainer/Items
@onready var take_button = $NinePatchRect/Button
var components
# Called when the node enters the scene tree for the first time.
func _ready():
	update_view()
	Game.storage_changed.connect(update_view)
	
	
	
	
	pass # Replace with function body.
func add_component(component):
	var component_view = ResourceLoader.load("res://Scenes/User Interface/Storage/component_storage_ui.tscn").instantiate()
	component_view.set_component(component)
	items_container.add_child(component_view)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_view():
	for node in items_container.get_children():
		node.queue_free()
	
	components = Game.on_storage
	for n in components.size():
		if n==0: continue
		if components[n] == 0: continue
		add_component(n)
		
