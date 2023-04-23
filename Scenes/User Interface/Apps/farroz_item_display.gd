@tool
extends VBoxContainer


@export var stock_resource : StockResource:
	get:
		return stock_resource
	set(value):
		if(value != stock_resource):
			stock_resource = value
			update_resource()

#Display Components
@onready var pic_display : TextureRect = $HBoxContainer/TextureRect
@onready var name_display : RichTextLabel = $Name
@onready var desc_display : RichTextLabel = $HBoxContainer/VBoxContainer/RichTextLabel
@onready var decrement_button : Button = $HBoxContainer/VBoxContainer/HBoxContainer/DecButton
@onready var increment_button : Button = $HBoxContainer/VBoxContainer/HBoxContainer/IncButton
@onready var ammount_display : RichTextLabel = $HBoxContainer/VBoxContainer/HBoxContainer/RichTextLabel

#Variables for data
var stock_pic
var stock_name
var stock_desc
var stock_price
var stock_arrival
var stock_ammount = 0

#Signals
signal ammount_changed(total_price:int)


# Called when the node enters the scene tree for the first time.
func _ready():
	increment_button.pressed.connect(_on_increment())
	decrement_button.pressed.connect(_on_decrement())
	update_resource()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_resource():
	stock_pic = stock_resource.display_picture
	stock_name = stock_resource.stock_name
	stock_price = stock_resource.stock_cost
	stock_desc = stock_resource.stock_desc
	stock_arrival = stock_resource.arrival_days
	update_data()

#Update when data changed
func update_data():
	#pic_display.texture = stock_pic
	name_display.text = stock_name
	desc_display.text = stock_desc + "\nHarga:" + str(stock_price) + "\nWaktu Pengiriman: "+str(stock_arrival)
	ammount_display.text = "[center]"+str(stock_ammount)
	
	
func _on_increment():
	stock_ammount += 1
	update_data()
	
func _on_decrement():
	if(stock_ammount <= 0):
		return
	stock_ammount -= 1
	update_data()
