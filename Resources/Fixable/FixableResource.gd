extends Resource
class_name FixableResource

@export var id : String
@export var name : String
@export var required_components = [] # PAKE ENUM DI GAME, 0 FOR EMPTY, 
@export var slotted_components = []
@export var defects = []
@export var due_date : int
@export var scene : PackedScene
enum TYPE{Phone, Laptop}
@export var component_type : TYPE

func generate_new(type : TYPE):
	id = Game.get_time_string()+Game.get_day_string()+str(type)
	match(type):
		TYPE.Phone:
			name = "Phone"
			scene = ResourceLoader.load("res://Scenes/Moving/Phone.tscn")
			required_components = [
				Game.COMPONENTS.LCD,
				Game.COMPONENTS.BATTERY
			]
			slotted_components = [
				Game.COMPONENTS.LCD,
				Game.COMPONENTS.BATTERY
			]
			defects = [0,1]

func get_kendala()->String:
	return "Device saya bermasalah"
