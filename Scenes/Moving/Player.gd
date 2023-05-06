extends CharacterBody3D
class_name Player
@onready var nav_agent : NavigationAgent3D= $NavigationAgent3D
@onready var hand = $Hand
var speed = 2.0
var menu_opened = false
var opened_menu
func _ready():
	Game.hand_changed.connect(update_hand)

func _physics_process(delta):
	var current_location = global_position
	var next_location = nav_agent.get_next_path_position()
	var direction = (next_location - current_location).normalized()
	var vel = direction * speed
	velocity = vel
	move_and_slide()
	
func _unhandled_input(event):
	if Input.is_action_pressed("game_pause"):
		if !menu_opened:
			opened_menu = Game.open_menu_path("res://Scenes/User Interface/phone.tscn")
			menu_opened = true
		else:
			opened_menu.queue_free()
			menu_opened = false
	
func update_target_location(target_location : Vector3):
	nav_agent.set_target_position(target_location)
	
	
func await_prompt():
	print("Waiting for Right Click")
	
func leave_prompt():
	print("No longer waiting for right click")
func update_hand():
	var onhand = Game.on_hand
	remove_hand()
	if onhand != null:
		var hand_object = onhand.scene.instantiate()
		hand_object.position = Vector3(0,0,0)
		hand.add_child(hand_object)
		
func remove_hand():
	for node in hand.get_children():
		node.queue_free()
