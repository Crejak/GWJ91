extends Timer

func _ready() -> void:
	SignalBus.phase_started.connect(on_phase_started);
	
func on_phase_started(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.PREPARATION:
		start();

func _on_timeout() -> void:
	GameState.get_current_level_state().current_phase = LevelState.Phase.INFILTRATION;
