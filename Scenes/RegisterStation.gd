extends Station

@onready var trigger = $Trigger
@onready var notice: TextureRect = TextureRect.new()
@onready var notice_image: Texture2D = preload("res://Assets/User Interface/notice.png")

var register_position
# Called when the node enters the scene tree for the first time.
func _ready():
	outline = $"Cash Register/Cash Register2/MeshInstance3D"
	table_name.text = "Meja Konter"
	table_name.add_theme_color_override("font_color", Color("#3991e6"))
	
	set_trigger(trigger)
	Game.register_added.connect(request_coming)
	Game.customer_served.connect(on_customer_left)
	Game.customer_left.connect(on_customer_left)
	get_viewport().size_changed.connect(resolution_changed)
	
	trigger.body_entered.connect(register_entered)
	mouse_entered.connect(show_outline)
	mouse_exited.connect(hide_outline)
	notice.texture = notice_image
	register_position = get_viewport().get_camera_3d().unproject_position(global_transform.origin)
	notice.position = register_position - Vector2(120, 130)
	context_label.text = "Ambil order"

func _unhandled_input(event):
	if event.is_action_pressed("game_interact"):
		if !waiting_prompt: return
		Game.player_object.set_target_rotation_global(global_position)
		if Game.on_hand == null:
			Game.open_menu(menu)

func request_coming(customer: CustomerResource):
	add_child(notice)

func on_customer_left(customer: CustomerResource):
	remove_child(notice)

func register_entered(body):
	prompt_image.position = register_position - Vector2(80, 60)

func set_label_position():
	table_name.position = register_position - Vector2(0, 90)

func resolution_changed():
	register_position = get_viewport().get_camera_3d().unproject_position(global_transform.origin)
	notice.global_position = register_position - Vector2(120, 130)
	change_position(register_position, Vector2(80, 60), Vector2(0, 90))
