extends Node3D
@onready var ply_anim = $Player/Albob/AnimationPlayer
@onready var playbtn = $Control/VBoxContainer/Button
@onready var loadbtn = $Control/VBoxContainer/Button2

# Called when the node enters the scene tree for the first time.
func _ready():
	ply_anim.play("Idle")
	playbtn.mouse_entered.connect(on_play_hover)
	playbtn.mouse_exited.connect(set_idle)
	playbtn.pressed.connect(start_newgame)
	MusicHandler.play_song("res://Assets/Songs/Istirahat bang.ogg")
	
func on_play_hover():
	ply_anim.play("Repair")
	print("Mouse Entered")
	print(ply_anim.current_animation)
func set_idle():
	ply_anim.play("Idle")
	print("Now set to idle")
func start_newgame():
	Game.day = 0
	Game.date = 1
	Game.week = 1
	Game.month = 1
	Game.money = 1000000
	MusicHandler.play_song("")
	SceneTransition.change_scene_path("res://Scenes/main_scene.tscn")
	
func load_game():
	MusicHandler.play_song("")
	SceneTransition.change_scene_path("res://Scenes/main_scene.tscn")

func exit_game():
	get_tree().quit()
