extends PNJ_State
class_name PNJ_State_Move

@export var wait_square_distance: float = 700

func _enter_state() -> void:
	pnj.sprite.texture = pnj.walk_texture
	pnj.body.position = Vector2.ZERO
	pnj.body.sleeping = false
	pnj.body.top_level = true
	pnj.body.global_position = pnj.global_position
	pnj.animation_player.play("move")

func _exit_state() -> void:
	pnj.body.global_position = pnj.global_position
	pnj.body.top_level = false
	pnj.body.position = Vector2.ZERO
	pnj.animation_player.stop()

func _physics_process(delta: float) -> void:
	pnj.sprite.flip_h = pnj.body.linear_velocity.x < 0
	var is_arrived_at_destination: bool = false
	var distance_to_path: float = pnj.body.global_position.distance_squared_to(pnj.global_position)
	if distance_to_path < wait_square_distance:
		var destination: float = pnj.timeline[pnj.timeline_index].path_progress_destination
		if abs(pnj.progress - destination) > 100:
			if pnj.progress < destination:
				pnj.progress += delta * pnj.path_following_speed
			else:
				pnj.progress -= delta * pnj.path_following_speed
		else:
			is_arrived_at_destination = true
	var velocity := get_velocity_from_distance(distance_to_path)
	if is_arrived_at_destination and distance_to_path < 100:
		_on_step_done()
		return
	if pnj.body.get_colliding_bodies().is_empty():
		pnj.body.linear_velocity = velocity
		return
	pnj.body.apply_central_force(velocity * pnj.body.mass)

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
