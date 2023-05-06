extends Control

var component

func set_component(stock : StockResource):
	var componentname = $RichTextLabel
	var button = $Button
	if stock == null:
		button.text = "+"
		button.pressed.connect(_on_add_component)
	else:
		component = stock
		componentname.text = str(stock.stock_name)
		button.pressed.connect(_on_remove_component)
		
# Called when the node enters the scene tree for the first time.

func _on_add_component():
	print("Adding Component")
	Game.operation_updated.emit()
	pass
func _on_remove_component():
	print("Removing Component")
	Game.remove_component(Game.on_operation, component)
	Game.operation_updated.emit()
