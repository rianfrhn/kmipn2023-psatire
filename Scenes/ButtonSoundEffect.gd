extends AudioStreamPlayer
@onready var btn = $".."
@onready var btnclicksfx = load("res://Assets/Sound Effect/ButtonClick.wav")
@onready var btnhover = load("res://Assets/Sound Effect/ButtonHover.wav")
@export var press_sound_effect : bool = true
@export var hover_sound_effect : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if press_sound_effect: btn.pressed.connect(onpress)
	if hover_sound_effect: btn.mouse_entered.connect(onhover)

func onpress():
	stream = btnclicksfx
	play()
func onhover():
	stream = btnhover
	play()
