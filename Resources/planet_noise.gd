@tool
class_name PlanetNoise extends Resource
@export var strength: float:
	set(p_strength):
		strength = p_strength
		changed.emit()
@export var octaves: int:
	set(p_octaves):
		octaves = p_octaves
		changed.emit()
@export var baseRoughness: float:
	set(p_baseRoughness):
		baseRoughness = p_baseRoughness
		changed.emit()
@export var roughness: float:
	set(p_roughness):
		roughness = p_roughness
		changed.emit()
@export var persistance: float:
	set(p_persistance):
		persistance = p_persistance
		changed.emit()
@export var center: Vector3:
	set(p_center):
		center = p_center
		changed.emit()
@export var minValue: float:
	set(p_minValue):
		minValue = p_minValue
		changed.emit()

func _init(p_strength = 1.0, p_octaves = 8, p_baseRoughness = 5.0, p_roughness = 2, p_persistance = 0.5, p_center = Vector3.ZERO, p_minValue = 0.0) -> void:
	strength = p_strength
	octaves = p_octaves
	baseRoughness = p_baseRoughness
	roughness = p_roughness
	persistance = p_persistance
	center = p_center
	minValue = p_minValue
