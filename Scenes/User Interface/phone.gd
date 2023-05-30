extends NinePatchRect
@onready var day_label = $VBoxContainer/Top/Date
@onready var time_label = $VBoxContainer/Top/Time
@onready var continue_button = $VBoxContainer/Bottom/PhoneContinueButton
# Called when the node enters the scene tree for the first time.


func _ready():
	continue_button.pressed.connect(_on_continue)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	day_label.text = Game.get_full_date_string()
	time_label.text = Game.get_time_string()

func _on_continue():
	queue_free()
	Game.start_week()
