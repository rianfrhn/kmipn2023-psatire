extends Control

@onready var start_btn = $StartButton
@export var start_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	start_btn.pressed.connect(_on_start_pressed)
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_start_pressed():
	get_tree().change_scene_to_packed(start_scene)
