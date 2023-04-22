@tool
extends EditorPlugin


# A class member to hold the dock during the plugin life cycle
var dock

func _enter_tree():
	# Initialization of the plugin goes here
	# Load the dock scene and instance it
	dock = preload("res://addons/prettyprimitive/panel.tscn").instantiate()


	# Add the loaded scene to the docks
	# Note that LEFT_UL means the left of the editor, upper-left dock
	add_control_to_dock(DOCK_SLOT_RIGHT_BL, dock)


func _exit_tree():
	# Clean-up of the plugin goes here
	# Remove the dock
	#remove_custom_type("MyButton")
	remove_control_from_docks(dock)

	# Erase the control from the memory
	dock.free()

