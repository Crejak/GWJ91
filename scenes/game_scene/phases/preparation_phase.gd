extends Control

## Preparation time in seconds
@export var preparation_time: float = 8.;

@export_group("Internal nodes")

@onready var timer: Timer = %Timer;
@onready var timer_label: Label = %TimerLabel;

func _ready() -> void:
	SignalBus.phase_started.connect(on_phase_started);
	SignalBus.phase_ended.connect(on_phase_ended);
	visible = false;
	
func _process(_delta: float) -> void:
	if !visible:
		return;
	timer_label.text = ">> %s / %s" % [_format_time(timer.wait_time - timer.time_left), _format_time(timer.wait_time)];

func _format_time(time: float) -> String:
	return ("%.2f" % time).replace(".", ":");

func on_phase_started(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.PREPARATION:
		visible = true;
		timer.start(preparation_time);

func on_phase_ended(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.PREPARATION:
		visible = false;

func _on_timer_timeout() -> void:
	GameState.get_current_level_state().set_phase(LevelState.Phase.INFILTRATION);

func _on_vcr_controls_skip_button_pressed() -> void:
	timer.stop();
	GameState.get_current_level_state().set_phase.call_deferred(LevelState.Phase.INFILTRATION);
