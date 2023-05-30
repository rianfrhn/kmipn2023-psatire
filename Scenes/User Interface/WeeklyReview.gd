extends Control
@onready var button = $MarginContainer/NinePatchRect/Button
@onready var text = $MarginContainer/NinePatchRect/VBoxContainer/RichTextLabel2
# Called when the node enters the scene tree for the first time.
func _ready():
	button.pressed.connect(destroy_this)
	var served = Game.num_customer_served
	var jasa_selesai = Game.customer_satisfied
	var dikembalikan = Game.customer_denied
	var gain = Game.after_money - Game.previous_money
	var rating = Game.after_rating
	var rating_gain = rating - Game.previous_rating
	var modal = Game.money_spent
	var profit = gain-modal
	var performa = (jasa_selesai-dikembalikan * 1.0)/served if served >0 else 1.0
	var rating_gain_text = "[color=#FF0000]("+str(rating_gain)+")[/color]" if rating_gain <=0 else "[color=#00FF00]("+str(rating_gain)+")[/color]"
	var profit_text = "[color=#FF0000]"+str(profit)+"[/color]" if profit <= 0 else "[color=#FF0000] Rp"+str(profit)+"[/color]"
	var formatter = {
		"diterima":served,
		"selesai":jasa_selesai,
		"dikembalikan":dikembalikan,
		"performa":str(round(performa * 100))+"%",
		"nilai": str(rating) + "/5 "+rating_gain_text,
		"modal":modal,
		"penghasilan":gain,
		"keuntungan":profit_text
		
	}
	

	
	
	text.text = "Performa
		Pelanggan Diterima	: {diterima}
		Jumlah Jasa Selesai		: {selesai}
		Jumlah Dikembalikan	: {dikembalikan}
		Performa						: {performa}

		Nilai Usaha					: {nilai}
		

Pendapatan
		Modal								: Rp{modal}
		Penghasilan					: Rp{penghasilan}

		Keuntungan					: {keuntungan}".format(formatter)

func destroy_this():
	queue_free()
