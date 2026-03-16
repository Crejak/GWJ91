extends Control

## Preparation time in seconds
@export var preparation_time: float = 8.;

@export_group("Internal nodes")

@export var timer: Timer;
@export var timer_label: Label;

func _ready() -> void:
	SignalBus.phase_started.connect(on_phase_started);
	SignalBus.phase_ended.connect(on_phase_ended);
	visible = false;
	
func _process(_delta: float) -> void:
	if !visible:
		return;
	timer_label.text = "Preparation time remaining : %.2f" % timer.time_left;

func on_phase_started(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.PREPARATION:
		visible = true;
		timer.start(preparation_time);

func on_phase_ended(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.PREPARATION:
		visible = false;

func _on_timer_timeout() -> void:
	GameState.get_current_level_state().set_phase(LevelState.Phase.INFILTRATION);
