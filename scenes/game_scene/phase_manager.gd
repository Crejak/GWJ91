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
	print("Level ready");
	preparation_phase_timer.start();

func _on_preparation_phase_timer_timeout() -> void:
	print("Preparation phase finished");
	current_phase = Phase.INFILTRATION;
	draw_controller.enable_draw = false;
	
