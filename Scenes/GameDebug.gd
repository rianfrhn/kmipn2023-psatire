extends RichTextLabel


# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = ""
	text += "On Customer Week Queue:\n"
	for x in Game.on_customer_week_queue:
		text += str(x)+"\n"
	text += "On Register Queue:\n"
	for x in Game.on_register:
		text += str(x)+"\n"
	text += "On Served Queue:\n"
	for x in Game.on_customer_served:
		text += str(x)+"\n"
	
	
