class_name PhaseManager

extends Node

enum Phase {
	PREPARATION,
	INFILTRATION
}

@export var preparation_phase_timer: Timer;
@export var preparation_phase_timer_label: Label;
@export var draw_controller: DrawController;

var current_phase: Phase = Phase.PREPARATION;

func _process(_delta: float) -> void:
	preparation_phase_timer_label.text = "Time left : %s" % preparation_phase_timer.time_left;

func _on_level_loader_level_ready() -> void:
	preparation_phase_timer.start();
	SignalBus.preparation_phase_started.emit();

func _on_preparation_phase_timer_timeout() -> void:
	draw_controller.enable_draw = false;
	SignalBus.preparation_phase_ended.emit();
	current_phase = Phase.INFILTRATION;
	SignalBus.infiltration_phase_started.emit();
