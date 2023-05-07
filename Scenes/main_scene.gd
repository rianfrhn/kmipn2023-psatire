extends Node3D

@onready var light = $DirectionalLight3D

# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	light.rotation_degrees.x =90 -((Game.timehr-7 + Game.timemin/60.0)/(16.0-7)*360)
