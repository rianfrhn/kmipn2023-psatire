extends Resource
class_name ComponentResource

@export var type : TYPE
@export var stock_name : String
@export var stock_desc : String
@export var stock_cost : int = 0
@export var arrival_days : int = 1
@export var display_picture : Texture
@export var is_broken = false
@export var complexity = 0
enum TYPE{ #korespon sama id nya
	KOSONG,
	BATERAI,
	LCD,
	KEYBOARD,
	MOTHERBOARD
}

static func getPrice(type : TYPE = 0) -> int:
	match(type):
		TYPE.BATERAI:
			return 80000
		TYPE.LCD:
			return 100000
		TYPE.KEYBOARD:
			return 50000
		TYPE.MOTHERBOARD:
			return 200000
	return 0
	
static func getComplexity(type : TYPE = 0) -> int:
	match(type):
		TYPE.BATERAI:
			return 0
		TYPE.LCD:
			return 1
		TYPE.KEYBOARD:
			return 2
		TYPE.MOTHERBOARD:
			return 3
	return 0

func generate_new_component(new_type: TYPE, broken:bool = false):
	type=new_type
	match(new_type):
		TYPE.BATERAI:
			stock_name = "Baterai Smartphone"
			stock_desc = "Baterai Untuk HP"
			stock_cost = 80000
			arrival_days = 1
			display_picture = ResourceLoader.load("res://Assets/User Interface/Battery.png")
			is_broken = broken
			complexity = 0
		TYPE.LCD:
			stock_name = "LCD"
			stock_desc = "Layar Crystal Display untuk Elektronik"
			stock_cost = 100000
			arrival_days = 1
			display_picture = ResourceLoader.load("res://Assets/User Interface/smartphone.png")
			is_broken = broken
			complexity = 1
		TYPE.KEYBOARD:
			stock_name = "Keyboard"
			stock_desc = "Keyboard pengganti untuk laptop"
			stock_cost = 60000
			arrival_days = 1
			display_picture = ResourceLoader.load("res://Assets/User Interface/smartphone.png")
			is_broken = broken
			complexity = 2
		TYPE.MOTHERBOARD:
			stock_name = "Motherboard X-21"
			stock_desc = "Motherboard canggih khusus laptop"
			stock_cost = 200000
			arrival_days = 1
			display_picture = ResourceLoader.load("res://Assets/User Interface/smartphone.png")
			is_broken = broken
			complexity = 3
			
			
