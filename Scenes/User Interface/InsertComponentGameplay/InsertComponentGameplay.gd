extends Control
var complexity : int
var rows = 10
var col = 10
var numrange = 2
var grid : Array = [[]] # [row][column]
var start:Vector2
var end:Vector2
@onready var grid_container : GridContainer= $NinePatchRect/VBoxContainer/GridContainer
@onready var label = $NinePatchRect/VBoxContainer/RichTextLabel
signal minigame_done()
# Called when the node enters the scene tree for the first time.
func initialize(complexity : int = 0):
	self.complexity = complexity
	
	match complexity:
		0:
			col = 7
			rows = 7
			numrange = 1
		1:
			col = 7
			rows = 7
			numrange = 3
		2:
			col = 11
			rows = 11
			numrange = 2
		3:
			col = 11
			rows = 11
			numrange = 3
	
	await ready
	for items in grid_container.get_children():
		items.queue_free()
		
	grid_container.columns = col
	creategrid()
	
func create_button(pos : Vector2, num:int, type : int = 0): # 0 connector, 1 start, 2 end
	var button : InsertComponentButton= ResourceLoader.load("res://Scenes/User Interface/InsertComponentGameplay/insert_component_button.tscn").instantiate()
	button.pressed.connect(updategrid)
	button.initialize(pos, numrange)
	button.clicked.connect(updategrid)
	button.number = num
	button.disabled = false
	if type == 1:
		button.source = true
		button.disabled = true
	elif type == 2:
		button.exit = true
		button.disabled = true
		
	return button

func creategrid():
	grid = [[]]
	var start = randi_range(0, rows-1)
	var end = randi_range(0, rows-1)
	self.start = Vector2(0,start)
	self.end = Vector2(col-1, end)
	var target_num = randi_range(0,numrange)
	for i in range(rows):
		grid.append([])
		for j in range(col):
			grid[i].append(null)
			var type = 0
			var num = randi_range(0,numrange)
			if i==start && j == 0:
				type = 1
				num = target_num
			elif i==end && j==col-1:
				type=2
				num = target_num
				
			
			var b = create_button(Vector2(i,j),num, type)
			grid[i][j] = b
			grid_container.add_child(b)
			
	updategrid()

func updategrid():
	for i in range(0, rows):
		for j in range(0, col):
			grid[i][j].connected = false
			grid[i][j].checked = false
	check_connected(start)
	if grid[end.y][end.x].connected:
		for i in range(0, rows):
			for j in range(0, col):
				grid[i][j].disabled = true
		print("PLAYER HAS DONE MINIGAME")
		label.text = "SELESAI!"
		await get_tree().create_timer(3.0 / Game.speed).timeout
		minigame_done.emit()
		queue_free()
		

func check_connected(pos:Vector2):
	var button = grid[pos.y][pos.x]
	button.checked = true
	button.connected = true
	print(pos)
	#check up
	if pos.y-1 >= 0:
		var new_button = grid[pos.y-1][pos.x]
		if new_button.checked == false && new_button.number == button.number:
			check_connected(Vector2(pos.x, pos.y-1))
	#check down
	if pos.y+1 < rows:
		var new_button = grid[pos.y+1][pos.x]
		if new_button.checked == false && new_button.number == button.number:
			check_connected(Vector2(pos.x, pos.y+1))
	#check right
	if pos.x-1 >=0:
		var new_button = grid[pos.y][pos.x-1]
		if new_button.checked == false && new_button.number == button.number:
			check_connected(Vector2(pos.x-1, pos.y))
	#check left
	if pos.x+1 < col:
		var new_button = grid[pos.y][pos.x+1]
		if new_button.checked == false && new_button.number == button.number:
			check_connected(Vector2(pos.x+1, pos.y))
		
