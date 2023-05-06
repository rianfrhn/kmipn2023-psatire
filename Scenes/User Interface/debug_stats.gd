extends Control

@onready var text : RichTextLabel = $RichTextLabel
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var day = Game.get_day_string()
	var time = Game.get_time_string()
	
	var date = Game.get_full_date_string()
	var week = Game.week
	
	
	text.text = "Day = " + day + "\nDate: " +date+"\nWeek:"+str(week) +"\nTime: " + Game.get_time_string()
