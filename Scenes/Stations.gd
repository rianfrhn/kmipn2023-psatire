extends StaticBody3D
class_name Station

var menu_trigger : Area3D
var waiting_prompt = false
var item_place
@export var menu : PackedScene
@export var items : Array[FixableResource]
@export var items_offset : Vector3
@export var capacity : int
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
		waiting_prompt = true
		body.await_prompt()

func _on_body_exited(body):
	if(body is Player):
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
