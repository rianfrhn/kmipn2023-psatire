extends Resource
class_name FixableResource

@export var id : String
@export var name : String
@export var required_components : Array[StockResource]
@export var slotted_components : Array[StockResource]
@export var due_date : int
@export var scene : PackedScene
enum TYPE{Phone, Laptop}
@export var component_type : TYPE

func generate_new(type : TYPE, added : Array[StockResource]):
	id = Game.get_time_string()+Game.get_day_string()+str(type)
	slotted_components = added
	match(type):
		TYPE.Phone:
			name = "Phone"
			scene = ResourceLoader.load("res://Scenes/Moving/Phone.tscn")
			required_components = [
				LCD_Resource.new(true),
				#PhoneBattery_Resource.new(true)
			]
func check_fixed():
	var correct_pt = 0
	for n in range(0, slotted_components.size()):
		if slotted_components[n].get_type() == slotted_components[n].get_type():
			if slotted_components[n].is_broken == false:
				correct_pt += 1
	if correct_pt == required_components.size(): return true
	return false

func get_kendala()->String:
	return "Device saya bermasalah"
