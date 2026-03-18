extends Node
class_name EventBus

@warning_ignore("unused_signal")
signal phase_ended(phase: LevelState.Phase);
@warning_ignore("unused_signal")
signal phase_started(phase: LevelState.Phase);
@warning_ignore("unused_signal")
signal character_caught;
@warning_ignore("unused_signal")
signal active_character_changed(character: Character);

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
		active_character_changed.connect(func (character: Character) -> void:
			print("Active character changed : %s" % character);
		);
		detection.on_movable_object_noise_start.connect(func(in_position: Vector2, in_object: MovableObject, in_sound_intensity: float) -> void:
			print("Noise Detection start: %s, at %s, intensity: %f" % [in_object.name, str(in_position), in_sound_intensity]))
		detection.on_movable_object_noise_stop.connect(func(in_object: MovableObject) -> void:
			print("Noise Detection stops: %s" % in_object.name))


class Detection:
	extends RefCounted
	@warning_ignore("unused_signal")
	signal on_movable_object_noise_start(in_position: Vector2, in_object: MovableObject, in_sound_intensity: float)
	@warning_ignore("unused_signal")
	signal on_movable_object_noise_stop(in_object: MovableObject)


static func clear_signal(in_signal: Signal) -> void:
	for connection: Dictionary in in_signal.get_connections():
		in_signal.disconnect(connection.callable as Callable)
