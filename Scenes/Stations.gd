extends StaticBody3D
class_name Station

var menu_trigger : Area3D
var waiting_prompt = false
var item_place
var outline : MeshInstance3D
@export var menu : PackedScene
@export var items : Array[FixableResource]
@export var items_offset : Vector3
@export var capacity : int

@onready var prompt_image: Control = load("res://Scenes/User Interface/prompt.tscn").instantiate()
@onready var context_label: Label = prompt_image.get_node("context")
@onready var table_name: Label = Label.new()
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
	if(body is Player) and Game.game_state == Game.STATE.RUNNING:
		waiting_prompt = true
		body.await_prompt()
		add_child(prompt_image)

func show_outline():
	if Game.game_state == Game.STATE.RUNNING:
		outline.show()
		add_label()
		add_child(table_name)

func add_label():
	pass

func hide_outline():
	if Game.game_state == Game.STATE.RUNNING:
		outline.hide()
		remove_child(table_name)

func _on_body_exited(body):
	if(body is Player):
		body.leave_prompt()
		waiting_prompt = false
		remove_child(prompt_image)

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
