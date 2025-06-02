@tool
extends Node3D

var material: StandardMaterial3D
var meshInstance: MeshInstance3D
var primitive_mesh: SphereMesh
var array_mesh: ArrayMesh
var mdt: MeshDataTool
var noise: FastNoiseLite

@export var property: PlanetProperty:
	set(p_resource):
		if property != null:
			property.changed.disconnect(_on_property_changed)
		property = p_resource
		property.changed.connect(_on_property_changed)
@export var planetNoise: PlanetNoise:
	set(p_planetNoise):
		if planetNoise != null:
			planetNoise.changed.disconnect(_on_generate_noise_on_planet)
		planetNoise = p_planetNoise
		planetNoise.changed.connect(_on_generate_noise_on_planet)

#@export_tool_button("Generate") var generate_noise_tool_button = _on_generate_noise_on_planet

func _on_property_changed():
	# Remove all MeshInstance3D children
	#clear_mesh()
	
	if material == null:
		material = StandardMaterial3D.new()
	if primitive_mesh == null:
		primitive_mesh = SphereMesh.new()
	if array_mesh == null:
		array_mesh = ArrayMesh.new()
	if mdt == null:
		mdt = MeshDataTool.new()
		
	array_mesh.clear_surfaces()
	var arrays = primitive_mesh.surface_get_arrays(0)
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	mdt.create_from_surface(array_mesh, 0)
	for i in range(mdt.get_vertex_count()):
		var vertex = mdt.get_vertex(i)
		vertex += mdt.get_vertex_normal(i) * property.radius
		mdt.set_vertex(i, vertex)
	mdt.commit_to_surface(array_mesh)
	if meshInstance == null:
		meshInstance = MeshInstance3D.new()
		add_child(meshInstance)
	meshInstance.mesh = array_mesh
	material.albedo_color = property.color
	meshInstance.mesh.surface_set_material(1, material)

func _on_generate_noise_on_planet():
	if primitive_mesh == null or array_mesh == null or mdt == null or meshInstance == null:
		return
	array_mesh.clear_surfaces()
	var arrays = primitive_mesh.surface_get_arrays(0)
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	mdt.create_from_surface(array_mesh, 0)
	for i in range(mdt.get_vertex_count()):
		var vertex = mdt.get_vertex(i)
		vertex += mdt.get_vertex_normal(i) * configure_noise(vertex, 10)
		mdt.set_vertex(i, vertex)
	
	# Recalculate Normals
	for i in range(mdt.get_face_count()):
		var a = mdt.get_face_vertex(i, 0)
		var b = mdt.get_face_vertex(i, 1)
		var c = mdt.get_face_vertex(i, 2)
		
		var ap = mdt.get_vertex(a)
		var bp = mdt.get_vertex(b)
		var cp = mdt.get_vertex(c)
		
		var n = (bp - cp).cross(ap - bp).normalized()
		
		mdt.set_vertex_normal(a, n + mdt.get_vertex_normal(a))
		mdt.set_vertex_normal(b, n + mdt.get_vertex_normal(b))
		mdt.set_vertex_normal(c, n + mdt.get_vertex_normal(c))
		
	for i in range(mdt.get_vertex_count()):
		var v = mdt.get_vertex_normal(i).normalized()
		mdt.set_vertex_normal(i, v)
	
	mdt.commit_to_surface(array_mesh)
	meshInstance.mesh = array_mesh
	meshInstance.mesh.surface_set_material(1, material)

func clear_mesh():
	material = null
	meshInstance = null
	primitive_mesh = null
	array_mesh = null
	mdt = null
	noise = null
	for child in get_children():
		if child is MeshInstance3D:
			remove_child(child)
			child.queue_free()

func configure_noise(position: Vector3, seed: int) -> float:
	if noise == null:
		noise = FastNoiseLite.new()
	noise.seed = seed
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.fractal_octaves = planetNoise.octaves
	noise.frequency = planetNoise.baseRoughness
	noise.fractal_lacunarity = planetNoise.roughness
	noise.fractal_gain = planetNoise.persistance
	return (noise.get_noise_3d(position.x, position.y, position.z) + 1) * 0.5
