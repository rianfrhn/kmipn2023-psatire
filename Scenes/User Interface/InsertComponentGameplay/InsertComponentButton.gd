extends Button
class_name InsertComponentButton
@onready var image = $TextureRect
var grid_pos : Vector2

var number : int = 0
var max_number = 1
var connected := false
var source := false
var exit := false
var checked := false

var textures = [preload("res://Assets/PuzzleCode/Code0.png"),
preload("res://Assets/PuzzleCode/Code1.png"),
preload("res://Assets/PuzzleCode/Code2.png"),
preload("res://Assets/PuzzleCode/Code3.png"),
null,
]
func _ready():
	pressed.connect(on_clicked)
# Called when the node enters the scene tree for the first time.
func initialize(pos : Vector2, max_number = 1):
	grid_pos = pos
	self.max_number = max_number

func _process(_delta):
	var color = Color8(255,255,255)
	color = Color8(200,0,0) if exit else color
	color = Color8(0,200,0) if connected else color
	color = Color8(90,255,90) if source else color
	color = Color8(255,90,90) if exit && connected else color
	image.self_modulate = color
	image.texture = textures[number]

signal clicked()
func on_clicked():
	print("clicked")
	var num = number +1
	if num>max_number: num = 0
	number = num
	clicked.emit()
	
