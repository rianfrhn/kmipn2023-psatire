extends VBoxContainer
class_name FarrozItemDisplay

@export var stock_resource : ComponentResource
#	get:
#		return stock_resource
#	set(value):
#		if(value != stock_resource):
#			stock_resource = value
#			update_resource()

#Display Components
@onready var pic_display : TextureRect = get_node("HBoxContainer/TextureRect")
@onready var name_display : RichTextLabel = get_node("NameDisplay")
@onready var desc_display : RichTextLabel = get_node("HBoxContainer/VBoxContainer/RichTextLabel")
@onready var decrement_button : Button = get_node("HBoxContainer/VBoxContainer/HBoxContainer/DecButton")
@onready var increment_button : Button = get_node("HBoxContainer/VBoxContainer/HBoxContainer/IncButton")
@onready var ammount_display : RichTextLabel = get_node("HBoxContainer/VBoxContainer/HBoxContainer/RichTextLabel")

#Variables for data
var stock_pic
var stock_name
var stock_desc
var stock_price
var stock_arrival
var stock_ammount = 0

#Signals
signal ammount_changed()


# Called when the node enters the scene tree for the first time.
func _ready():
	increment_button.pressed.connect(_on_increment)
	decrement_button.pressed.connect(_on_decrement)
	update_resource()



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
	name_display.text = str(stock_name)
	desc_display.text = str(stock_desc) + "\nHarga:" + str(stock_price) + "\nWaktu Pengiriman: "+str(stock_arrival)
	ammount_display.text = "[center]"+str(stock_ammount)
	pic_display.texture = stock_pic
	
	
func _on_increment():
	stock_ammount += 1
	update_data()
	ammount_changed.emit()
	
func _on_decrement():
	if(stock_ammount <= 0):
		return
	stock_ammount -= 1
	update_data()
	ammount_changed.emit()
