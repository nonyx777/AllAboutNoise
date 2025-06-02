@tool
class_name PlanetProperty extends Resource
@export var radius: float:
	set(p_radius):
		radius = p_radius
		changed.emit()
@export var color: Color:
	set(p_color):
		color = p_color
		changed.emit()

func _init(p_radius = 0.5, p_color = Color.ANTIQUE_WHITE) -> void:
	radius = p_radius
	color = p_color
