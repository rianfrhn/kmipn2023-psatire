extends Control
var complexity : int
var number_size = 4
var number_range = 1
var target_number := []
var numbers := []
@onready var button_container = $NinePatchRect/VBoxContainer/HBoxContainer2
@onready var label_container = $NinePatchRect/VBoxContainer/HBoxContainer
@onready var label = $NinePatchRect/VBoxContainer/RichTextLabel
@onready var textur = $NinePatchRect/VBoxContainer/HBoxContainer/TextureRect

var textures = [preload("res://Assets/PuzzleCode/Code0.png"),
preload("res://Assets/PuzzleCode/Code1.png"),
preload("res://Assets/PuzzleCode/Code2.png"),
preload("res://Assets/PuzzleCode/Code3.png"),
null,
]
signal minigame_done()
# Called when the node enters the scene tree for the first time.

func initialize(complexity : int = 0):
	self.complexity = complexity
	match complexity:
		0:
			number_size = 3
			number_range = 1
		1:
			number_size = 3
			number_range = 2
		2:
			number_size = 4
			number_range = 2
		3:
			number_size = 4
			number_range = 3
	
	
	await ready
	for items in button_container.get_children():
		items.queue_free()
	
	
	
	target_number = []
	numbers = []
	for i in range(0, number_size):
		var target_n = randi_range(0,number_range)
		var n = randi_range(0,number_range)
		target_number.append(target_n)
		var btn = create_button(i, n)
		numbers.append(btn)
		button_container.add_child(btn)
	
	textur.texture = textures[target_number[0]]
	for i in range(1, number_size):
		var txt = textur.duplicate()
		label_container.add_child(txt)
		txt.texture = textures[target_number[i]]
		
	updateview()
	
func create_button(pos : int, num:int): # 0 connector, 1 start, 2 end
	var button : RemoveComponentButton= ResourceLoader.load("res://Scenes/User Interface/RemoveComponentGameplay/remove_component_button.tscn").instantiate()
	button.initialize(pos, num)
	button.clicked.connect(button_clicked)
	button.number = num
	
		
	return button
func button_clicked(pos:int):
	var prev = null
	var current = null
	var after = null
	if pos-1 >=0:
		prev = numbers[pos-1]
		var new_num = prev.number +1 if prev.number+1<=number_range else 0
		prev.number = new_num
	if pos+1 <number_size:
		after = numbers[pos+1]
		var new_num = after.number +1 if after.number+1<=number_range else 0
		after.number = new_num
	
	current = numbers[pos]
	var new_num = current.number +1 if current.number+1<=number_range else 0
	current.number = new_num
	updateview()


func updateview():
	var match_points = 0
	for i in range(0, number_size):
		if numbers[i].number == target_number[i]:
			numbers[i].matched = true
			match_points+=1
		else:
			numbers[i].matched = false
			
	
	if match_points == number_size:
		print("PLAYER HAS DONE MINIGAME")
		label.text = "SELESAI!"
		await get_tree().create_timer(3).timeout
		minigame_done.emit()
		queue_free()
		
