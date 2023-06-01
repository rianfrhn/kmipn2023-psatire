extends NinePatchRect
class_name Phone
@onready var day_label = $VBoxContainer/Top/Date
@onready var time_label = $VBoxContainer/Top/Time
@onready var continue_button = $VBoxContainer/Bottom/PhoneContinueButton
@onready var back_button = $VBoxContainer/Bottom/PhoneBackButton

#BINDS
# FARROZMART
@onready var apps = $VBoxContainer/Middle/Apps/Apps
@onready var fzmbtn = $VBoxContainer/Middle/Apps/Apps/FarrozMart/TextureRect/FarrozMart
@onready var fzm = $VBoxContainer/Middle/FarrozMart
#ikeya
@onready var ikeya = $VBoxContainer/Middle/IKEyA
@onready var ikeyabtn = $VBoxContainer/Middle/Apps/Apps/IKEyA/TextureRect/IKEyA
#lnk
@onready var lnk = $VBoxContainer/Middle/LinkedOut
@onready var lnkbtn = $VBoxContainer/Middle/Apps/Apps/LinkedOut/TextureRect/LinkedOut

# Called when the node enters the scene tree for the first time.
var phone_stack := [] #Node -> node
var bindings #button : node -> node

func navigate(source : Control, destination : Control):
	var new_directory = [source, destination]
	phone_stack.append(new_directory)
	source.visible = false
	destination.visible = true
func back():
	var index = phone_stack.size()-1
	if index <0: return
	var furthest = phone_stack[index]
	furthest[0].visible = true
	furthest[1].visible = false
	phone_stack.erase(furthest)
	
	
func _ready():
	continue_button.pressed.connect(_on_continue)
	back_button.pressed.connect(back)
	bindings = {
		fzmbtn:[apps, fzm],
		ikeyabtn:[apps, ikeya],
		lnkbtn:[apps, lnk]
		
	}
	# CHECK FARROZMART BINDINGS
	var fzmbinds = fzm.get_binds()
	if fzmbinds != null:
		for bind in fzmbinds:
			for keys in bind.keys():
				bindings[keys] = [bind[keys][0], bind[keys][1]]
	print(bindings)
	
	for buttons in bindings.keys():
		var source = bindings[buttons][0]
		var destination = bindings[buttons][1]
		var c = Callable(self, "navigate").bind(source, destination)
		buttons.pressed.connect(c)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	day_label.text = Game.get_full_date_string()
	time_label.text = Game.get_time_string()

func _on_continue():
	queue_free()
	Game.start_week()
