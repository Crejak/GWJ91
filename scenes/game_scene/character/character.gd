class_name Character
extends RigidBody2D

signal inventory_changed;

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

@export_subgroup("Physics")
## Mass of the character when not carrying anything.
@export var default_mass: float = 1.;
## Factor applied to the mass of picked up objects.
@export var object_mass_factor: float = 0.05;

@export_group("Debug")
@export var debug_label: Label;

var picked_up_objects: Array[PickableObject] = [];

const INVENTORY_SIZE: int = 4;

func _ready() -> void:
	SignalBus.phase_started.connect(_on_phase_started);
	SignalBus.phase_ended.connect(_on_phase_ended);
	SignalBus.character_caught.connect(_on_character_caught);

func _process(_delta: float) -> void:
	if OS.is_debug_build():
		debug_label.text = "Speed : %.1f px/s\nMass : %.1f kg\nValue : %s $" % \
			[linear_velocity.length(), get_total_picked_up_mass(), get_total_picked_up_value()];

func _physics_process(_delta: float) -> void:
	if !can_move:
		return;
	var distance := get_mouse_distance_in_viewport_space();
	var velocity := get_velocity_from_distance_to_cursor(distance);
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

func _on_character_caught() -> void:
	can_move = false;

func pick_up(object: PickableObject) -> bool:
	if picked_up_objects.size() >= INVENTORY_SIZE:
		print("Cannot pick up item, inventory is full");
		return false;
	print("Picked up %s that weighs %.1f kilos, and is worth %d dollars !" % [object, object.mass, object.monetary_value]);
	picked_up_objects.push_back(object);
	mass = default_mass + get_total_picked_up_mass() * object_mass_factor;
	inventory_changed.emit();
	return true;

func get_total_picked_up_mass() -> float:
	var total_mass: float = 0.;
	for object: PickableObject in picked_up_objects:
		total_mass += object.mass;
	return total_mass;

func get_total_picked_up_value() -> int:
	var total_value: int = 0;
	for object: PickableObject in picked_up_objects:
		total_value += object.monetary_value;
	return total_value;
