extends GameButton
@onready var thismenu = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	pressed.connect(_on_click)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_click():
	thismenu.queue_free()
