extends Control

@onready var items_container = $NinePatchRect/ScrollContainer/VBoxContainer/Items
@onready var device_name = $NinePatchRect/ScrollContainer/VBoxContainer/Items/DeviceName
@onready var device_kendala = $NinePatchRect/ScrollContainer/VBoxContainer/Items/DeviceKendala
@onready var harga_input = $NinePatchRect/ScrollContainer/VBoxContainer/Items/HargaInput
@onready var button_tolak = $NinePatchRect/ScrollContainer/VBoxContainer/Items/HBoxContainer/ButtonTolak
@onready var button_terima = $NinePatchRect/ScrollContainer/VBoxContainer/Items/HBoxContainer/ButtonTerima
@onready var label_setharga = $NinePatchRect/ScrollContainer/VBoxContainer/Items/Label2
var customer : CustomerResource
var fixable : FixableResource

var price = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	harga_input.value_changed.connect(_on_value_changed)
	button_terima.pressed.connect(accept)
	button_tolak.pressed.connect(decline)
	
	update_view()
	Game.register_added.connect(update_view)
	Game.customer_served.connect(update_view_for_serve)
	Game.customer_left.connect(update_view)
	
	

func update_view():
	if Game.on_register.size() >=1:
		customer = Game.on_register[0]
		fixable = customer.fixable
		if fixable != null:
			device_name.text = "Perangkat: "+fixable.name
			device_kendala.text = "Kendala: "+fixable.get_kendala()
			harga_input.visible = true
			button_tolak.visible = true
			button_terima.visible = true
			label_setharga.visible = true
	else:
			device_name.text = "Tidak ada Pelanggan"
			device_kendala.text = ""
			harga_input.visible = false
			button_tolak.visible = false
			button_terima.visible = false
			label_setharga.visible = false
#update view for customer served biar g error
func update_view_for_serve(_c : CustomerResource):
	if Game.on_register.size() >=1:
		customer = Game.on_register[0]
		fixable = customer.fixable
		if fixable != null:
			device_name.text = "Perangkat: "+fixable.name
			device_kendala.text = "Kendala: "+fixable.get_kendala()
			harga_input.visible = true
			button_tolak.visible = true
			button_terima.visible = true
			label_setharga.visible = true
	else:
			device_name.text = "Tidak ada Pelanggan"
			device_kendala.text = ""
			harga_input.visible = false
			button_tolak.visible = false
			button_terima.visible = false
			label_setharga.visible = false




func accept():
	Game.serve_customer(customer, price)
	queue_free()

func decline():
	Game.move_customer_to_leave(customer)
	queue_free()
	
func _on_value_changed(value: float):
	price = int(value)
