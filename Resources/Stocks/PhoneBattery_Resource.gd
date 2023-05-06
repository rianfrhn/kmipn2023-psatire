extends StockResource
class_name PhoneBattery_Resource

func _init(broken : bool):
	stock_name = "Batre HP"
	stock_desc = "Baterai untuk HP"
	stock_cost = 80000
	arrival_days = 4
	is_broken = broken
