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
signal day_changed()
signal week_changed()
signal hour_changed()
var timemin = 0
var timehr = 7

var week = 1
var date = 1
signal date_changed()
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
	
var rating = 1.0

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

func create_new_fixable(resource_enum : FixableResource.TYPE) -> FixableResource:
	var new_fixable = FixableResource.new()
	new_fixable.generate_new(resource_enum)
	return new_fixable

###################
##################
# ON CUSTOMER QUEUE
var on_customer_week_queue : Array[CustomerResource] = [] #Ini pas ngantri tiap week, dmn nnti customernya dateng di hari tertentu
signal customer_week_queue_added(customer : CustomerResource)
func add_customer_week_queue(cust_resource: CustomerResource, arrival_day : int, arrival_hour : int): #pertama di masukin ke queue weekly
	cust_resource.set_arrival(arrival_day, arrival_hour)
	on_customer_week_queue.append(cust_resource)
	print("ADDED CUSTOMER: "+str(cust_resource))
	customer_week_queue_added.emit(cust_resource)

func move_customer_to_register(customer : CustomerResource):
	print("Attempting to move to reister: "+customer.name)
	if on_customer_week_queue.has(customer):
		on_customer_week_queue.erase(customer)
		on_register.append(customer)
		register_added.emit(customer)
		print("ADDED CUSTOMER TO REGISTER: "+customer.name)
		
		
var on_register : Array[CustomerResource] = []
signal register_added(customer : CustomerResource)

var on_customer_served : Array[CustomerResource] = []
signal customer_served(customer : CustomerResource)
signal customer_left(customer : CustomerResource)
func move_customer_to_served(customer : CustomerResource):
	if on_register.has(customer):
		on_customer_served.append(customer)
		customer.serve()
		customer_served.emit(customer)
		on_register.erase(customer)
		

func move_customer_to_leave(customer : CustomerResource):
	if on_register.has(customer):
		on_register.erase(customer)
		customer_left.emit(customer)
		print("Customer from register left")
		
		
	if on_customer_served.has(customer):
		on_customer_served.erase(customer)
		customer_left.emit(customer)
		print("Customer from served left")

func hourly_customer_checker():
	#print("HOURLY CHECKING....")
	for cust in on_customer_week_queue:
		if cust.arrival_day == day && cust.arrival_hour == timehr:
			move_customer_to_register(cust)
	for cust in on_register:
		if cust.dissatisfaction_day == day && cust.dissatisfaction_hour == timehr:
			move_customer_to_leave(cust)
	for cust in on_customer_served:
		if cust.day_of_retrieval == day && cust.hour_of_retrieval == timehr:
			take_ready(cust)

func create_new_customer(type: int, day:int = 1, hour:int = 7):
	var new_customer = CustomerResource.new()
	match type:
		0:
			var gender = CustomerResource.GENDER.MALE
			var fixable = create_new_fixable(FixableResource.TYPE.Phone)
			new_customer.initialize(gender, fixable)
	return new_customer
	
#########
########
# On Cash Register
func serve_customer(customer : CustomerResource, price : int):
	if on_register.has(customer):
		move_customer_to_served(customer)
		add_hand(customer.fixable)
		customer.fixable.set_price(price)
		customer.serve()
		
#On ready table
signal customer_take_ready(customer : CustomerResource)
func take_ready(customer : CustomerResource):
	var cust_fixable = customer.fixable
	customer_take_ready.emit(customer)
	if on_ready.has(cust_fixable):
		on_fixable_done(cust_fixable)
		remove_fromall_stations(customer.fixable)
		await get_tree().create_timer(7.0).timeout
		taken_ready(customer)
	else:
		remove_fromall_stations(customer.fixable)
		await get_tree().create_timer(7.0).timeout
		taken_ready(customer)
	
signal customer_take_ready_left(customer : CustomerResource)
func taken_ready(customer: CustomerResource):
	customer_take_ready_left.emit(customer)
	move_customer_to_leave(customer)

func on_fixable_done(fixable : FixableResource):
	var broken_value = fixable.count_broken_value()
	if broken_value ==0:
		rating += 0.2
	if broken_value <=1:
		add_money(fixable.price)
	if broken_value == 3:
		rating -=0.3
	


func remove_fromall_stations(fixable : FixableResource):
	remove_ready(fixable)
	remove_operation(fixable)
	remove_queue(fixable)
	if on_hand == fixable: remove_hand()
	









####################
# Generate new Week
var customer_median = 7
var customer_randomness = 0
var day_dictionary = {
	1:0, 2:0, 3:0, 4:0, 5:0
}
func generate_week():
	var cust_random = randi_range(-customer_randomness, customer_randomness)
	var customer_count = customer_median + cust_random
	
	for i in range(0, customer_count):
		var day = randi_range(1,5)
		var time = randi_range(7,15)
		var cust = create_new_customer(0)
		add_customer_week_queue(cust, day, time)
	
	



# Called when the node enters the scene tree for the first time.


func _ready():
	timer.timeout.connect(_on_clock_timeout)
	
	# DEBUG
	#var test_fixable = create_new_fixable(FixableResource.TYPE.Phone)
	#add_queue(test_fixable)
	#var test_fixable2 = create_new_fixable(FixableResource.TYPE.Phone)
	#add_queue(test_fixable2)
	
	week_changed.connect(generate_week)
	
	hour_changed.connect(hourly_customer_checker)
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
	hour_changed.emit()
		
func add_day(days:int):
	date += days
	day += days
	day_changed.emit()
	date_changed.emit()
	if(day >= 5):
		date += 1
		day -=5
		add_week(1)

func add_week(weeks:int):
	week += weeks
	week_changed.emit()
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
