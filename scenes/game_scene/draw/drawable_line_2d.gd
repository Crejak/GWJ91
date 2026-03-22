extends Line2D
class_name drawable_line_2d

@export var color: Color

const min_step = 5
var last_point: Vector2

func add_new_point(mouse_pos: Vector2) -> void:
	if last_point != Vector2.ZERO && last_point.distance_to(mouse_pos) < min_step :
		return
	
	add_point(mouse_pos)
	last_point = mouse_pos

func _draw() -> void:
	if get_point_count() == 1:
		draw_circle(last_point, width/2, color)
