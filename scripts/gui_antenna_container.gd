class_name AntennaContainer
extends PanelContainer

var antenna_paramters: AntennaParameters

static var last_index: int = 0
var index: int

signal update_parameters(antenna_parameters: AntennaParameters, index: int)
signal delete_parameters(index: int)

func _ready():
	var color := $MarginContainer/VBoxContainer/HBoxContainer4/ColorPickerButton
	color.color = Color.from_hsv(randf(), 0.80, 0.5)
	antenna_paramters = AntennaParameters.new()
	index = last_index
	last_index += 1
	
	antenna_paramters.color = %ColorPickerButton.color
	antenna_paramters.position = Vector3.ZERO
	antenna_paramters.magnitude = 1.0 # This is cheating
	antenna_paramters.phase = 0.0
	antenna_paramters.active = true
	update_parameters.emit(antenna_paramters, index)
	
func _on_remove_pressed() -> void:
	delete_parameters.emit(index)
	queue_free()

func _on_x_value_changed(value: float) -> void:
	antenna_paramters.position.x = value
	update_parameters.emit(antenna_paramters, index)
func _on_y_value_changed(value: float) -> void:
	antenna_paramters.position.z = -value # Adjusted for godots coord system
	update_parameters.emit(antenna_paramters, index)
func _on_z_value_changed(value: float) -> void:
	antenna_paramters.position.y = value # Adjusted for godots coord system
	update_parameters.emit(antenna_paramters, index)
func _on_mag_value_changed(value: float) -> void:
	antenna_paramters.magnitude = value
	update_parameters.emit(antenna_paramters, index)
func _on_phase_value_changed(value: float) -> void:
	antenna_paramters.phase = value
	update_parameters.emit(antenna_paramters, index)
func _on_color_picker_button_color_changed(color: Color) -> void:
	antenna_paramters.color = color
	update_parameters.emit(antenna_paramters, index)
func _on_hide_toggled(toggled_on: bool) -> void:
	antenna_paramters.active = !toggled_on
	update_parameters.emit(antenna_paramters, index)
