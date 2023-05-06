extends StockResource
class_name LCD_Resource

func _init(broken : bool) -> void:
	
	stock_name = "LCD"
	stock_desc = "Layar Crystal Display untuk elektronik"
	stock_cost = 10000
	arrival_days = 1
	is_broken = broken
	
	#display_picture : Texture
