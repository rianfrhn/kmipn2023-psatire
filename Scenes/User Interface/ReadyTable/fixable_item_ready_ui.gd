extends HBoxContainer
@export var fixable : FixableResource

@onready var product_name_display = $VBoxContainer/ProductName
@onready var kendala_display = $VBoxContainer/ProductKendala
@onready var parts_display = $VBoxContainer/VBoxContainer/PartName
@onready var take_button = $VBoxContainer/Button

# Called when the node enters the scene tree for the first time.
func _ready():
	update_view()
	take_button.pressed.connect(_on_button_pressed)
	
	pass # Replace with function body.


func update_view():
	product_name_display.text = "Nama Produk: "+ str(fixable.name)
	kendala_display.text = "Kendala: "+fixable.get_kendala()
	var components = fixable.slotted_components
	for slot in fixable.slotted_components.size():
		var component_num = fixable.slotted_components[slot]
		var text : RichTextLabel = ResourceLoader.load("res://Scenes/User Interface/fixable_item_part.tscn").instantiate()
		if (fixable.defects[slot] == 1 || fixable.required_components[slot] != component_num):
			text.text = "- [color=#FF0000]"+Game.component_tostring(component_num)
		else:
			text.text = "- "+Game.component_tostring(component_num)
			
		if component_num == 0:
			text.text = "- [color=#FF0000]SLOT KOSONG"
		parts_display.add_child(text)
func set_fixable(item : FixableResource):
	fixable = item

func _on_button_pressed():
	if(Game.on_hand != null): return
	Game.add_hand(fixable)
	Game.remove_ready(fixable)
