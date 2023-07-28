extends VideoStreamPlayer

@onready var skip_btn = $skip_btn
# Called when the node enters the scene tree for the first time.
func _ready():
	finished.connect(func() : SceneTransition.change_scene_path("res://Scenes/main_scene.tscn"))
	skip_btn.pressed.connect(func() : SceneTransition.change_scene_path("res://Scenes/main_scene.tscn"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
