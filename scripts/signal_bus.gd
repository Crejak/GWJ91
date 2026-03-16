extends Node

@warning_ignore("unused_signal")
signal phase_ended(phase: LevelState.Phase);
@warning_ignore("unused_signal")
signal phase_started(phase: LevelState.Phase);

func _ready() -> void:
	if OS.is_debug_build():
		phase_ended.connect(func (phase: LevelState.Phase) -> void:
			print("Phase ended : %s" % phase);
		);
		phase_started.connect(func (phase: LevelState.Phase) -> void:
			print("Phase started : %s" % phase);
		);
