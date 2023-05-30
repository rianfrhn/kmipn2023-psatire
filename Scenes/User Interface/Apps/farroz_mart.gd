extends VBoxContainer
@onready var item_container = $FarrozMartBuy/FarrozItems/VBoxContainer
var items : Array[FarrozItemDisplay]= []

@onready var price_text = $FarrozMartBuy/BuyBottom/HBoxContainer/VBoxContainer/RichTextLabel2
var total_price

@onready var buy_button = $FarrozMartBuy/BuyBottom/HBoxContainer/VBoxContainer/Button

# Called when the node enters the scene tree for the first time.
func _ready():
	update_items()
	
	for item in items:
		item.ammount_changed.connect(update_price)

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
		
	
		
