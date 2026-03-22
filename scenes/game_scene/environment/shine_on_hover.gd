extends PointLight2D

var parent_area_2d: Area2D;

func _process(delta: float) -> void:
	var mouse_distance =  global_position.distance_to(get_global_mouse_position())
	var light_power_inversed = min(mouse_distance, 100)
	energy = abs(light_power_inversed-100) /10
