@tool
extends Node3D

var material: Material

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

@export var planet: MeshInstance3D

func _on_property_changed():
	if material != null:
		planet.mesh.radius = property.radius
		planet.mesh.height = property.height
		material.albedo_color = property.color;
	material = planet.mesh.surface_get_material(0)

func _on_noise_changed():
	if material != null:
		material.set_shader_parameter("strength", planetNoise.strength)
		material.set_shader_parameter("octaves", planetNoise.octaves)
		material.set_shader_parameter("baseRoughness", planetNoise.baseRoughness)
		material.set_shader_parameter("roughness", planetNoise.roughness)
		material.set_shader_parameter("persistance", planetNoise.persistance)
		material.set_shader_parameter("center", planetNoise.center)
		material.set_shader_parameter("minValue", planetNoise.minValue)
	material = planet.mesh.surface_get_material(0)
