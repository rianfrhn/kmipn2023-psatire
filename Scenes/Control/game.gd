extends Node


@onready var timer : Timer = $Timer
@onready var on_screen : Node = $OnScreen
var day = 0
var timemin = 0
var timehr = 7

var week = 1
var date = 1
var month = 1
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

func add_operation(fixable: FixableResource):
	on_operation = fixable
	operation_added.emit()

func add_component(fixable: FixableResource, component: StockResource):
	var required = fixable.required_components
	var slotted = fixable.slotted_components
	if required.size() <= slotted.size(): return
	slotted.add(component)
	operation_updated.emit()
	
func remove_component(fixable: FixableResource, component: StockResource):
	var required = fixable.required_components
	var slotted = fixable.slotted_components
	if slotted.size()==0: return
	if slotted.has(component):
		slotted.erase(component)
		operation_updated.emit(fixable)

func remove_operation(fixable: FixableResource):
	on_operation = null
	operation_removed.emit()

##############################
##########################
# STORAGE
var on_storage : Dictionary = Dictionary()
signal storage_changed

func add_storage(stock : StockResource, count: int):
	if !on_storage.has(stock):
		on_storage[stock] = 0
	on_storage[stock] += count
	storage_changed.emit()
	
func remove_storage(stock: StockResource, count:int) -> bool:
	if !on_storage.has(stock):
		on_storage[stock] = 0
	if on_storage[stock] - count <= 0: return false
	on_storage[stock] -= count
	storage_changed.emit()
	return true
	
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
			var comp1 = LCD_Resource.new(false)
			
			var components : Array[StockResource] = [
				comp1
			]
			new_fixable.generate_new(FixableResource.TYPE.Phone, components)
	return new_fixable

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.timeout.connect(_on_clock_timeout)
	
	# DEBUG
	var test_fixable = create_new_fixable("Phone")
	add_queue(test_fixable)
	var test_fixable2 = create_new_fixable("Phone")
	add_queue(test_fixable2)
	
	
	
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func open_menu_path(path: String)->Node:
	var scene : Node = ResourceLoader.load(path).instantiate()
	on_screen.add_child(scene)
	return scene
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
