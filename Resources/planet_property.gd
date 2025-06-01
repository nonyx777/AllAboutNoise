@tool
class_name PlanetProperty extends Resource
@export var radius: float:
	set(p_radius):
		radius = p_radius
		changed.emit()
@export var height: float:
	set(p_height):
		height = p_height
		changed.emit()
@export var color: Color:
	set(p_color):
		color = p_color
		changed.emit()

func _init(p_radius = 0.5, p_height = 1.0, p_color = Color.ANTIQUE_WHITE) -> void:
	radius = p_radius
	height = p_height
	color = p_color
