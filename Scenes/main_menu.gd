extends Node3D
@onready var ply_anim = $Player/Albob/AnimationPlayer
@onready var playbtn = $Control/Button

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
	MusicHandler.play_song("")
	SceneTransition.change_scene_path("res://Scenes/main_scene.tscn")
