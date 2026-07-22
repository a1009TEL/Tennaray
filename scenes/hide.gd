extends Button

var ICON_SHOWN = preload("res://assets/eye.svg")
var ICON_HIDDEN = preload("res://assets/eye-off.svg")

func _on_toggled(_toggled_on: bool) -> void:
	if button_pressed:
		icon = ICON_HIDDEN
	else:
		icon = ICON_SHOWN
