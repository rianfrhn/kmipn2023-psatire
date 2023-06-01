extends Button
class_name InsertComponentButton
@onready var txt = $RichTextLabel
var grid_pos : Vector2

var number : int = 0
var connected := false
var source := false
var exit := false
var checked := false

func _ready():
	pressed.connect(on_clicked)
# Called when the node enters the scene tree for the first time.
func initialize(pos : Vector2):
	grid_pos = pos

func _process(_delta):
	var color = "[color=#ffffff]"
	color = "[color=#ff0000]" if exit else color
	color = "[color=#007700]" if connected else color
	color = "[color=#77ff77]" if source else color
	color = "[color=#ff9999]" if exit && connected else color
	txt.text = "[center]"+color + str(number)+"[/color][/center]"

signal clicked()
func on_clicked():
	print("clicked")
	var num = number +1
	if num>=3: num-=3
	number = num
	clicked.emit()
	
