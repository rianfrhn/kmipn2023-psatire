extends HBoxContainer

@onready var component_name_display = $ComponentName
@onready var component_add_button = $ComponentAdd
var component
var component_name
var component_count
var slot
signal button_pressed()
# Called when the node enters the scene tree for the first time.
func _ready():
	update_view()
	component_add_button.pressed.connect(_on_pressed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_view():
	component_name_display.text = component_name
	pass
	
func set_component(_component, _slot):
	component = _component
	slot = _slot
	component_name = Game.component_tostring(component)
	component_count = Game.on_storage[component]

func _on_pressed():
	Game.add_component(Game.on_operation, component, slot)
	Game.remove_storage(component, 1)
	button_pressed.emit()
	
