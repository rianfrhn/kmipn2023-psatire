extends Marker3D

@onready var regist_point = $RegistPoint
@onready var regist_leave = $RegistPointSource
@onready var ready_point = $ReadyPoint
@onready var ready_leave = $ReadyPointSource
var on_week_queue : Dictionary = {} # Customer Resource => Customer Model (Customer)

var on_register : Dictionary = {}
var on_served : Dictionary = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	Game.customer_week_queue_added.connect(_on_queue_added)
	Game.register_added.connect(_on_moved_register)
	Game.customer_served.connect(_on_customer_served)
	Game.customer_left.connect(_on_customer_left)
	Game.customer_take_ready.connect(_on_customer_take)
	Game.customer_take_ready_left.connect(_on_customer_take_left)
	Game.generate_week()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_queue_added(customer : CustomerResource):
	print("Spawner detected queue added...")
	if !on_week_queue.keys().has(customer):
		var c_model = customer.get_model()
		on_week_queue[customer] = c_model
		print(str(on_week_queue.keys()))
	else: print("QUEUE ADDED CALLED, CUSOMER NOT FOUND")
			
func _on_moved_register(customer : CustomerResource):
	if on_week_queue.keys().has(customer):
		if !on_register.keys().has(customer):
			on_register[customer] = on_week_queue[customer]
			on_week_queue.erase(customer)
			var c_model = on_register[customer]
			add_child(c_model)
			c_model.global_position = regist_leave.global_position
			c_model.update_target_location(regist_point.global_position)
		else: print("ON MOVED TO REGISTER CALLED, CUSTOMER ALR EXISTS IN REGIST")
	else: 
		print("ON MOVED TO REGISTER CALLED, NOT FOUND IN WEEK QUEUE")
		
		
func _on_customer_served(customer : CustomerResource):
	if on_register.keys().has(customer):
		if !on_served.keys().has(customer):
			on_served[customer] = on_register[customer]
			on_register.erase(customer)
			var c_model = on_served[customer]
			c_model.update_target_location(global_position)
			
			
func _on_customer_left(customer : CustomerResource):
	if on_register.keys().has(customer):
		var c_model = on_register[customer]
		c_model.update_target_location(global_position)
		on_register.erase(customer)
	if on_served.keys().has(customer):
		var c_model = on_register[customer] #
		c_model.update_target_location(global_position)
		on_register.erase(customer)
		
func _on_customer_take(customer : CustomerResource):
	if on_served.keys().has(customer):
		var c_model = on_served[customer] #
		c_model.global_position = ready_leave.global_position
		c_model.update_target_location(ready_point.global_position)
	
func _on_customer_take_left(customer : CustomerResource):
	if on_served.keys().has(customer):
		var c_model = on_served[customer] #
		c_model.update_target_location(global_position)
		on_served.erase(customer)
	
