extends CanvasLayer
class_name TutorialText

signal finished()
@onready var label = $Button/ColorRect/VBoxContainer/RichTextLabel
@onready var btn = $Button
var txt = ""
func initialize(text: String):
	txt = "[center]"+text+"[/center]"

func _ready():
	label.text = txt
	btn.pressed.connect(onclick)

func onclick():
	finished.emit()
	queue_free()
