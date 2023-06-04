extends VBoxContainer
@onready var item_container = $FarrozMartBuy/FarrozItems/VBoxContainer
var items : Array[FarrozItemDisplay]= []

@onready var price_text = $FarrozMartBuy/BuyBottom/HBoxContainer/VBoxContainer/RichTextLabel2
var total_price

@onready var buy_button = $FarrozMartBuy/BuyBottom/HBoxContainer/VBoxContainer/Button

@onready var binds = [
	{
		$FarrozMartHome/Belanja: [$FarrozMartHome, $FarrozMartBuy]
	}
]
func get_binds():
	return binds
# Called when the node enters the scene tree for the first time.
func _ready():
	generate_items()
	update_items()
	update_price()
	for item in items:
		item.ammount_changed.connect(update_price)
		
	buy_button.pressed.connect(on_buy)

func update_items():
	for item in item_container.get_children():
		if item is FarrozItemDisplay:
			items.append(item)
	print("ITEMS IN FARROZMART: "+str(items.size()))

func update_price():
	total_price = 0
	for item in items:
		var price = item.stock_price * item.stock_ammount
		total_price += price
	if total_price > Game.money:
		price_text.text = "[right]Rp.[color=#FF0000]"+str(total_price)
		buy_button.disabled = true
	else:
		price_text.text = "[right]Rp."+str(total_price)
		buy_button.disabled = false
		
func on_buy():
	for item in items:
		if item.stock_ammount == 0: continue
		var price = item.stock_price * item.stock_ammount
		Game.add_storage(item.stock_resource.type, item.stock_ammount)
		item.stock_ammount = 0
		item.update_data()
	print(total_price)
	Game.money_spent += total_price
	Game.remove_money(total_price)
	update_price()
		
func create_item(type : ComponentResource.TYPE):
	var itemdisplay = load("res://Scenes/User Interface/Apps/farroz_item_display.tscn").instantiate()
	var compres = ComponentResource.new()
	compres.generate_new_component(type)
	itemdisplay.stock_resource = compres
	item_container.add_child(itemdisplay)

func generate_items():
	
	for i in range(1, ComponentResource.TYPE.values().size()):
		create_item(i)
		print("created item "+str(i))
