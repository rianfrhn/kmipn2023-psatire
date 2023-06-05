extends Resource
class_name FixableResource

@export var id : float
@export var name : String
@export var required_components = [] # PAKE ENUM DI RESOURCECOMPONENT, 0 FOR EMPTY, 
@export var slotted_components = []
@export var defects = []
@export var due_date : int
@export var scene : PackedScene
@export var kendala = "Device saya bermasalah"
enum TYPE{Phone1, Phone2, Phone3, Laptop1, Laptop2, Laptop3}
var base_price : int = 0
var price : int = 0
var broken_value = 0
var wait_time = 1

func generate_new(type : TYPE):
	id = randf_range(0,1)
	match(type):
		TYPE.Phone1:
			name = "Oppo A3S"
			kendala = "Baterai Yang Terpasang Cepat Habis"
			scene = ResourceLoader.load("res://Scenes/Moving/Phone.tscn")
			wait_time = 2
			required_components = [
				ComponentResource.TYPE.LCD,
				ComponentResource.TYPE.BATERAI
			]
			slotted_components = [
				ComponentResource.TYPE.LCD,
				ComponentResource.TYPE.BATERAI
			]
			defects = [0,1]
		TYPE.Phone2:
			name = "Samsung Galaxy A20"
			kendala = "Layar Smartphone saya Mati Nyala"
			scene = ResourceLoader.load("res://Scenes/Moving/Phone.tscn")
			wait_time = 3
			required_components = [
				ComponentResource.TYPE.LCD,
				ComponentResource.TYPE.BATERAI
			]
			slotted_components = [
				ComponentResource.TYPE.LCD,
				ComponentResource.TYPE.BATERAI
			]
			defects = [1,1]
		TYPE.Phone3:
			name = "Nokia 3.1"
			kendala = "Layar saya copot dan Hilang"
			scene = ResourceLoader.load("res://Scenes/Moving/Phone.tscn")
			wait_time = 1
			required_components = [
				ComponentResource.TYPE.LCD,
				ComponentResource.TYPE.BATERAI
			]
			slotted_components = [
				ComponentResource.TYPE.KOSONG,
				ComponentResource.TYPE.BATERAI
			]
			defects = [0,0]
		TYPE.Laptop1:
			name = "Toshiba Satellite C850-X5212"
			kendala = "Keyboard tidak jelas saat di tekan"
			scene = ResourceLoader.load("res://Scenes/Moving/Laptop.tscn")
			wait_time = 3
			required_components = [
				ComponentResource.TYPE.BATERAI,
				ComponentResource.TYPE.KEYBOARD,
				ComponentResource.TYPE.MOTHERBOARD
			]
			slotted_components = [
				ComponentResource.TYPE.BATERAI,
				ComponentResource.TYPE.KEYBOARD,
				ComponentResource.TYPE.MOTHERBOARD
			]
			defects = [1,1,0]
		TYPE.Laptop2:
			name = "Acer Swift 3 Air"
			kendala = "Perangkat internal laptop saya rusak"
			scene = ResourceLoader.load("res://Scenes/Moving/Laptop.tscn")
			wait_time = 7
			required_components = [
				ComponentResource.TYPE.BATERAI,
				ComponentResource.TYPE.KEYBOARD,
				ComponentResource.TYPE.MOTHERBOARD
			]
			slotted_components = [
				ComponentResource.TYPE.BATERAI,
				ComponentResource.TYPE.KEYBOARD,
				ComponentResource.TYPE.MOTHERBOARD
			]
			defects = [1,0,1]
		TYPE.Laptop3:
			name = "ACER Aspire Vero"
			kendala = "Perangkat saya kemasukan air, tidak dapat dinyalakan lagi"
			scene = ResourceLoader.load("res://Scenes/Moving/Laptop.tscn")
			required_components = [
				ComponentResource.TYPE.BATERAI,
				ComponentResource.TYPE.KEYBOARD,
				ComponentResource.TYPE.MOTHERBOARD
			]
			slotted_components = [
				ComponentResource.TYPE.BATERAI,
				ComponentResource.TYPE.KEYBOARD,
				ComponentResource.TYPE.MOTHERBOARD
			]
			defects = [1,1,1]
			
	
	setBasePrice()

func setBasePrice():
	base_price = 0
	
	var i=0
	for item in required_components:
		if slotted_components[i] != item:
			base_price += ComponentResource.getPrice(item)
		elif defects[i] == 1:
			base_price += ComponentResource.getPrice(item)
		i+=1


func get_kendala()->String:
	return kendala

func set_price(ammount : int):
	price = ammount

func count_broken_value():
	broken_value = 0
	for n in range(0, required_components.size()):
		if required_components[n] != slotted_components[n]:
			broken_value+=1
		for i in defects:
			broken_value += i
	return broken_value
