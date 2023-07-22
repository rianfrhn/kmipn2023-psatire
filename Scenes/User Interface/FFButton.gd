extends Control

@onready var btn = $HBoxContainer/Button
@onready var label = $HBoxContainer/RichTextLabel
var speed = 1
var index = 0
var speeds := [1,2,4,20]
func _ready():
	btn.pressed.connect(on_pressed)


func on_pressed():
	if index+1 < speeds.size():
		index+=1
	else:
		index = 0
	
	speed = speeds[index]
	label.text = str(speed)+"x"
	Game.set_speed(speed)
