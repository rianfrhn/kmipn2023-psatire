extends HBoxContainer

@onready var component_name_display = $ComponentName
@onready var component_count_display = $ComponentCount
var component
var component_name
var component_count
# Called when the node enters the scene tree for the first time.
func _ready():
	update_view()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_view():
	component_name_display.text = component_name
	component_count_display.text = str(component_count)
	pass
	
func set_component(_component):
	component = _component
	component_name = Game.component_tostring(component)
	component_count = Game.on_storage[component]
