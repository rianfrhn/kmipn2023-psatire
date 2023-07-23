extends CanvasLayer

@onready var panel = $Panel
func change_scene_path(path : String):
	fade_panel_100()
	await tween_done
	get_tree().change_scene_to_file(path)
	Game.close_all_menu()
	fade_panel_0()
	
func change_scene_packed(packed_scene: PackedScene):
	fade_panel_100()
	await tween_done
	get_tree().change_scene_to_packed(packed_scene)
	Game.close_all_menu()
	fade_panel_0()
	

signal tween_done()
func fade_panel_100():
	var tween = get_tree().create_tween().bind_node(panel).set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "modulate", Color(1,1,1,1), 1)
	tween.tween_callback(set_tween_done)
func fade_panel_0():
	var tween = get_tree().create_tween().bind_node(panel).set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "modulate", Color(1,1,1,0), 1)
	tween.tween_callback(set_tween_done)
	

func set_tween_done():
	tween_done.emit()
