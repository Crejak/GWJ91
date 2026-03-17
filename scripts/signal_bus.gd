extends Node

@warning_ignore("unused_signal")
signal phase_ended(phase: LevelState.Phase);
@warning_ignore("unused_signal")
signal phase_started(phase: LevelState.Phase);
@warning_ignore("unused_signal")
signal character_caught;
@warning_ignore("unused_signal")
signal active_character_changed(character: Character);

func _ready() -> void:
	if OS.is_debug_build():
		phase_ended.connect(func (phase: LevelState.Phase) -> void:
			print("Phase ended : %s" % phase);
		);
		phase_started.connect(func (phase: LevelState.Phase) -> void:
			print("Phase started : %s" % phase);
		);
		character_caught.connect(func () -> void:
			print("Character caught");
		);
		active_character_changed.connect(func (character: Character) -> void:
			print("Active character changed : %s" % character);
		);
