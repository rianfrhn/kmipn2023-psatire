extends Button
class_name RemoveComponentButton
@onready var image : TextureRect= $TextureRect
var pos : int

var number : int = 0
var matched := false

var textures = [preload("res://Assets/PuzzleCode/Code0.png"),
preload("res://Assets/PuzzleCode/Code1.png"),
preload("res://Assets/PuzzleCode/Code2.png"),
preload("res://Assets/PuzzleCode/Code3.png"),
null,
]

func _ready():
	pressed.connect(on_clicked)
	mouse_entered.connect(on_mouse_enter)
	mouse_exited.connect(on_mouse_exit)
	
func initialize(pos, num):
	number = num
	self.pos = pos
# Called when the node enters the scene tree for the first time.
func _process(_delta):
	var color =Color8(255,255,255)
	color = Color8(88,180,88) if matched else color
	image.modulate = color
	image.texture = textures[number]
signal clicked(pos : int)
func on_clicked():
	clicked.emit(pos)
	
func on_mouse_enter():
	image.self_modulate = Color8(200,200,200)
func on_mouse_exit():
	image.self_modulate = Color8(255,255,255)
