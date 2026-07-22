extends Control

@export var antenna: Antenna
@onready var list := %ItemContainer

const LAYER_ITEM = preload("res://scenes/antenna_container.tscn")

func _ready():
	list.child_entered_tree.connect(_on_child_entered)
	
	for child in list.get_children():
		_connect_child(child)

func _on_child_entered(child):
	_connect_child(child)

func _connect_child(child):
	if child is AntennaContainer:
		if child.has_signal("update_parameters"):
			child.update_parameters.connect(_on_antenna_update)
		if child.has_signal("update_parameters"):
			child.delete_parameters.connect(_on_antenna_delete)

func _on_antenna_update(antenna_parameters: AntennaParameters, index: int):
	if antenna != null:
		antenna.antenna_parameters[index] = antenna_parameters
		antenna.update_shape()
		

var deletion_offset : int = 0	
func _on_antenna_delete(index: int):
	if antenna != null:
		antenna.antenna_parameters.erase(index)
		antenna.update_shape()

func _on_add_pressed():
	var item = LAYER_ITEM.instantiate()
	list.add_child(item)
	
func _on_toggle_menu_toggled(toggled_on: bool) -> void:
	%ScrollContainer.visible = !toggled_on
