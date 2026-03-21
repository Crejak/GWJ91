extends Node
class_name EventBus

signal phase_ended(phase: LevelState.Phase);
signal phase_started(phase: LevelState.Phase);
signal character_caught;
signal infiltration_timed_out;
signal active_character_changed(character: Character);
signal objective_found(character: Character, index: int);
signal objective_list_updated;
signal objective_list_cleared;
signal character_entered;

@onready var detection: Detection = Detection.new() 

func _ready() -> void:
	if OS.is_debug_build():
		phase_ended.connect(func (phase: LevelState.Phase) -> void:
			print("Phase ended : %s" % LevelState.Phase.keys()[phase]);
		);
		phase_started.connect(func (phase: LevelState.Phase) -> void:
			print("Phase started : %s" % LevelState.Phase.keys()[phase]);
		);
		character_caught.connect(func () -> void:
			print("Character caught");
		);
		infiltration_timed_out.connect(func () -> void:
			print("Infiltration timed out");
		);
		active_character_changed.connect(func (character: Character) -> void:
			print("Active character changed : %s" % character);
		);
		objective_found.connect(func (character: Character, index: int) -> void:
			print("Objective found : %s by %s" % [index, character]);
		);
		objective_list_updated.connect(func () -> void:
			print("Objective list updated");
		);
		objective_list_cleared.connect(func () -> void:
			print("Objective list cleared");
		);
		character_entered.connect(func () -> void:
			print("Character entered");
		);
		detection.on_movable_object_noise_start.connect(func(in_position: Vector2, in_object: MovableObject, in_sound_intensity: float) -> void:
			print("Noise Detection start: %s, at %s, intensity: %f" % [in_object.name, str(in_position), in_sound_intensity]))
		detection.on_movable_object_noise_stop.connect(func(in_object: MovableObject) -> void:
			print("Noise Detection stops: %s" % in_object.name))
		detection.on_wall_noise_start.connect(func (in_position: Vector2, in_wall: StaticBody2D, in_sound_intensity: float) -> void:
			print("Wall noise detection start: %s, at %s, intensity: %f" % [in_wall, in_position, in_sound_intensity]))
		detection.on_wall_noise_stop.connect(func (in_wall: StaticBody2D) -> void:
			print("Wall noise detection stops: %s" % in_wall))
		detection.on_player_move.connect(func(_in_position: Vector2, in_sound_intensity: float) -> void:
			print("Player Move Noise Detection: %f" % in_sound_intensity))

class Detection:
	extends RefCounted
	@warning_ignore("unused_signal")
	signal on_movable_object_noise_start(in_position: Vector2, in_object: MovableObject, in_sound_intensity: float)
	@warning_ignore("unused_signal")
	signal on_movable_object_noise_stop(in_object: MovableObject)
	signal on_wall_noise_start(in_position: Vector2, in_wall: StaticBody2D, in_sound_intensity: float)
	signal on_wall_noise_stop(in_wall: StaticBody2D)
	@warning_ignore("unused_signal")
	signal on_player_move(in_position: Vector2, in_sound_intensity: float)


static func clear_signal(in_signal: Signal) -> void:
	for connection: Dictionary in in_signal.get_connections():
		in_signal.disconnect(connection.callable as Callable)
