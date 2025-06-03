@tool
class_name PlanetProperty extends Resource
@export var radius: float:
	set(p_radius):
		radius = p_radius
		changed.emit()
@export var radial_segments: int:
	set(p_radial_segments):
		radial_segments = p_radial_segments
		changed.emit()
@export var rings: int:
	set(p_rings):
		rings = p_rings
		changed.emit()
@export var color: Color:
	set(p_color):
		color = p_color
		changed.emit()

func _init(p_radius = 0.5, p_radial_segments = 256, p_rings = 224, p_color = Color.ANTIQUE_WHITE) -> void:
	radius = p_radius
	radial_segments = p_radial_segments
	rings = p_rings
	color = p_color
