extends CanvasLayer

@onready var panel = $Panel
func change_scene_path(path : String):
	panel.position = Vector2(1370,0)
	move_panel(Vector2(-10,0))
	await tween_done
	get_tree().change_scene_to_file(path)
	Game.close_all_menu()
	move_panel(Vector2(-1370,0))
	
func change_scene_packed(packed_scene: PackedScene):
	panel.position = Vector2(1370,0)
	move_panel(Vector2(0,0))
	await tween_done
	get_tree().change_scene_to_packed(packed_scene)
	Game.close_all_menu()
	move_panel(Vector2(-1370,0))
	

signal tween_done()
func move_panel(pos : Vector2):
	var tween = get_tree().create_tween().bind_node(panel).set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "position", pos, 2)
	tween.tween_callback(set_tween_done)
	
func set_tween_done():
	tween_done.emit()
