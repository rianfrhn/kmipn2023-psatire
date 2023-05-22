extends Resource
class_name ComponentResource

@export var type : TYPE
@export var stock_name : String
@export var stock_desc : String
@export var stock_cost : int = 0
@export var arrival_days : int = 1
@export var display_picture : Texture
@export var is_broken = false

enum TYPE{ #korespon sama id nya
	KOSONG,
	BATERAI,
	LCD
}

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
		TYPE.LCD:
			stock_name = "LCD"
			stock_desc = "Layar Crystal Display untuk Elektronik"
			stock_cost = 100000
			arrival_days = 3
			display_picture = ResourceLoader.load("res://Assets/User Interface/smartphone.png")
			is_broken = broken
			
