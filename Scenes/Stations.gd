extends StaticBody3D
class_name Station

var menu_trigger : Area3D
var waiting_prompt = false
var item_place
@export var menu : PackedScene
@export var items : Array[FixableResource]
@export var items_offset : Vector3
@export var capacity : int

var outline : MeshInstance3D
@onready var prompt_image: Control = load("res://Scenes/User Interface/prompt.tscn").instantiate()
@onready var context_label: Label = prompt_image.get_node("context")
@onready var table_name: Label = Label.new()

#@onready var screen_width = get_viewport().get_visible_rect().size.x
#@onready var screen_height = get_viewport().get_visible_rect().size.y

# Called when the node enters the scene tree for the first time.
func initial(items_place):
	item_place = items_place
	update_items()
	pass
	
func set_trigger(trigger : Area3D):
	menu_trigger = trigger
	trigger.body_entered.connect(_on_body_entered)
	trigger.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if(body is Player):
		if Game.day != 0:
			add_child(prompt_image)
		waiting_prompt = true
		body.await_prompt()

func _on_body_exited(body):
	if(body is Player):
		if Game.day != 0:
			remove_child(prompt_image)
		body.leave_prompt()
		waiting_prompt = false


func update_items():
	for node in item_place.get_children():
		node.queue_free()
	
	
	var n = 0
	var len = items.size()
	if len == 0: return
	var init_coord = items_offset/2 * -(len-1)
	for item in items:
		var item_object = item.scene.instantiate()
		item_place.add_child(item_object)
		
		item_object.position = init_coord + (n*items_offset)
		n += 1

func set_items(itemarray : Array[FixableResource]):
	items = itemarray


func hide_outline():
	if Game.day != 0:
		outline.hide()
		remove_child(table_name)

func show_outline():
	if Game.day != 0:
		set_label_position()
		add_child(table_name)
		outline.show()

func set_label_position():
	pass
	
func change_position(table_position: Vector2, promp_offset: Vector2 , name_offset: Vector2):
	prompt_image.global_position = table_position - promp_offset
	table_name.global_position = table_position - name_offset
