extends Control

var component
var slot

func set_slot(n):
	var componentname = $RichTextLabel
	var button = $Button
	var fixable : FixableResource = Game.on_operation
	slot = n
	component = fixable.slotted_components[slot]
	if component == ComponentResource.TYPE.KOSONG:
		button.text = "+"
		button.pressed.connect(_on_add_component)
	else:
		componentname.text = Game.component_tostring(component)
		button.pressed.connect(_on_remove_component)
		
# Called when the node enters the scene tree for the first time.

func _on_add_component():
	print("Adding Component")
	var menu = ResourceLoader.load("res://Scenes/User Interface/OperationTable/AddComponentPart/GameOperationAddComponent.tscn").instantiate()
	menu.set_slot(slot)
	Game.open_menu_instance(menu)
	pass
func _on_remove_component():
	print("Removing Component")
	Game.remove_component(Game.on_operation, slot)
	Game.operation_updated.emit()
