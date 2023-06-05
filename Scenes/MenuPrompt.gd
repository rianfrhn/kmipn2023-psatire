extends Area3D

@export var menu : PackedScene

var waiting_prompt = false

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _input(event):
	if event.is_action_pressed("game_interact"):
		if !waiting_prompt: return
		Game.open_menu(menu)
		
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if(body is Player):
		waiting_prompt = true
		body.await_prompt()

func _on_body_exited(body):
	if(body is Player):
		body.leave_prompt()
		waiting_prompt = false
