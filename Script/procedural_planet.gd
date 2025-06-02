@tool
extends Node3D

var material: Material
var meshInstance: MeshInstance3D
var primitive_mesh: SphereMesh
var array_mesh: ArrayMesh
var mdt: MeshDataTool

@export var property: PlanetProperty:
	set(p_resource):
		if property != null:
			property.changed.disconnect(_on_property_changed)
		property = p_resource
		property.changed.connect(_on_property_changed)
@export var planetNoise: PlanetNoise:
	set(p_planetNoise):
		if planetNoise != null:
			planetNoise.changed.disconnect(_on_noise_changed)
		planetNoise = p_planetNoise
		planetNoise.changed.connect(_on_noise_changed)

@export_tool_button("Vertex") var change_vertex_tool_button = change_vertex

func _on_property_changed():
	# Remove all MeshInstance3D children
	#clear_mesh()
	
	if material == null:
		material = Material.new()
	if primitive_mesh == null:
		primitive_mesh = SphereMesh.new()
	if array_mesh == null:
		array_mesh = ArrayMesh.new()
	if mdt == null:
		mdt = MeshDataTool.new()
		
	array_mesh.clear_surfaces()
	material.albedo_color = property.color;
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
	meshInstance.mesh.surface_set_material(1, material)

func _on_noise_changed():
	if material == null:
		material = Material.new()
	material.set_shader_parameter("strength", planetNoise.strength)
	material.set_shader_parameter("octaves", planetNoise.octaves)
	material.set_shader_parameter("baseRoughness", planetNoise.baseRoughness)
	material.set_shader_parameter("roughness", planetNoise.roughness)
	material.set_shader_parameter("persistance", planetNoise.persistance)
	material.set_shader_parameter("center", planetNoise.center)
	material.set_shader_parameter("minValue", planetNoise.minValue)

func change_vertex():
	if material == null:
		return
	var primitive_mesh = SphereMesh.new()
	var array_mesh = ArrayMesh.new()
	var arrays = primitive_mesh.surface_get_arrays(0)
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	var mdt = MeshDataTool.new()
	mdt.create_from_surface(array_mesh, 0)
	for i in range(mdt.get_vertex_count()):
		var vertex = mdt.get_vertex(i)
		vertex += mdt.get_vertex_normal(i)
		mdt.set_vertex(i, vertex)
	var _radius:float = (mdt.get_vertex(0) - Vector3.ZERO).length()
	property.radius = 1.0
	mdt.commit_to_surface(array_mesh)
	material.albedo_color = property.color
	#planet.mesh = array_mesh
	#planet.mesh.surface_set_material(0, material)

func clear_mesh():
	for child in get_children():
		if child is MeshInstance3D:
			remove_child(child)
			child.queue_free()
