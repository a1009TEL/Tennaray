class_name AntennaParameters
extends Resource

@export var color: Color
@export var position: Vector3
@export var magnitude: float
@export var phase: float
var active: bool

func get_feed_vector():
	return Vector2(cos(phase / 180.0 * PI), sin(phase / 180.0 * PI)) * magnitude
