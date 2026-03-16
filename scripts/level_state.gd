class_name LevelState
extends Resource

## The phase the level is currently in
enum Phase {
	## The level is not loaded yet
	UNLOADED,
	## Plays intro cutscene
	INTRODUCTION,
	## The player can see the blueprint and draw on it
	PREPARATION,
	## The player executes the infiltration
	INFILTRATION,
	## Plays conclusion cutscene
	CONCLUSION
}

@export var color : Color
@export var tutorial_read : bool = false
@export var current_phase: Phase = Phase.UNLOADED:
	set = set_phase;

func set_phase(new_phase: Phase) -> void:
		if new_phase == current_phase:
			push_warning("Tried to set a phase that already exists");
			return;
		SignalBus.phase_ended.emit(current_phase);
		current_phase = new_phase;
		SignalBus.phase_started.emit(new_phase);
