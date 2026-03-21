class_name Character
extends RigidBody2D

signal inventory_changed;
signal object_dropped(source: Character, object: MovableObject);

@export_group("Movement")

@export var can_move: bool = false:
	set(value):
		can_move = value;
		if can_move:
			current = self;

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
## Factor applied to the mass of picked up objects.
@export var speed_damp: float = 0.15;
@export var speed_floor_ratio: float = 0.333;

@export_group("Movement/Detection")
@export var max_silent_speed: float = 200
@export var base_noise_value: float = 5
## Intensity of wall hit sound. For example, a wall mass of 10 kg means that walking
## into a wall makes the same noise intensity of walking into a movable object of 10 kg.
@export var wall_mass: float = 1;

@onready var hit_light_zone: HitLightZone = %HitLightZone;

var speed_loss_factor: float = 1.;

var last_position: Vector2 = Vector2.ZERO;
var last_frame_velocity: float = 0.;

@export_group("Debug")
@export var debug_label: Label;

var picked_up_objects: Array[MovableObject] = [];
var total_speed_loss: float = 0.;

## Dirty but gets the work done. The instance is set when "can_move" is set to true.
static var current: Character;

func _ready() -> void:
	SignalBus.phase_started.connect(_on_phase_started);
	SignalBus.phase_ended.connect(_on_phase_ended);
	SignalBus.character_caught.connect(_on_character_caught);
	SignalBus.infiltration_timed_out.connect(_on_infiltration_timed_out);
	if get_tree().current_scene != self:
		visible = false;

func _process(delta: float) -> void:
	if linear_velocity.length() > max_silent_speed:
		SignalBus.detection.on_player_move.emit(global_position, (base_noise_value + get_total_picked_up_mass()) * linear_velocity.length_squared() * delta)

	if OS.is_debug_build():
		debug_label.text = "Speed : %.1f px/s\nMass : %.1f kg\nValue : %s $" % \
			[last_frame_velocity, get_total_picked_up_mass(), get_total_picked_up_value()];

func _physics_process(delta: float) -> void:
	if OS.is_debug_build():
		last_frame_velocity = last_position.distance_to(position) / delta;
		last_position = position;

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if !can_move:
		state.linear_velocity = Vector2.ZERO;
		return;
	var distance := get_mouse_distance_in_viewport_space();
	var velocity := get_velocity_from_distance_to_cursor(distance);
	state.linear_velocity = velocity;
	
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
		return direction * speed * speed_loss_factor;

func _on_phase_started(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.INFILTRATION:
		can_sleep = false;

func _on_phase_ended(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.INFILTRATION:
		can_move = false;
		can_sleep = true;
		visible = false;

func _on_character_caught() -> void:
	_stop_movement();

func _on_infiltration_timed_out() -> void:
	_stop_movement();

func _stop_movement() -> void:
	can_move = false;
	can_sleep = true;

func pick_up(object: MovableObject) -> void:
	picked_up_objects.push_back(object);
	inventory_changed.emit();

func get_total_picked_up_mass() -> float:
	var total_mass: float = 0.;
	for object: MovableObject in picked_up_objects:
		total_mass += object.mass;
	return total_mass;

func get_total_picked_up_value() -> int:
	var total_value: int = 0;
	for object: MovableObject in picked_up_objects:
		total_value += object.monetary_value;
	return total_value;
	
func drop_object(index: int) -> void:
	if index < 0 || index >= picked_up_objects.size():
		return;
	var object: MovableObject = picked_up_objects.get(index);
	object_dropped.emit(self, object);
	picked_up_objects.remove_at(index);
	inventory_changed.emit();

func _on_inventory_changed() -> void:
	speed_loss_factor = speed_floor_ratio + \
		(1 - speed_floor_ratio) / (1 + speed_damp * get_total_picked_up_mass());

func _on_body_entered(body: Node) -> void:
	hit_light_zone.light_up();
	if body is PhysicsBody2D:
		if (body as PhysicsBody2D).get_collision_layer_value(3):
			var wall := body as StaticBody2D;
			SignalBus.detection.on_wall_noise_start.emit(global_position, wall, wall_mass * linear_velocity.length_squared());


func _on_body_exited(body: Node) -> void:
	if body is PhysicsBody2D:
		if (body as PhysicsBody2D).get_collision_layer_value(3):
			var wall := body as StaticBody2D;
			SignalBus.detection.on_wall_noise_stop.emit(wall);
