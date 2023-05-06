extends HBoxContainer
@export var fixable : FixableResource

@onready var product_name_display = $VBoxContainer/ProductName
@onready var kendala_display = $VBoxContainer/ProductKendala
@onready var parts_display = $VBoxContainer/VBoxContainer/PartName
@onready var take_button = $VBoxContainer/HBoxContainer/ButtonAmbil
@onready var option_button = $VBoxContainer/HBoxContainer/ButtonAtur
var components:Array[StockResource]

# Called when the node enters the scene tree for the first time.
func _ready():
	update_view()
	take_button.pressed.connect(_on_button_pressed)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_view():
	if fixable == null: return
	components = fixable.slotted_components
	product_name_display.text = "Nama Produk: "+ str(fixable.name)
	kendala_display.text = "Kendala: "+fixable.get_kendala()
	for n in fixable.required_components.size():
		var comp
		if n >= fixable.slotted_components.size():
			comp = null
		else:
			comp = components[n]
		var item = ResourceLoader.load("res://Scenes/User Interface/OperationTable/fixable_item_operation_part.tscn").instantiate()
		item.set_component(comp)
		parts_display.add_child(item)
func set_fixable(item : FixableResource):
	fixable = item

func _on_button_pressed():
	if(Game.on_hand != null): return
	Game.add_hand(fixable)
	Game.remove_operation(fixable)
