extends Control

@export var title: String = "";
@export_multiline var introduction_text: String = "";

@onready var title_label: Label = %TitleLabel;
@onready var intro_label: RichTextLabel = %IntroLabel;
@onready var timer_label: Label = %TimerLabel;

func _ready() -> void:
	SignalBus.phase_started.connect(on_phase_started);
	SignalBus.phase_ended.connect(on_phase_ended);
	visible = false;
	title_label.text = title;
	intro_label.text = introduction_text;

func on_phase_started(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.INTRODUCTION:
		visible = true;
	
func on_phase_ended(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.INTRODUCTION:
		visible = false;

func _on_vcr_controls_play_button_pressed() -> void:
	GameState.get_current_level_state().set_phase(LevelState.Phase.PREPARATION);
