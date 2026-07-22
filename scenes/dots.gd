extends Node3D

@onready var multimesh : MultiMesh = $MultiMeshInstance3D.multimesh

func _ready() -> void:
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.use_colors = true
	
	var mesh = SphereMesh.new()
	mesh.radius = 0.1
	mesh.height = 0.2
	
	var material := StandardMaterial3D.new()
	var material_nextpass := StandardMaterial3D.new()

	#material.albedo_color = Color.BLACK
	material.vertex_color_use_as_albedo = true
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.stencil_mode = BaseMaterial3D.STENCIL_MODE_CUSTOM
	material.stencil_flags = BaseMaterial3D.STENCIL_FLAG_WRITE# | BaseMaterial3D.STENCIL_FLAG_WRITE_DEPTH_FAIL
	
	material.next_pass = material_nextpass
	material_nextpass.no_depth_test = true
	material_nextpass.grow = true 
	material_nextpass.grow_amount = 0.05
	material_nextpass.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material_nextpass.stencil_flags = BaseMaterial3D.STENCIL_FLAG_READ
	material_nextpass.stencil_mode = BaseMaterial3D.STENCIL_MODE_CUSTOM
	material_nextpass.stencil_compare = BaseMaterial3D.STENCIL_COMPARE_GREATER
	
	multimesh.mesh = mesh
	multimesh.mesh.surface_set_material(0, material)

func update_points(positions: Array[Vector3], color: Array[Color]):
	multimesh.instance_count = positions.size()

	for i in positions.size():
		var trns = Transform3D(Basis(), positions[i])
		multimesh.set_instance_transform(i, trns)
		
	for i in color.size():
		multimesh.set_instance_color(i, color[i])

func _on_antenna_array_dot_update(positions: Array[Vector3], color: Array[Color]) -> void:
	update_points(positions, color)
