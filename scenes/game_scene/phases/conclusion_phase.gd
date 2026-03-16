extends Control

@export var title: String = "";
@export_multiline var conclusion_text: String = "";

@onready var title_label: Label = %TitleLabel;
@onready var conclusion_label: RichTextLabel = %ConclusionLabel;

func _ready() -> void:
	SignalBus.phase_started.connect(on_phase_started);
	SignalBus.phase_ended.connect(on_phase_ended);
	visible = false;
	title_label.text = title;
	conclusion_label.text = conclusion_text;

func on_phase_started(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.CONCLUSION:
		visible = true;
	
func on_phase_ended(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.CONCLUSION:
		visible = false;

func _on_next_level_button_pressed() -> void:
	GameState.get_current_level_state().set_phase(LevelState.Phase.COMPLETED);
