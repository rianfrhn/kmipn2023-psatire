extends Node


@onready var timer : Timer = $Timer
@onready var on_screen : Node = $OnScreen
@onready var work_timer : Timer = $WorkTimer

enum STATE{ #
	RUNNING,
	PAUSED
}
var game_state : STATE = STATE.RUNNING 
signal game_state_changed()
func change_game_state(state : STATE):
	game_state = state
	game_state_changed.emit()


var menu_state : STATE = STATE.RUNNING #Kalo lg kerja, menu di pause, gabisa close
signal menu_state_changed()
func change_menu_state(state : STATE):
	menu_state = state
	menu_state_changed.emit()
	



var day = 0
var timemin = 0
var timehr = 7

var week = 1
var date = 1
var month = 1


var player_object
##############
# Money
var money = 370000
signal money_changed()

func add_money(ammount : int):
	money += ammount
	
func remove_money(ammount : int):
	money -= ammount
########################
# REQUEST TABLE
var request : Array[FixableResource] = []
signal request_added()
signal request_removed()

func add_request(fixable: FixableResource):
	request.append(fixable)
	request_added.emit()

func remove_request(fixable: FixableResource):
	if request.has(fixable):
		request.erase(fixable)
		request_removed.emit()
##########################
#########################
# READY TABLE
var on_ready : Array[FixableResource] = []
signal ready_added()
signal ready_removed()

func add_ready(fixable: FixableResource):
	on_ready.append(fixable)
	ready_added.emit()

func remove_ready(fixable: FixableResource):
	if on_ready.has(fixable):
		on_ready.erase(fixable)
		ready_removed.emit()
		
###############################
################################
# OPERATION TABLE
var on_operation : FixableResource
signal operation_added()
signal operation_updated()
signal operation_removed()
signal working()
signal not_working()

func add_operation(fixable: FixableResource):
	on_operation = fixable
	operation_added.emit()

func add_component(fixable: FixableResource, component_id: int, slot: int, duration:float = 10):
	working.emit()
	work_timer.wait_time = duration
	work_timer.start()
	player_object.change_move_state(Player.MOVE_STATE.REPAIRING)
	await work_timer.timeout
	not_working.emit()
	player_object.change_move_state(Player.MOVE_STATE.IDLE)
	fixable.slotted_components[slot] = component_id
	operation_updated.emit()
	
func remove_component(fixable: FixableResource, slot: int, duration:float = 10):
	working.emit()
	player_object.change_move_state(Player.MOVE_STATE.REPAIRING)
	work_timer.wait_time = duration
	work_timer.start()
	await work_timer.timeout
	player_object.change_move_state(Player.MOVE_STATE.IDLE)
	not_working.emit()
	fixable.slotted_components[slot] = ComponentResource.TYPE.KOSONG
	fixable.defects[slot] = 0
	operation_updated.emit()
	
func component_tostring(type : int)->String:
	return ComponentResource.TYPE.keys()[type]

func remove_operation(fixable: FixableResource):
	on_operation = null
	operation_removed.emit()

##############################
##########################
# STORAGE
var on_storage : Dictionary = {# 'type' -> 'ammount'
	0: 0,
	1: 3,
	2: 3
} 
signal storage_changed

func add_storage(component_type : int, count: int):
	on_storage[component_type] += count
	storage_changed.emit()
	
func remove_storage(component_type: int, count:int) -> bool:
	if on_storage[component_type] - count <= 0: return false
	on_storage[component_type] -= count
	storage_changed.emit()
	return true

func get_new_component_by_id(id: int, is_broken : bool):
	var comp = ComponentResource.new().generate_new_component(id, is_broken)
	return comp
	
############################
#################################
# QUEUE TABLE
var on_queue : Array[FixableResource] = []

signal queue_added()
signal queue_removed(fixable : FixableResource)

func add_queue(fixable: FixableResource):
	on_queue.append(fixable)
	queue_added.emit()

func remove_queue(fixable: FixableResource):
	if on_queue.has(fixable):
		on_queue.erase(fixable)
		queue_removed.emit()

#######################
####################
# ON HAND
var on_hand : FixableResource
signal hand_changed()

func add_hand(fixable: FixableResource):
	if on_hand != null: return
	on_hand = fixable
	hand_changed.emit()
	
func remove_hand():
	if on_hand == null: return
	on_hand = null
	hand_changed.emit()

func create_new_fixable(type : String) -> FixableResource:
	var new_fixable = FixableResource.new()
	match type:
		"Phone":
			new_fixable.generate_new(FixableResource.TYPE.Phone)
	return new_fixable

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.timeout.connect(_on_clock_timeout)
	
	# DEBUG
	var test_fixable = create_new_fixable("Phone")
	add_queue(test_fixable)
	var test_fixable2 = create_new_fixable("Phone")
	add_queue(test_fixable2)
	
	add_storage(ComponentResource.TYPE.LCD, 3)
	add_storage(ComponentResource.TYPE.BATERAI, 2)
	
	
	pass # Replace with function body.
	




func open_menu_path(path: String)->Node:
	var scene : Node = ResourceLoader.load(path).instantiate()
	on_screen.add_child(scene)
	return scene
	pass
func open_menu_instance(node: Node)->Node:
	on_screen.add_child(node)
	return node
	pass

func open_menu(resource : PackedScene)->Node:
	if(resource == null): return
	var scene = resource.instantiate()
	on_screen.add_child(scene)
	return scene
	

func _on_clock_timeout():
	add_time_min(10)
	pass
	
func add_time_min(minutes:int):
	timemin+=minutes
	if(timemin>=60):
		timemin -=60
		add_time_hr(1)

func add_time_hr(hours:int):
	timehr += hours
	if(timehr >= 16):
		timehr =7
		add_day(1)
		
func add_day(days:int):
	date += days
	day += days
	if(day >= 5):
		date += 1
		day -=5
		add_week(1)

func add_week(weeks:int):
	week += weeks
	if(week % 4 == 1):
		date = 1
		add_month(1)
	
func add_month(months:int):
	month += months

func get_day_string() -> String :
	match day:
		0: return "Minggu"
		1: return "Senin"
		2: return "Selasa"
		3: return "Rabu"
		4: return "Kamis"
		5: return "Jumat"
		_: return ""
		
func get_time_string() -> String :
	return str(timehr) + ":" + str(timemin).pad_zeros(2)

func get_month_string() -> String :
	match month:
		1: return "Januari"
		2: return "Februari"
		3: return "Maret"
		4: return "April"
		5: return "Mei"
		6: return "Juni"
		7: return "Juli"
		8: return "Agustus"
		9: return "September"
		10: return "Oktober"
		11: return "November"
		12: return "Desember"
		_: return ""
		
func get_full_date_string() -> String:
	return str(date)+ " " + get_month_string()
