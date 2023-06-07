extends Node3D

@onready var light = $DirectionalLight3D

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.initialgame()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	light.rotation_degrees.x =20 -((Game.timehr-7 + Game.timemin/60.0)/(16.0-7)*200)
