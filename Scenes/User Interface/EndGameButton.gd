extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(backtomenu)


func backtomenu():
	SceneTransition.change_scene_path("res://Scenes/main_menu.tscn")
