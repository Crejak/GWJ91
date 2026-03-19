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
	timer_label.text = ">> %.2f" % (timer.wait_time - timer.time_left);

func on_phase_started(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.PREPARATION:
		visible = true;
		timer.start(preparation_time);

func on_phase_ended(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.PREPARATION:
		visible = false;

func _on_timer_timeout() -> void:
	GameState.get_current_level_state().set_phase(LevelState.Phase.INFILTRATION);
