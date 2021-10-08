extends TextureProgress

func _ready():
	tint_progress = Color(0.0, 1.0, 0.0, 1.0)
	value = 100
	visible = false

func change_progress(new_value):
	visible = true
	var red_percet = min(1.0, -2*new_value/100+2)
	var green_percent = min(1.0, 2*new_value/100)
	tint_progress = Color(1.0*(red_percet), 1.0*(green_percent), 0.0, 1.0)
	print(red_percet, green_percent)
	value = new_value
