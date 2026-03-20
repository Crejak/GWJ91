extends PNJ_State
class_name PNJ_State_Chase

func _enter_state() -> void:
	pnj.sprite.texture = pnj.walk_texture
	pnj.status_animations.play("chase")
	pnj.clear()
	pnj.reparent(pnj.chase_path)
	var pos: Vector2 = pnj.body.global_position
	pnj.progress = pnj.chase_path.curve.get_closest_offset(pnj.chase_path.to_local(pos))
	pnj.loop = true

	pnj.body.sleeping = false
	pnj.body.top_level = true
	pnj.body.global_position = pos
	pnj.animation_player.play("move")

func _physics_process(delta: float) -> void:
	pnj.sprite.flip_h = pnj.body.linear_velocity.x < 0
	var distance_to_path: float = pnj.body.global_position.distance_squared_to(pnj.global_position)
	pnj.progress += delta * pnj.max_speed
	var velocity := get_velocity_from_distance(distance_to_path)
	pnj.body.linear_velocity = velocity

func get_velocity_from_distance(distance: float) -> Vector2:
	if pnj.body.linear_velocity.length() >= pnj.max_speed:
		return Vector2.ZERO
	if distance < pnj.min_square_dist_to_move:
		return Vector2.ZERO
	else:
		var direction := pnj.body.global_position.direction_to(pnj.global_position)
		var speed := pnj.min_speed
		if distance > pnj.min_square_dist_to_move:
			speed = clamp(
				remap(distance, 0, pnj.max_speed_distance, pnj.min_speed, pnj.max_speed),
				pnj.min_speed, pnj.max_speed
			);
		return direction * speed
