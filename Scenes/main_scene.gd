extends Node3D

@onready var light = $DirectionalLight3D

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.initialgame()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Game.timehr == 7 && Game.timemin == 0) : 
		light.rotation_degrees.x = 20
	elif Game.game_state == Game.STATE.PAUSED:
		light.rotation_degrees.x = 20 - ((Game.timehr-7 + Game.timemin/60.0)/(16.0-7)*4)
	else:
		light.rotation_degrees.x -= ((Game.timehr-7 + Game.timemin/60.0)/(16.0-7)*4)*delta
