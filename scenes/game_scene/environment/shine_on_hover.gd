@tool
extends PointLight2D

var parent_area_2d: Area2D;

func _process(delta: float) -> void:
	if global_position.distance_to(get_global_mouse_position()) < 100:
		print_debug("hohihoi")
		visible = true
	else :
		visible = false
