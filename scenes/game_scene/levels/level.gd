## All level root nodes must use this script
class_name Level
extends Node

signal level_lost
signal level_won(level_path : String)
@warning_ignore("unused_signal")
signal level_changed(level_path : String)

## Optional path to the next level if using an open world level system.
@export_file("*.tscn") var next_level_path : String
@export var level_id :int = 0
@export var starting_character: Character;

var level_state : LevelState

func _on_lose_button_pressed() -> void:
	level_lost.emit()

func _on_win_button_pressed() -> void:
	level_won.emit(next_level_path)

func _ready() -> void:
	if starting_character == null:
		push_error("A level must have a starting character");
	level_state = GameState.get_level_state(scene_file_path);
	level_state.reset();
	level_state.active_character = starting_character;
	level_state.set_phase(LevelState.Phase.INTRODUCTION);
	SignalBus.phase_started.connect(on_phase_started);

func on_phase_started(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.COMPLETED:
		GlobalState.current.story_progression.set_story_progression(level_id)
		level_won.emit();
