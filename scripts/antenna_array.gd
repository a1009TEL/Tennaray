class_name Antenna
extends Node3D

@export var antenna_parameters: Dictionary[int, AntennaParameters] = {}
@export var lambda: float = 1.0

signal dot_update(positions: Array[Vector3], color: Array[Color])

func _ready() -> void:
	var testmesh := TestMesh.new()
	var arr_mesh = testmesh.generate_ico_sphere(5, 1.0)
	var material = ShaderMaterial.new()
	material.shader = preload("res://shaders/antenna.gdshader")
	
	$"Generated Mesh".mesh = arr_mesh
	$"Generated Mesh".set_surface_override_material(0, material)
	update_shape()

func update_shape() -> void:
	var mat = $"Generated Mesh".get_active_material(0) as ShaderMaterial
	
	var antennas_col: Array[Color] = []
	var antennas_pos: Array[Vector3] = []
	var antennas_feed_coeff: Array[Vector2] = []
	for ap in antenna_parameters:
		var parameter = antenna_parameters[ap]
		if parameter.active:
			antennas_col.append(parameter.color)
			antennas_pos.append(parameter.position)
			antennas_feed_coeff.append(parameter.get_feed_vector())
		
	dot_update.emit(antennas_pos, antennas_col)
	
	mat.set_shader_parameter("antennas_pos", antennas_pos)
	mat.set_shader_parameter("antennas_feed_coeff", antennas_feed_coeff)
	mat.set_shader_parameter("antennas_count", antenna_parameters.size())
	mat.set_shader_parameter("lambda", 1.0)
