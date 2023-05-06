extends Camera3D
var mouse = Vector2()
@onready var player = get_parent().get_node("Player")

func _unhandled_input(event):
	if event is InputEventMouse:
		mouse = event.position
	if event.is_action_pressed("game_navigate"):
		try_cast()
		
		
func try_cast():
	var world = get_world_3d().direct_space_state
	var start = project_ray_origin(mouse)
	var end = project_position(mouse, 400)
	var params = PhysicsRayQueryParameters3D.new()
	params.from = start
	params.to = end
	var result = world.intersect_ray(params)
	print(result)
	if result and result.collider.has_node("Target"):
		var target_pos = result.collider.get_node("Target").global_position
		player.update_target_location(target_pos)
		print("set target pos to "+str(target_pos))
	
		
