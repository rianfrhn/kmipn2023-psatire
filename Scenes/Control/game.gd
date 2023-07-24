extends Node


@onready var timer : Timer = $Timer
@onready var on_screen : Node = $OnScreen
@onready var work_timer : Timer = $WorkTimer
@onready var playersfx = $PlayerSFX
@onready var custsfx = $CustomerSFX


func playsound(node : AudioStreamPlayer, sound : String = ""):
	node.stream = load(sound) if sound != "" else null
	node.play()
	
enum STATE{ #
	RUNNING,
	PAUSED
}
var game_state : STATE = STATE.RUNNING 
signal game_state_changed()
func change_game_state(state : STATE):
	match state:
		STATE.RUNNING:
			timer.start()
		STATE.PAUSED:
			timer.stop()
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
var money = 1000000
signal money_changed()

func add_money(ammount : int):
	playsound(playersfx, "res://Assets/Sound Effect/SellBuy.wav")
	money += ammount
	money_changed.emit()
	
	
func remove_money(ammount : int):
	playsound(playersfx, "res://Assets/Sound Effect/SellBuy.wav")
	money -= ammount
	money_changed.emit()
	
var rating = 1.0
#######################
# WEEKLY STATS
var previous_money = 0
var after_money = 0
var money_spent = 0
var modal = 0
var profit = 0
var previous_rating = 0
var after_rating = 0
var customer_satisfied = 0
var customer_denied = 0
var num_customer_served = 0

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
var ready_capacity = 4
@export var on_ready : Array[FixableResource] = []
signal ready_added()
signal ready_removed()
signal ready_opened()

func add_ready(fixable: FixableResource):
	on_ready.append(fixable)
	playsound(playersfx, "res://Assets/Sound Effect/ItemDrop.wav")
	ready_added.emit()

func remove_ready(fixable: FixableResource):
	if on_ready.has(fixable):
		on_ready.erase(fixable)
		ready_removed.emit()
		return true
	return false
		
###############################
################################
# OPERATION TABLE
var on_operation : FixableResource
signal operation_opened()
signal operation_added()
signal operation_updated()
signal operation_removed()
signal working()
signal not_working()

func add_operation(fixable: FixableResource):
	on_operation = fixable
	playsound(playersfx, "res://Assets/Sound Effect/ItemDrop.wav")
	operation_added.emit()

signal component_added()
func add_component(fixable: FixableResource, component_id: int, slot: int, duration:float = 10):
	working.emit()
	work_timer.wait_time = duration
	work_timer.start()
	player_object.change_move_state(Player.MOVE_STATE.REPAIRING)
	Game.change_menu_state(Game.STATE.PAUSED)
	var _minigame = load("res://Scenes/User Interface/InsertComponentGameplay/insert_component_gameplay.tscn").instantiate()
	_minigame.initialize(ComponentResource.getComplexity(component_id))
	var minigame = open_menu_instance(_minigame)
	await minigame.minigame_done
	not_working.emit()
	Game.change_menu_state(Game.STATE.RUNNING)
	player_object.change_move_state(Player.MOVE_STATE.IDLE)
	if fixable == null: return
	fixable.slotted_components[slot] = component_id
	operation_updated.emit()
	component_added.emit()
	
signal component_removed()
func remove_component(fixable: FixableResource, slot: int, duration:float = 10):
	working.emit()
	player_object.change_move_state(Player.MOVE_STATE.REPAIRING)
	work_timer.wait_time = duration
	work_timer.start()
	Game.change_menu_state(Game.STATE.PAUSED)
	var component_id = fixable.slotted_components[slot]
	var _minigame = load("res://Scenes/User Interface/RemoveComponentGameplay/remove_component_gameplay.tscn").instantiate()
	_minigame.initialize(ComponentResource.getComplexity(component_id))
	var minigame = open_menu_instance(_minigame)
	await minigame.minigame_done
	Game.change_menu_state(Game.STATE.RUNNING)
	player_object.change_move_state(Player.MOVE_STATE.IDLE)
	not_working.emit()
	fixable.slotted_components[slot] = ComponentResource.TYPE.KOSONG
	fixable.defects[slot] = 0
	operation_updated.emit()
	component_removed.emit()
	
func component_tostring(type : int)->String:
	return ComponentResource.TYPE.keys()[type]

func remove_operation(fixable: FixableResource):
	if on_operation == fixable:
		on_operation = null
		operation_removed.emit()
		return true
	return false

##############################
##########################
# STORAGE
var on_storage : Dictionary = {# 'type' -> 'ammount'
	0: 0,
	1: 3,
	2: 3
} 
signal storage_changed
signal storage_opened()

func add_storage(component_type : int, count: int):
	if !on_storage.has(component_type): on_storage[component_type] = 0
	on_storage[component_type] += count
	storage_changed.emit()
	
func remove_storage(component_type: int, count:int) -> bool:
	if on_storage[component_type] - count < 0: return false
	on_storage[component_type] -= count
	storage_changed.emit()
	return true

func get_new_component_by_id(id: int, is_broken : bool):
	var comp = ComponentResource.new().generate_new_component(id, is_broken)
	return comp
	
############################
#################################
# QUEUE TABLE
var queue_capacity = 4
var on_queue : Array[FixableResource] = []
signal queue_opened()
signal queue_added()
signal queue_removed(fixable : FixableResource)

func add_queue(fixable: FixableResource):
	on_queue.append(fixable)
	playsound(playersfx, "res://Assets/Sound Effect/ItemDrop.wav")
	queue_added.emit()

func remove_queue(fixable: FixableResource):
	if on_queue.has(fixable):
		on_queue.erase(fixable)
		queue_removed.emit()
		return true
	return false

#######################
####################
# ON HAND
var on_hand : FixableResource
signal hand_changed()

func add_hand(fixable: FixableResource):
	if on_hand != null: return
	on_hand = fixable
	playsound(playersfx, "res://Assets/Sound Effect/ItemTake.wav")
	hand_changed.emit()
	
func remove_hand():
	if on_hand == null: return false
	on_hand = null
	hand_changed.emit()
	return true

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
	customer_week_queue_added.emit(cust_resource)

func move_customer_to_register(customer : CustomerResource):
	if on_customer_week_queue.has(customer):
		on_customer_week_queue.erase(customer)
		on_register.append(customer)
		register_added.emit(customer)
		playsound(custsfx, "res://Assets/Sound Effect/Bell.wav")
		
var on_register : Array[CustomerResource] = []
signal register_added(customer : CustomerResource)
signal register_opened()

var on_customer_served : Array[CustomerResource] = []
signal customer_served(customer : CustomerResource)
signal customer_left(customer : CustomerResource)
func move_customer_to_served(customer : CustomerResource):
	if on_register.has(customer):
		on_customer_served.append(customer)
		customer.serve(day, timehr)
		customer_served.emit(customer)
		on_register.erase(customer)
		num_customer_served += 1
		

func move_customer_to_leave(customer : CustomerResource):
	if on_register.has(customer):
		on_register.erase(customer)
		customer_left.emit(customer)
		print("Customer from register left")
		customer_denied += 1
		
		
	if on_customer_served.has(customer):
		on_customer_served.erase(customer)
		customer_left.emit(customer)
		print("Customer from served left")
		customer_denied += 1

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
		-2: # Tutorial, insert doang
			var gender = randi_range(0,1)
			var fixable = create_new_fixable(2)
			new_customer.initialize(gender, fixable, fixable.wait_time)
		-1: #tutorial, baterai remove insert
			var gender = randi_range(0,1)
			var fixable = create_new_fixable(0)
			new_customer.initialize(gender, fixable, fixable.wait_time)
			
		0:  #0 = pengguna hp, phone type 0-2, 
			var gender = randi_range(0,1)
			var fixable = create_new_fixable(randi_range(0,2))
			new_customer.initialize(gender, fixable, fixable.wait_time)
		1: #1 = pengguna laptop dan hp, type 3-5
			var gender = randi_range(0,1)
			var fixable = create_new_fixable(randi_range(0,5))
			new_customer.initialize(gender, fixable, fixable.wait_time)
		2: #1 = pengguna laptop only, type 3-5
			var gender = randi_range(0,1)
			var fixable = create_new_fixable(randi_range(3,5))
			new_customer.initialize(gender, fixable, fixable.wait_time)
			
	return new_customer
	
#########
########
# On Cash Register
func serve_customer(customer : CustomerResource, price : int):
	if on_register.has(customer):
		move_customer_to_served(customer)
		add_hand(customer.fixable)
		customer.fixable.set_price(price)
		customer.serve(day, timehr)
		
#On ready table
signal customer_take_ready(customer : CustomerResource)
func take_ready(customer : CustomerResource):
	var cust_fixable = customer.fixable
	customer_take_ready.emit(customer)
	if on_ready.has(cust_fixable):
		on_fixable_done(cust_fixable)
		remove_fromall_stations(customer.fixable)
		customer_satisfied += 1
		customer_denied -=1
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
	var base_price = fixable.base_price
	var setted_price = fixable.price
	var profit_percentage = (1.0 * setted_price - base_price)/base_price
	
	if profit_percentage <=0.3:
		rating += 0.1
	elif profit_percentage <=0.6:
		rating += 0.05
	elif profit_percentage >=1.0:
		rating -= 0.4
	
	if broken_value ==0:
		rating += 0.025
	if broken_value <=1:
		add_money(setted_price)
	if broken_value == 3:
		rating -=0.2
	after_rating = rating
	


func remove_fromall_stations(fixable : FixableResource):
	remove_ready(fixable)
	remove_operation(fixable)
	remove_queue(fixable)
	if on_hand == fixable: remove_hand()
	









####################
# Generate new Week
var customer_median = 7
var customer_randomness = 1
var day_dictionary = {
	1:0, 2:0, 3:0, 4:0, 5:0
}
func generate_week():
	customer_median = 3 + int(rating * 2.5)
	var cust_random = randi_range(-customer_randomness, customer_randomness)
	var customer_count = int(customer_median + cust_random)
	
	# WEEKLY STATS
	previous_money = money
	after_money = money
	profit = 0
	modal = money_spent
	money_spent = 0
	previous_rating = rating
	after_rating = rating
	customer_satisfied = 0
	customer_denied = 0
	num_customer_served = 0
	var cust_diff = 0
	if week == 2: cust_diff = 0
	elif week == 3: cust_diff = 1
	else: cust_diff= 2
	print("WEEK "+str(week))
	if on_customer_served.size() == 0:
		customer_count -= 1
		var cust = create_new_customer(cust_diff)
		add_customer_week_queue(cust, 1, 8)
		
	for i in range(0, customer_count):
		var day = randi_range(1,4)
		var time = randi_range(7,15)
		var cust = create_new_customer(cust_diff)
		add_customer_week_queue(cust, day, time)

####################
# ON START OF WEEk ONLY ON SUNRAY
signal week_started()
func start_week():
	add_day(1)
	if(week != 1):
		generate_week()
	MusicHandler.play_song("res://Assets/Songs/Kalem Bang.ogg")
	change_game_state(STATE.RUNNING)
	week_started.emit()
	print(game_state)


#################3
# ON END OF WEEK
signal week_ended()
func end_week():
	MusicHandler.play_song("res://Assets/Songs/Capek bang.ogg")
	after_money = money
	change_game_state(STATE.PAUSED)
	open_menu_path("res://Scenes/User Interface/phone.tscn")
	if week==4 or rating >5:
		open_menu_path("res://Scenes/User Interface/TemporaryDemo.tscn")
	
	
	open_menu_path("res://Scenes/User Interface/WeeklyReview.tscn")
	week_ended.emit()
	

func initialgame():
	MusicHandler.play_song("res://Assets/Songs/Capek bang.ogg")
	change_game_state(STATE.PAUSED)
	open_menu_path("res://Scenes/User Interface/phone.tscn")
	start_tutorial()
	rating = 1.0
	previous_money = 0
	after_money = 0
	money_spent = 0
	modal = 0
	profit = 0
	previous_rating = 0
	after_rating = 0
	customer_satisfied = 0
	customer_denied = 0
	num_customer_served = 0
	
	on_customer_week_queue= []
	on_customer_served = []
	on_queue = []
	on_operation = null
	on_ready = []
	on_storage = {
	0: 0,
	1: 3,
	2: 3}
	on_hand = null
	
	
func savegame():
	var saveDict = {
		}


func _ready():
	# DEBUG
	#var test_fixable = create_new_fixable(FixableResource.TYPE.Phone)
	#add_queue(test_fixable)
	#var test_fixable2 = create_new_fixable(FixableResource.TYPE.Phone)
	#add_queue(test_fixable2)
	timer.one_shot = false
	timer.wait_time=1.667
	timer.timeout.connect(_on_clock_timeout)
	week_changed.connect(end_week)
	
	hour_changed.connect(hourly_customer_checker)
	add_storage(ComponentResource.TYPE.LCD, 3)
	add_storage(ComponentResource.TYPE.BATERAI, 3)
	
	


signal speed_changed()
var speed := 1
func set_speed(spd : int):
	print("Changed speed to "+str(spd))
	speed = spd
	speed_changed.emit()
	timer.wait_time = (1.0 + 2.0/3) / spd

func close_all_menu():
	for item in on_screen.get_children():
		item.queue_free()

func open_menu_path(path: String)->Node:
	var scene : Node = ResourceLoader.load(path).instantiate()
	on_screen.add_child(scene)
	playsound(playersfx, "res://Assets/Sound Effect/OpenMenu.wav")
	return scene
	pass
func open_menu_instance(node: Node)->Node:
	on_screen.add_child(node)
	playsound(playersfx, "res://Assets/Sound Effect/OpenMenu.wav")
	return node
	pass

func open_menu(resource : PackedScene)->Node:
	if(resource == null): return
	var scene = resource.instantiate()
	on_screen.add_child(scene)
	playsound(playersfx, "res://Assets/Sound Effect/OpenMenu.wav")
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
	if(day > 5):
		date += 1
		day -=6
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

func start_tutorial():
	await add_tutorial_text("Halo dan selamat datang di permainan [b][color=#ff6722]Servis Bang![/color][/b]")
	await add_tutorial_text("Tujuan anda pada permainan ini adalah untuk mendapatkan uang\nSebanyak-banyaknya!")
	await add_tutorial_text("Pertama, silahkan beli barang yang tersedia di [color=#ff6722]FarrozMart![/color]\n\nTip: Ingat-ingat harga barang yang anda beli!")
	await money_changed
	await add_tutorial_text("Setelah kamu selesai, klik [b]Lanjut[/b] untuk memulaikan permainan!")
	await week_started
	await add_tutorial_text("Saat memulai permainan, perhatikan bar yang ada di atas!")
	await add_tutorial_text("Terdapat informasi [b]waktu, hari, dan jumlah uang[/b] yang anda miliki")
	await add_tutorial_text("Pada hari-hari kerja, akan ada pelanggan yang datang untuk meminta servis")
	var cust = create_new_customer(-2, 1, 8)
	add_customer_week_queue(cust, 1, 8)
	await register_added
	await add_tutorial_text("Lihat! ada pelanggan baru!")
	change_game_state(STATE.PAUSED)
	await add_tutorial_text("Pergi ke [color=#3991e6]Meja konter[/color] dengan [b]klik kiri[/b]. \nSaat sudah di konter, klik [b]kanan[/b] untuk membuka menu!")
	await register_opened
	add_time_min(20)
	await add_tutorial_text("Di menu ini anda lihat kendala yang di alami pelanggan\nHarga dapat di set sesuai dengan komponen yang besar kemungkinan di gunakan\n\n[b]Hint: Pelanggan tidak memiliki layar, maka anda harus memasang lcd!\nKarena harga lcd adalah Rp100000, Set harga sekitar Rp150000 untuk mendapatkan profit![/b]")
	await hand_changed
	add_time_min(20)
	await add_tutorial_text("Klik [color=#f8f03e]Meja inspeksi[/color] yang ada pada bagian kiri.\nSaat sudah disana, klik [b]kanan[/b] untuk menaruh smartphone lalu klik kanan lagi untuk membuka menu")
	await queue_added
	await queue_opened
	add_time_min(20)
	await add_tutorial_text("Kamu dapat melihat komponen yang ada di dalam smartphone\nDisini, [b]terdapat slot kosong untuk memasang LCD[/b]")
	await add_tutorial_text("Ambil perangkat dan bawa ke [color=#ff6722]meja operasional[/color] yang ada pada tengah ruangan")
	await operation_opened
	add_time_min(20)
	await add_tutorial_text("Slot kosong pada perangkat akan kami pasang LCD, klik + untuk memasang LCD\nAkan ada puzzle saat memasang LCD! Perhatikan baik-baik cara kerja puzzle!")
	await component_added
	add_time_min(20)
	await add_tutorial_text("Jika anda sudah selesai, bawa perangkat ke [color=#5fca23]meja siap[/color] yang ada pada kanan bawah")
	await ready_added
	var cust2 = create_new_customer(-2, 1, 8)
	add_customer_week_queue(cust2, 1, 8)
	move_customer_to_register(cust2)
	await add_tutorial_text("Setelah beberapa lama, perangkat akan di ambil oleh pelanggan,\ndan akan dibayar sesuai harga yang telah di set")
	await add_tutorial_text("Sementara itu, Silahkan coba untuk melayani pelanggan yang baru saja datang!")
	change_game_state(STATE.RUNNING)
	await customer_take_ready
	change_game_state(STATE.PAUSED)
	await add_tutorial_text("Luar Biasa!\nKamu telah mendapatkan profit!")
	await add_tutorial_text("Untuk kedepannya, akan ada banyak pelanggan dengan kendala perangkat yang berbeda beda.")
	await add_tutorial_text("Jangan lupa untuk perkirakan harga sesuai dengan modal yang dikeluarkan\nuntuk membeli komponen yang mungkin untuk digunakan")
	await add_tutorial_text("Puzzle yang dilakukan juga memiliki kesulitan yang berbeda beda!")
	var cust3 = create_new_customer(-1, 2, 9)
	add_customer_week_queue(cust3, 2, 9)
	move_customer_to_register(cust3)
	await add_tutorial_text("Ada pelanggan lagi! Coba untuk melayaninya!")
	await register_opened
	add_time_min(10)
	await add_tutorial_text("Kali ini, baterai yang mengalami masalah!\nCoba bawa lagi ke meja inspeksi untuk melihat komponen\n\nTip: Harga baterai adalah Rp60000")
	await queue_added
	add_time_min(10)
	await queue_opened
	add_time_min(10)
	await add_tutorial_text("Jika kamu lihat, Teks baterai berwarna kuning.\nHal ini berarti baterai perlu di lepas dan di pasang baterai yang baru!")
	await add_tutorial_text("Bawa perangkat ke meja operasi!")
	await operation_added
	add_time_min(10)
	await operation_opened
	add_time_min(10)
	await add_tutorial_text("Kita butuh menggantikan baterai. Lepas baterai dengan klik tombol - pada baterai")
	await add_tutorial_text("Puzzle saat melepas komponen akan lebih sulit.\nNamun kami yakin anda dapat mengerti!")
	await component_added
	add_time_min(10)
	await add_tutorial_text("Mantap!")
	await add_tutorial_text("Perlu diperingati bahwa akan ada perangkat-perangkat yang komponennya jauh lebih kompleks!\nNamun mereka akan memiliki profit yang jauh lebih tinggi!")
	await add_tutorial_text("Jika kamu tidak sanggup, kamu dapat menolaknya saat di konter")
	await add_tutorial_text("Skor anda akan di evaluasi pada akhir minggu! Harap lakukan yang terbaik dalam membangun tempat servis ini!")
	await ready_added
	var cust4 = create_new_customer(0, 3, 8)
	add_customer_week_queue(cust4, 3, 8)
	move_customer_to_register(cust4)
	var cust5 = create_new_customer(0, 3, 9)
	add_customer_week_queue(cust5, 3, 9)
	var cust6 = create_new_customer(0, 4, 12)
	add_customer_week_queue(cust6, 4, 12)
	change_game_state(STATE.RUNNING)
	
	
	
	
	
	
	
	
	
	
	
	
	
	

func add_tutorial_text(text : String):
	var node : TutorialText = ResourceLoader.load("res://Scenes/User Interface/Tutorial/tutorial_text.tscn").instantiate()
	var prevGameState = game_state
	node.initialize(text)
	add_child(node)
	change_game_state(STATE.PAUSED)
	await node.finished
	change_game_state(prevGameState)
	
	
