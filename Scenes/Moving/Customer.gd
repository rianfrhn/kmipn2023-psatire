extends CharacterBody3D
class_name Customer
@onready var anim_player = $NPCModel/AnimationPlayer
@onready var model = $NPCModel
enum MOVE_STATE {MOVING, IDLE}
#enum HAND_STATE {HOLDING, IDLE}

@onready var nav_agent : NavigationAgent3D= $NavigationAgent3D
#@onready var model = $Albob
#@onready var anim_player : AnimationPlayer = model.get_node("AnimationPlayer")
#@onready var hand = $Albob/Hand

var move_state = MOVE_STATE.IDLE
#var hand_state = HAND_STATE.IDLE
var speed = 2.0
var accel_angle = 10
var target_rotation : Vector3 = Vector3.ZERO

	

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
		change_move_state(MOVE_STATE.IDLE)
	
	update_rotation(delta)
	

func change_move_state(state):
	match state:
		MOVE_STATE.IDLE:
			if move_state == MOVE_STATE.IDLE: return
			move_state = MOVE_STATE.IDLE
			anim_player.play("Idle") 
		MOVE_STATE.MOVING:
			if move_state == MOVE_STATE.MOVING: return
			move_state = MOVE_STATE.MOVING
			if anim_player.get_animation("Walk") != null :
				anim_player.play("Walk") 
			else :
				anim_player.play("Walk001") 
			

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
	
