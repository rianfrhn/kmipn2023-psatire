extends CharacterBody3D
class_name Player

enum MOVE_STATE {MOVING, IDLE, REPAIRING}
enum HAND_STATE {HOLDING, IDLE}

@onready var nav_agent : NavigationAgent3D= $NavigationAgent3D
@onready var model = $Albob
@onready var anim_player : AnimationPlayer = model.get_node("AnimationPlayer")
@onready var hand = $Albob/Hand

var move_state = MOVE_STATE.IDLE
var hand_state = HAND_STATE.IDLE
var speed = 2.0
var menu_opened = false
var opened_menu
var accel_angle = 10
var target_rotation : Vector3 = Vector3.ZERO

func _ready():
	Game.hand_changed.connect(update_hand)
	Game.player_object = self
	

func _physics_process(delta):
	var current_location = global_position
	var next_location = nav_agent.get_next_path_position()
	var dist = nav_agent.distance_to_target()
	var direction = (next_location - current_location).normalized()
	var vel = direction * speed
	velocity = vel
	if(dist > 0.05):
		move_and_slide()
		change_move_state(MOVE_STATE.MOVING)
		set_target_rotation_relative(vel)
	else:
		if move_state != MOVE_STATE.REPAIRING:
			change_move_state(MOVE_STATE.IDLE)
	
	update_rotation(delta)
	
func _unhandled_input(event):
	if Input.is_action_pressed("game_pause"):
		if !menu_opened:
			opened_menu = Game.open_menu_path("res://Scenes/User Interface/phone.tscn")
			menu_opened = true
		else:
			opened_menu.queue_free()
			menu_opened = false

func change_move_state(state):
	match state:
		MOVE_STATE.IDLE:
			if move_state == MOVE_STATE.IDLE: return
			move_state = MOVE_STATE.IDLE
			print("CHANGING STATE TO IDLE")
			
			if hand_state == HAND_STATE.HOLDING:
				anim_player.play("Walk_Holding")
			else:
				anim_player.play("Idle") 
		MOVE_STATE.MOVING:
			if move_state == MOVE_STATE.MOVING: return
			move_state = MOVE_STATE.MOVING
			print("CHANGING STATE TO MOVING")
			
			if hand_state == HAND_STATE.HOLDING:
				anim_player.play("Walk_Holding")
			else:
				anim_player.play("Walk") 
		MOVE_STATE.REPAIRING:
			if move_state == MOVE_STATE.REPAIRING: return
			move_state = MOVE_STATE.REPAIRING
			print("CHANGING STATE TO MOVE REPAIRING")
			anim_player.play("Repair")
			
func change_hand_state(state):
	match state:
		HAND_STATE.HOLDING:
			if hand_state == HAND_STATE.HOLDING: return
			hand_state = HAND_STATE.HOLDING
			print("CHANGING STATE TO HAND HOLDING")
			
			if move_state == MOVE_STATE.MOVING:
				anim_player.play("Walk_Holding")
			else:
				anim_player.play("Walk_Holding") ######## FIXXXXX THISSS
		HAND_STATE.IDLE:
			if hand_state == HAND_STATE.IDLE: return
			hand_state = HAND_STATE.IDLE
			print("CHANGING STATE TO HAND IDLE")
			
			if move_state == MOVE_STATE.MOVING:
				anim_player.play("Walk")
			else:
				anim_player.play("Idle")
	

func update_rotation(delta):
	model.rotation.y = lerp(model.rotation.y, atan2(target_rotation.x, target_rotation.z), delta * accel_angle)

func set_target_rotation_relative(vec3 : Vector3):
	target_rotation = vec3
	
func set_target_rotation_global(vec3 : Vector3):
	var vec = vec3-global_position
	print(vec3)
	print(vec)
	target_rotation = Vector3(vec.x, vec.y, vec.z)
	
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
		change_hand_state(HAND_STATE.HOLDING)
	else:
		change_hand_state(HAND_STATE.IDLE)
		
func remove_hand():
	for node in hand.get_children():
		node.queue_free()
