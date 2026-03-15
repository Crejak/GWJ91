class_name Character

extends CharacterBody2D

@export var can_move: bool = false;

## Minimum walking speed, in pixel per second
@export var min_speed: float = 25.;
## Maximum running speed, in pexel per second
@export var max_speed: float = 100.;
## Minimum distance between the mouse and the character that triggers movement, in pixels
@export var min_mouse_detection_range: float = 10.;
## Maximum distance between the mouse and the character that makes the player moves at minimum speed.
## If the mouse is at a greater distance than this value, the speed of the player scales with the mouse distance.
@export var min_speed_mouse_range: float = 50.;
@export var max_speed_mouse_range: float = 200.;

func _physics_process(_delta: float) -> void:
	if !can_move:
		return;
	var distance := get_mouse_distance_in_viewport_space();
	velocity = get_velocity_from_distance_to_cursor(distance);
	move_and_slide();
	
func get_mouse_distance_in_viewport_space() -> float:
	var viewport_mouse_position := get_viewport().get_mouse_position();
	var viewport_player_position := get_global_transform_with_canvas().get_origin();
	# TODO optimize with squared values
	return viewport_mouse_position.distance_to(viewport_player_position);

func get_velocity_from_distance_to_cursor(distance: float) -> Vector2:
	if distance < min_mouse_detection_range:
		return Vector2.ZERO;
	else:
		var direction := global_position.direction_to(get_global_mouse_position());
		var speed := min_speed;
		if distance > min_speed_mouse_range:
			speed = clamp(
				remap(distance, min_speed_mouse_range, max_speed_mouse_range, min_speed, max_speed),
				min_speed, max_speed
			);
		return direction * speed;
