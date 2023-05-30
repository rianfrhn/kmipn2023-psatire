extends Resource
class_name FixableResource

@export var id : float
@export var name : String
@export var required_components = [] # PAKE ENUM DI RESOURCECOMPONENT, 0 FOR EMPTY, 
@export var slotted_components = []
@export var defects = []
@export var due_date : int
@export var scene : PackedScene
enum TYPE{Phone, Laptop}
var base_price : int
var price : int
var broken_value = 0

func generate_new(type : TYPE):
	id = randf_range(0,1)
	match(type):
		TYPE.Phone:
			name = "Phone"
			scene = ResourceLoader.load("res://Scenes/Moving/Phone.tscn")
			required_components = [
				ComponentResource.TYPE.LCD,
				ComponentResource.TYPE.BATERAI
			]
			slotted_components = [
				ComponentResource.TYPE.LCD,
				ComponentResource.TYPE.BATERAI
			]
			defects = [0,1]
			base_price = 100000

func get_kendala()->String:
	return "Device saya bermasalah"

func set_price(ammount : int):
	price = ammount

func count_broken_value():
	broken_value = 0
	for n in range(0, required_components.size()):
		if required_components[n] != slotted_components[n]:
			broken_value+=1
		for i in defects:
			broken_value += i
	return broken_value
