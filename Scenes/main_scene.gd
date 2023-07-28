extends Node3D

@onready var light = $DirectionalLight3D
@onready var btn_pause = $pause_btn
@onready var pause_menu = preload("res://Scenes/User Interface/PauseMenu.tscn").instantiate()
@onready var continue_btn: Button = pause_menu.get_node("btn_continue")
@onready var exit_btn: Button = pause_menu.get_node("btn_exit")

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.initialgame()
	btn_pause.pressed.connect(show_pause_menu)
	continue_btn.pressed.connect(hide_pause_menu)
	exit_btn.pressed.connect(func(): SceneTransition.change_scene_path("res://Scenes/main_menu.tscn"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Game.timehr == 7 && Game.timemin == 0) : 
		light.rotation_degrees.x = 20
	elif Game.game_state == Game.STATE.PAUSED:
		light.rotation_degrees.x = 20 - ((Game.timehr-7 + Game.timemin/60.0)/(16.0-7)*4)
	else:
		light.rotation_degrees.x -= ((Game.timehr-7 + Game.timemin/60.0)/(16.0-7)*4)*delta

func show_pause_menu() :
	add_child(pause_menu)
	pause_menu.show()

func hide_pause_menu():
	pause_menu.hide()
	remove_child(pause_menu)
