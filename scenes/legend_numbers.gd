extends VBoxContainer

@export var ticks : int = 13

func fract(x: float) -> float:
	return x - floor(x)

func hsv_to_rgb(h: float, s: float, v: float) -> Color:
	var k = Vector4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0)

	var p = Vector3(
		abs(fract(h + k.y) * 6.0 - k.w),
		abs(fract(h + k.z) * 6.0 - k.w),
		abs(fract(h + k.x) * 6.0 - k.w)
	)

	var rgb = Vector3(
		v * lerpf(1.0, clampf(p.x - 1.0, 0.0, 1.0), s),
		v * lerpf(1.0, clampf(p.y - 1.0, 0.0, 1.0), s),
		v * lerpf(1.0, clampf(p.z - 1.0, 0.0, 1.0), s)
	)

	return Color(rgb.x, rgb.y, rgb.z)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(ticks):
		var label = Label.new()
		var angle = (float(i)/(ticks-1)*360 - 180)
		label.text = String.num(angle, 0) + "°"
		label.size_flags_vertical = Control.SIZE_EXPAND_FILL
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		
		if i%3 == 0:
			label.add_theme_font_size_override("font_size", 16)
		else:
			label.add_theme_font_size_override("font_size", 11)
			label.add_theme_color_override("font_color", Color.DIM_GRAY)
		
		add_child(label)
