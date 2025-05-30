@tool
extends Node3D

@export var property: Resource:
	set(p_resource):
		if property != null:
			property.changed.disconnect(_on_resource_set)
		property = p_resource
		property.changed.connect(_on_resource_set)

@export var planet: MeshInstance3D

func _on_resource_set():
	if property:
		planet.mesh.radius = property.radius
		planet.mesh.height = property.height
		planet.mesh.surface_get_material(0).albedo_color = property.color;
