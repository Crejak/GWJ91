class_name PhaseManager

extends Node

@export var preparation_phase_timer: Timer;
@export var preparation_phase_timer_label: Label;
@export var draw_controller: DrawController;

func _process(_delta: float) -> void:
	preparation_phase_timer_label.text = "Time left : %s" % preparation_phase_timer.time_left;

func _on_level_loader_level_ready() -> void:
	preparation_phase_timer.start();
	GameState.get_current_level_state().current_phase = LevelState.Phase.PREPARATION;

func _on_preparation_phase_timer_timeout() -> void:
	GameState.get_current_level_state().current_phase = LevelState.Phase.INFILTRATION;
