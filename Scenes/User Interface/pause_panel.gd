extends ColorRect

@onready var btn_exit = $VBoxContainer/btn_exit
@onready var btn_continue = $VBoxContainer/btn_continue

# Called when the node enters the scene tree for the first time.
func _ready():
	btn_exit.pressed.connect(to_main_menu)

func to_main_menu():
	SceneTransition.change_scene_path("res://Scenes/main_menu.tscn")

