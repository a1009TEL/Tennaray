@tool
class_name TestMesh
#extends EditorScript

#func _run() -> void:
	#print("Running...")
	#var scene = EditorInterface.get_edited_scene_root()
	#if scene == null:
		#printerr("There is no scene to create the mesh")
		#return
#
	#var mesh_instance := MeshInstance3D.new()
	#mesh_instance.name = "Generated Mesh"
	#
	#scene.add_child(mesh_instance)
	#mesh_instance.owner = scene
#
	#var arr_mesh := generate_ico_sphere(5, 1.0)
	#mesh_instance.mesh = arr_mesh
	#print(arr_mesh.get_surface_count())

func generate_ico_sphere(subdivisions: int = 1, radius: float = 1.0) -> ArrayMesh:
	var vertices := PackedVector3Array()
	var indices := PackedInt32Array()

	# Golden ratio
	var t = (1.0 + sqrt(5.0)) / 2.0

	var base_vertices = [
		Vector3(-1, t, 0), Vector3(1, t, 0),
		Vector3(-1, -t, 0), Vector3(1, -t, 0),
		Vector3(0, -1, t), Vector3(0, 1, t),
		Vector3(0, -1, -t), Vector3(0, 1, -t),
		Vector3(t, 0, -1), Vector3(t, 0, 1),
		Vector3(-t, 0, -1), Vector3(-t, 0, 1)
	]

	for v in base_vertices:
		vertices.append(v.normalized() * radius)

	var faces = [
		[0,11,5], [0,5,1], [0,1,7], [0,7,10], [0,10,11],
		[1,5,9], [5,11,4], [11,10,2], [10,7,6], [7,1,8],
		[3,9,4], [3,4,2], [3,2,6], [3,6,8], [3,8,9],
		[4,9,5], [2,4,11], [6,2,10], [8,6,7], [9,8,1]
	]

	# Subdivide
	for i in range(subdivisions):
		var new_faces = []

		for face in faces:
			var a = get_middle_point(vertices, face[0], face[1], radius)
			var b = get_middle_point(vertices, face[1], face[2], radius)
			var c = get_middle_point(vertices, face[2], face[0], radius)

			new_faces.append([face[0], a, c])
			new_faces.append([face[1], b, a])
			new_faces.append([face[2], c, b])
			new_faces.append([a, b, c])

		faces = new_faces

	# Convert faces to triangle indices
	for face in faces:
		indices.append(face[2])
		indices.append(face[1])
		indices.append(face[0])

	var normals := PackedVector3Array()

	for v in vertices:
		normals.append(v.normalized())

	var arrays = []	
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_NORMAL] = normals
	arrays[Mesh.ARRAY_INDEX] = indices

	var arr_mesh := ArrayMesh.new()
	arr_mesh.add_surface_from_arrays(
		Mesh.PRIMITIVE_TRIANGLES,
		arrays
	)

	return arr_mesh

func get_middle_point(
	vertices: PackedVector3Array,
	a: int,
	b: int,
	radius: float
) -> int:
	var midpoint = (vertices[a] + vertices[b]).normalized() * radius
	vertices.append(midpoint)
	return vertices.size() - 1

func regenerate_mesh() -> ArrayMesh:
	var vertices = PackedVector3Array()
	vertices.push_back(Vector3(0, 1, 0))
	vertices.push_back(Vector3(1, 0, 0))
	vertices.push_back(Vector3(0, 0, 1))

	# Initialize the ArrayMesh.
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices

	# Create the Mesh.
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return arr_mesh
