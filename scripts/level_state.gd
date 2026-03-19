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
	CONCLUSION,
	## The player has cleared this level
	COMPLETED
}

var current_phase: Phase = Phase.UNLOADED:
	set = set_phase;
var total_stolen_value: int = 0;
var danger_level: float = 0.:
	set(value):
		if value >= 1. && danger_level < 1.:
			SignalBus.character_caught.emit();
		danger_level = clamp(value, 0., 1.);
var objectives: Dictionary[int, bool] = {}:
	set(value):
		objectives = value;
		SignalBus.objective_list_updated.emit();

var active_character: Character:
	set(value):
		active_character = value;
		SignalBus.active_character_changed.emit(active_character);

func reset() -> void:
	set_phase(Phase.UNLOADED);
	total_stolen_value = 0;
	danger_level = 0.;
	active_character = null;
	objectives = {};

func set_phase(new_phase: Phase) -> void:
		if new_phase == current_phase:
			push_warning("Tried to set a phase that already exists");
			return;
		SignalBus.phase_ended.emit(current_phase);
		current_phase = new_phase;
		SignalBus.phase_started.emit(new_phase);
		
func mark_objective_as_done(index: int) -> void:
	objectives[index] = true;
	SignalBus.objective_list_updated.emit();
