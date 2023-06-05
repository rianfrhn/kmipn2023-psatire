extends Node
@onready var music_player = $AudioStreamPlayer
@onready var music_player2 = $AudioStreamPlayer2
@onready var anim = $AnimationPlayer
var playing := 1
func play_song(dir : String):
	var audio : AudioStream = load(dir) if dir!="" else null
	if playing == 1:
		music_player2.stream = audio
		music_player2.play()
		anim.play("onetwo")
		await anim.animation_finished
		music_player.playing = false
		playing = 2
	elif playing == 2:
		music_player.stream = audio
		music_player.play()
		anim.play_backwards("onetwo")
		await anim.animation_finished
		music_player2.playing = false
		playing = 1
		
