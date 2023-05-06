extends HBoxContainer
@export var fixable : FixableResource

@onready var product_name_display = $VBoxContainer/ProductName
@onready var kendala_display = $VBoxContainer/ProductKendala
@onready var parts_display = $VBoxContainer/VBoxContainer/PartName
@onready var take_button = $VBoxContainer/Button
var components:Array[StockResource]

# Called when the node enters the scene tree for the first time.
func _ready():
	update_view()
	take_button.pressed.connect(_on_button_pressed)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_view():
	components = fixable.slotted_components
	product_name_display.text = "Nama Produk: "+ str(fixable.name)
	kendala_display.text = "Kendala: "+fixable.get_kendala()
	for comp in components:
		var text : RichTextLabel = ResourceLoader.load("res://Scenes/User Interface/fixable_item_part.tscn").instantiate()
		if comp.is_broken:
			text.text = "- [color=#FF0000]"+str(comp.stock_name)
		else:
			text.text = "- "+str(comp.stock_name)
		parts_display.add_child(text)
func set_fixable(item : FixableResource):
	fixable = item

func _on_button_pressed():
	if(Game.on_hand != null): return
	Game.add_hand(fixable)
	Game.remove_ready(fixable)
