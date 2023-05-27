extends Node
class_name CustomerResource
enum GENDER {
	MALE,
	FEMALE
}
@export var gender : GENDER
@export var fixable : FixableResource
@export var retrieval_days : int
@export var model : PackedScene
var arrived = true
var arrival_day : int = 1 #di hari apa
var arrival_hour : int = 7 #di hari apa
var dissatisfaction_day : int = 3
var dissatisfaction_hour : int = 3
var dissatisfaction_delta : int = 1 #brp hari sampe dia leave cash regist
var hour_of_retrieval # hari apa
var day_of_retrieval # hari apa
var week_of_retrieval # minggu ke brp



func initialize(assigned_gender : GENDER = GENDER.MALE,
assigned_fixable = Game.create_new_fixable(FixableResource.TYPE.Phone),
assigned_retrieval_days : int = 5, #brp hari sblm dia ambil lg
arrived : bool = false
):
	gender = assigned_gender
	fixable = assigned_fixable
	retrieval_days = assigned_retrieval_days  
	arrived = false
	model = ResourceLoader.load("res://Scenes/Moving/Customer.tscn")
	
func set_arrival(day : int, hour : int = 7):
	arrival_day = day
	arrival_hour = hour
	var d = arrival_day + dissatisfaction_delta
	dissatisfaction_day = d-5 if d >5 else d
	dissatisfaction_hour = hour
	
func serve():
	var d = arrival_day + 1
	day_of_retrieval = d-5 if d>5 else d
	hour_of_retrieval = arrival_hour

func get_model()->Customer:
	if(model != null):
		var model3d = model.instantiate()
		return model3d
	return null
