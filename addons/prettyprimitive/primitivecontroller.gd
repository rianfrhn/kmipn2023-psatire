@tool
extends Control

var edi # an EditorInterface, cache for convenience

func _ready():
	#print ("Primitive panel active!")
	if Engine.is_editor_hint():
		var plugin = EditorPlugin.new()
		edi = plugin.get_editor_interface() # now you always have the interface
		plugin.queue_free()
		#print ("Primitive panel active 2! edi: ", edi)
		
		_on_XYZ_toggled($ScrollContainer/VBoxContainer/Boxes/XYZ.button_pressed)
		_on_XY_toggled($ScrollContainer/VBoxContainer/Plane/XY.button_pressed)

	var mat_picker = EditorResourcePicker.new()
	mat_picker.custom_minimum_size = Vector2(100,0)
	mat_picker.base_type = "Material"
	#mat_picker.owner = get_tree().edited_scene_root # owner
	mat_picker.name = "MaterialPicker"
	mat_picker.edited_resource = load("res://addons/prettyprimitive/Materials/default.tres")
	$ScrollContainer/VBoxContainer/Material.add_child(mat_picker)


#func _enter_tree():
#	$HBoxContainer/MakeCube.connect("pressed", self, "AddCube")

enum Parent {
	None,
	Rigid,
	Static,
	AreaParent,
	SpatialParent
	}

# Return { axis:int, nodes_type:Nodes }
func GetOptions():
	return { "axis":          $ScrollContainer/VBoxContainer/Alignment/AxisOptions.selected,
			"parent_type":    $ScrollContainer/VBoxContainer/Options/ParentOptions.selected,
			"with_mesh" :     $ScrollContainer/VBoxContainer/Options/Mesh.button_pressed,
			"with_collider" : $ScrollContainer/VBoxContainer/Options/Collider.button_pressed,
			"as_csg" :        $ScrollContainer/VBoxContainer/Options/AsCSG.button_pressed,
			"with_mat" :      $ScrollContainer/VBoxContainer/Material/WithMat.button_pressed,
			"with_color" :    $ScrollContainer/VBoxContainer/ColorMat/WithColor.button_pressed
			}


# Return [ top, meshinstance (without mesh), collider (without shape), null (placeholder) ]
# Top is the new top, possible an existing node when "No parent", or else
# will be a new RigidDynamicBody3d, StaticBody3D, Area3D, or Node3D. In that
# case, top will become a child of parent.
func BuildBase(options, parent, theowner, csg):
	#print ("buildbase col: ", options["with_collider"] )
	
	var themesh : MeshInstance3D = null
	var col = null
	
	if not options["as_csg"]:
		if options["with_mesh"]: themesh = MeshInstance3D.new()
		if options["with_collider"]: col = CollisionShape3D.new()
	
	var pnt = parent
	match options["parent_type"]:
		Parent.Rigid:
			pnt = RigidBody3D.new()
		Parent.Static:
			pnt = StaticBody3D.new()
		Parent.AreaParent:
			pnt = Area3D.new()
		Parent.SpatialParent:
			pnt = Node3D.new()
			
	if pnt != parent:
		parent.add_child(pnt)
		pnt.owner = theowner
	if themesh:
		pnt.add_child(themesh)
		themesh.owner = theowner
	if col:
		pnt.add_child(col)
		col.owner = theowner
	if csg:
		pnt.add_child(csg)
		csg.owner = theowner
	return [ pnt, themesh, col, csg ] #final null is placeholder for csg node

# Return { owner, parents:[dest1, dest2, ... ] }
func GetDestParents():
	var scene_root = get_tree().edited_scene_root
	var new_owner = scene_root.get_tree().edited_scene_root
	
	var dest
	var sel = edi.get_selection().get_selected_nodes()
	if sel.size() > 0:
		dest = sel
	else:
		dest = [ scene_root ]
		
	return { "owner": new_owner, "parents": dest }


func AdjustMaterial(obj, options):
	if options["with_color"]: AddColor(obj)
	elif options["with_mat"]: AddMaterial(obj)

#func AdjustMaterialCSG(csg, options):
#	if options["with_color"]:
#		var mat = StandardMaterial3D.new()
#		mat.albedo_color = $ScrollContainer/VBoxContainer/ColorMat/ColorPickerButton.color
#		csg.material = mat
#	elif options["with_mat"]:
#		AddMaterial(csg)

func AddColor(obj):
	var mat = StandardMaterial3D.new()
	mat.albedo_color = $ScrollContainer/VBoxContainer/ColorMat/ColorPickerButton.color
	if obj is MeshInstance3D:
		#meshi.set_surface_override_material(0, mat)
		obj.mesh.surface_set_material(0, mat)
	else:
		obj.material = mat #assume csg

func AddMaterial(obj):
	var mat = $ScrollContainer/VBoxContainer/Material/MaterialPicker.edited_resource
	if mat == null:
		print_debug("Trying to use material, but no material set!")
		return
	if not mat is Material:
		print_debug("Resource must be material!")
	if obj is MeshInstance3D:
		obj.mesh.surface_set_material(0, mat)
	else:
		obj.material = mat #assume csg


func _on_MakeCube_pressed():
	#print ("Add Cube pressed!")
	AddCube()


# Adds a new cube to any selected objects, or scene root.
func AddCube():
	#print ("Add cube primitive")
	if !edi: return null # in case we tried to run scene, instead of use through editor
	
	var sizex = $ScrollContainer/VBoxContainer/Boxes/Size.value
	var sizey = $ScrollContainer/VBoxContainer/Boxes/Y.value
	var sizez = $ScrollContainer/VBoxContainer/Boxes/Z.value
	if !$ScrollContainer/VBoxContainer/Boxes/XYZ.button_pressed:
		sizey = sizex
		sizez = sizex
	
	var dest = GetDestParents()
	var options = GetOptions()
	
	#print ("options: ", options)
	#print ("dest:    ", dest)
	
	var csg
	var cube = null
	var shape = null
	if options["as_csg"]:
		csg = CSGBox3D.new()
		csg.size = Vector3(sizex, sizey, sizez)
		if options["with_collider"]:
			csg.use_collision = true
	else:
		if options["with_mesh"]:
			cube = BoxMesh.new()
			cube.size = Vector3(sizex, sizey, sizez)
		if options["with_collider"]:
			shape = BoxShape3D.new()
			shape.extents = Vector3(sizex/2, sizey/2, sizez/2)
	
	var i = 0
	for p in dest["parents"]:
		#print ("Adding shape ", i)
		i += 1
		var dup = null
		#print ("p == 0: ", p == dest["parents"][0])
		if options.as_csg:
			dup = csg if (p == dest["parents"][0]) else csg.duplicate()
		var nodes = BuildBase(options, p, dest["owner"], dup)
		if nodes[0] != p: nodes[0].name = "Cube"
		if nodes[1]:
			nodes[1].mesh = cube
			nodes[1].name = "CubeMesh"
			AdjustMaterial(nodes[1], options)
		if nodes[2]: #collider
			nodes[2].shape = shape
			nodes[2].name = "CubeShape"
		if nodes[3]:
			nodes[3].name = "CubeCSG"
			AdjustMaterial(nodes[3], options)


func _on_MakeSphere_pressed():
	#print ("Add sphere primitive")
	if !edi: return null # in case we tried to run scene, instead of use through editor
	
	var size = $ScrollContainer/VBoxContainer/Spheres/Size.value
	
	var dest = GetDestParents()
	var options = GetOptions()
	
	var m = null
	var shape = null
	var csg = null
	if options["as_csg"]:
		csg = CSGSphere3D.new()
		csg.radius = size
		csg.rings = 8
		csg.radial_segments = 16
		if options["with_collider"]:
			csg.use_collision = true
	else:
		if options["with_mesh"]:
			m = SphereMesh.new()
			m.radius = size
			m.height = 2 * size
		if options["with_collider"]:
			shape = SphereShape3D.new()
			shape.radius = size
	
	for p in dest["parents"]:
		var dup
		if options.as_csg:
			dup = csg if (p == dest["parents"][0]) else csg.duplicate()
		var nodes = BuildBase(options, p, dest["owner"], dup)
		if nodes[0] != p: nodes[0].name = "Sphere"
		if nodes[1]:
			nodes[1].mesh = m
			nodes[1].name = "SphereMesh"
			AdjustMaterial(nodes[1], options)
		if nodes[2]: #collider
			nodes[2].shape = shape
			nodes[2].name = "SphereShape"
		if nodes[3]:
			nodes[3].name = "SphereCSG"
			AdjustMaterial(nodes[3], options)


func _on_MakeCapsule_pressed():
	#print ("Add capsule primitive")
	if !edi: return null # in case we tried to run scene, instead of use through editor
	
	var height = $ScrollContainer/VBoxContainer/Capsule/Height.value
	var radius = $ScrollContainer/VBoxContainer/Capsule/Radius.value
	
	var dest = GetDestParents()
	var options = GetOptions()
	
	var m = null
	if options["with_mesh"]:
		m = CapsuleMesh.new()
		m.radius = radius
		m.height = height
	var shape = null
	if options["with_collider"]:
		shape = CapsuleShape3D.new()
		shape.radius = radius
		shape.height = height # - 2*radius
	
	for p in dest["parents"]:
		var dup
		var nodes = BuildBase(options, p, dest["owner"], dup)
		if nodes[0] != p: nodes[0].name = "Capsule"
		if nodes[1]:
			nodes[1].mesh = m
			nodes[1].name = "CapsuleMesh"
			AdjustMaterial(nodes[1], options)
		if nodes[2]: #collider
			nodes[2].shape = shape
			nodes[2].name = "CapsuleShape"
			
		match options["axis"]:
			0:
				if nodes[1]: nodes[1].rotation = Vector3(0,0,PI/2)
				if nodes[2]: nodes[2].rotation = Vector3(0,0,PI/2)
			1:
				if nodes[1]: nodes[1].rotation = Vector3(0,0,0)
				if nodes[2]: nodes[2].rotation = Vector3(0,0,0)
			2:
				if nodes[1]: nodes[1].rotation = Vector3(PI/2,0,0)
				if nodes[2]: nodes[2].rotation = Vector3(PI/2,0,0)


func _on_MakeCylinder_pressed():
	#print ("Add cylinder primitive")
	if !edi: return null # in case we tried to run scene, instead of use through editor
	
	var height = $ScrollContainer/VBoxContainer/Cylinder/Height.value
	var radius = $ScrollContainer/VBoxContainer/Cylinder/Radius.value
	
	AddCylinder(height, radius, radius, "Cylinder")

func _on_MakeCone_pressed():
	#print ("Add capsule primitive")
	if !edi: return null # in case we tried to run scene, instead of use through editor
	
	var height = $ScrollContainer/VBoxContainer/Cone/Height.value
	var r1 = $ScrollContainer/VBoxContainer/Cone/RadiusBottom.value
	var r2 = $ScrollContainer/VBoxContainer/Cone/RadiusTop.value
	
	AddCylinder(height, r1, r2, "Cone")

func AddCylinder(height, r1, r2, base_name):
	var dest = GetDestParents()
	var options = GetOptions()
	
	var m
	var shape
	var csg
	var is_cone = (r1 == 0 || r2 == 0)
	if options["as_csg"]:
		csg = CSGCylinder3D.new()
		csg.cone = is_cone
		csg.height = height
		csg.radius = max(r1,r2)
		csg.sides = 16
		if options["with_collider"]:
			csg.use_collision = true
	else:
		if options["with_mesh"]:
			m = CylinderMesh.new()
			m.height = height
			m.bottom_radius = r1
			m.top_radius = r2
		if options["with_collider"]:
			if r1 == r2:
				shape = CylinderShape3D.new()
				shape.radius = r1
				shape.height = height
			else:
				shape = m.create_convex_shape()
	
	for p in dest["parents"]:
		var dup
		if options.as_csg: 
			dup = csg if (p == dest["parents"][0]) else csg.duplicate()
		var nodes = BuildBase(options, p, dest["owner"], dup)
		if nodes[0] != p: nodes[0].name = base_name
		if nodes[1]:
			nodes[1].mesh = m
			nodes[1].name = base_name + "Mesh"
			AdjustMaterial(nodes[1], options)
		if nodes[2]: #collider
			nodes[2].shape = shape
			nodes[2].name = base_name + "Shape"
		if nodes[3]:
			nodes[3].name = "ConeCSG" if is_cone else "CylinderCSG"
			AdjustMaterial(nodes[3], options)
		
		match options["axis"]:
			2:
				if nodes[1]: nodes[1].rotation = Vector3(0,PI/2,PI/2)
				if nodes[2]: nodes[2].rotation = Vector3(0,PI/2,PI/2)
				if nodes[3]: nodes[3].rotation = Vector3(0,PI/2,PI/2)
			0:
				if nodes[1]: nodes[1].rotation = Vector3(0,0,PI/2)
				if nodes[2]: nodes[2].rotation = Vector3(0,0,PI/2)
				if nodes[3]: nodes[3].rotation = Vector3(0,0,PI/2)
#		match options["axis"]:
#			0: nodes[0].rotation_degrees = Vector3(0,0,90)	
#			1: nodes[0].rotation_degrees = Vector3(90,0,0)
#			2: nodes[0].rotation_degrees = Vector3(0,90,90)


func _on_MakePlane_pressed():
	var dest = GetDestParents()
	var options = GetOptions()
	
	var sizex = $ScrollContainer/VBoxContainer/Plane/Size.value
	var sizey = $ScrollContainer/VBoxContainer/Plane/Y.value
	if !$ScrollContainer/VBoxContainer/Plane/XY.button_pressed:
		sizey = sizex
		
	var m
	if options["with_mesh"]: 
		m = PlaneMesh.new()
		m.size = Vector2(sizex,sizey)
	var shape
	if options["with_collider"]:
		shape = BoxShape3D.new()
		shape.extents = Vector3(sizex/2, .005, sizey/2)
	
	for p in dest["parents"]:
		var dup
		var nodes = BuildBase(options, p, dest["owner"], dup)
		if nodes[0] != p: nodes[0].name = "Plane"
		if nodes[1]:
			nodes[1].mesh = m
			nodes[1].name = "PlaneMesh"
			AdjustMaterial(nodes[1], options)
		if nodes[2]: #collider
			nodes[2].shape = shape
			nodes[2].name = "PlaneShape"
			
		if options["axis"] == 2:
			if nodes[1]: nodes[1].rotation = Vector3(0,PI/2,PI/2)
			if nodes[2]: nodes[2].rotation = Vector3(0,PI/2,PI/2)
		elif options["axis"] == 0:
			if nodes[1]: nodes[1].rotation = Vector3(0,0,-PI/2)
			if nodes[2]: nodes[2].rotation = Vector3(0,0,-PI/2)


func _on_XYZ_toggled(button_pressed):
	if button_pressed:
		$ScrollContainer/VBoxContainer/Boxes/Size.prefix = "X:"
		$ScrollContainer/VBoxContainer/Boxes/Y.visible = true
		$ScrollContainer/VBoxContainer/Boxes/Z.visible = true
	else:
		$ScrollContainer/VBoxContainer/Boxes/Size.prefix = "Size:"
		$ScrollContainer/VBoxContainer/Boxes/Y.visible = false
		$ScrollContainer/VBoxContainer/Boxes/Z.visible = false


func _on_XY_toggled(button_pressed):
	if button_pressed:
		$ScrollContainer/VBoxContainer/Plane/Size.prefix = "X:"
		$ScrollContainer/VBoxContainer/Plane/Y.visible = true
	else:
		$ScrollContainer/VBoxContainer/Plane/Size.prefix = "Size:"
		$ScrollContainer/VBoxContainer/Plane/Y.visible = false


func _on_with_color_toggled(button_pressed):
	if button_pressed:
		$ScrollContainer/VBoxContainer/Material/WithMat.button_pressed = false


func _on_with_mat_toggled(button_pressed):
	if button_pressed:
		$ScrollContainer/VBoxContainer/ColorMat/WithColor.button_pressed = false


# Select for color if you change the color
func _on_color_picker_button_color_changed(color):
	$ScrollContainer/VBoxContainer/ColorMat/WithColor.button_pressed = true
	$ScrollContainer/VBoxContainer/Material/WithMat.button_pressed = false

# Don't allow plane or capsule when csg
func _on_as_csg_toggled(button_pressed):
	$ScrollContainer/VBoxContainer/Plane/MakePlane.disabled = button_pressed
	$ScrollContainer/VBoxContainer/Capsule/MakeCapsule.disabled = button_pressed
