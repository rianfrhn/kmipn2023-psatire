extends Control

@onready var date_text = $ColorRect/VBoxContainer/Date
@onready var time_text = $ColorRect/VBoxContainer/Time
@onready var money_text = $ColorRect/VBoxContainer/Money
@onready var arrow = $Arrow
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var day = Game.get_day_string()
	var time = Game.get_time_string()
	var degree = -180 - ((Game.timehr-7 + Game.timemin/60.0)/(16.0-7)*180)
	var date = Game.get_full_date_string()
	var week = Game.week
	var money = Game.money
	date_text.text = day+", "+date
	time_text.text = "[center]"+time
	arrow.rotation_degrees = degree
	money_text.text = "[right]Rp "+str(money)
	
