extends Node3D
@onready var animplayer = $AnimationPlayer
func _unhandled_input(event):
			
	if Input.is_action_pressed("developer_key_1"):
		animplayer.play("new_animation")
