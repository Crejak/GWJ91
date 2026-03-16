class_name Character

extends RigidBody2D

@export_group("Movement")

@export var can_move: bool = false;

## Minimum walking speed, in pixel per second
@export var min_speed: float = 25.;
## Maximum running speed, in pexel per second if linear dump = 0
@export var max_speed: float = 100.;
## Minimum distance between the mouse and the character that triggers movement, in pixels
@export var min_mouse_detection_range: float = 10.;
## Maximum distance between the mouse and the character that makes the player moves at minimum speed.
## If the mouse is at a greater distance than this value, the speed of the player scales with the mouse distance.
@export var min_speed_mouse_range: float = 50.;
## Distance between the mouse and the character that makes the character move at their
## maximum speed.
@export var max_speed_mouse_range: float = 200.;

@export_group("Debug")
@export var debug_label: Label;

var picked_up_value: int = 0;
var picked_up_mass: float = 0.;

func _ready() -> void:
	SignalBus.phase_started.connect(_on_phase_started);
	SignalBus.phase_ended.connect(_on_phase_ended);

func _process(_delta: float) -> void:
	if OS.is_debug_build():
		debug_label.text = "Speed : %s" % roundi(linear_velocity.length())

func _physics_process(_delta: float) -> void:
	if !can_move:
		return;
	var distance := get_mouse_distance_in_viewport_space();
	var velocity = get_velocity_from_distance_to_cursor(distance);
	apply_force(velocity);
	
func get_mouse_distance_in_viewport_space() -> float:
	var viewport_mouse_position := get_viewport().get_mouse_position();
	var viewport_player_position := get_global_transform_with_canvas().get_origin();
	# TODO optimize with squared values
	return viewport_mouse_position.distance_to(viewport_player_position);

func get_velocity_from_distance_to_cursor(distance: float) -> Vector2:
	if linear_velocity.length() >= max_speed:
		return Vector2.ZERO
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

func _on_phase_started(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.INFILTRATION:
		can_move = true;

func _on_phase_ended(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.INFILTRATION:
		can_move = false;

func pick_up(mass: float, value: int) -> void:
	print("Picked up an object that weighs %.1f kilos, and is worth %d dollars !" % [mass, value]);
	picked_up_mass += mass;
	picked_up_value += value;
