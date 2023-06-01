extends Button
class_name RemoveComponentButton
@onready var txt = $RichTextLabel
var pos : int

var number : int = 0
var matched := false
func _ready():
	pressed.connect(on_clicked)
	
func initialize(pos, num):
	number = num
	self.pos = pos
# Called when the node enters the scene tree for the first time.
func _process(_delta):
	var color = "[color=#ffffff]"
	color = "[color=#44ff44]" if matched else color
	txt.text = "[center]"+color + str(number)+"[/color][/center]"
signal clicked(pos : int)
func on_clicked():
	clicked.emit(pos)
	
