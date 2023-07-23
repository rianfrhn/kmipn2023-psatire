extends Node3D

@onready var light = $DirectionalLight3D
@onready var pause_button = $pause_button
@onready var pause_panel: ColorRect = preload("res://Scenes/User Interface/pause_panel.tscn").instantiate()
@onready var continue_btn: Button = pause_panel.get_node("VBoxContainer/btn_continue")

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.initialgame()
	pause_button.pressed.connect(pause_game)
	continue_btn.pressed.connect(continue_game)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Game.timehr == 7 && Game.timemin == 0) : 
		light.rotation_degrees.x = 20
	light.rotation_degrees.x -= ((Game.timehr-7 + Game.timemin/60.0)/(16.0-7)*4)*delta
	
func pause_game():
	Game.change_game_state(Game.STATE.PAUSED)
	add_child(pause_panel)

func continue_game():
	remove_child(pause_panel)
	if Game.day != 0:
		Game.change_game_state(Game.STATE.RUNNING)
