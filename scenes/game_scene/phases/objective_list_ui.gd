extends Control

@onready var notepad: NotePad = %NotePad;
@onready var preparation_position: Control = %PreparationPosition;

func _ready() -> void:
	SignalBus.phase_started.connect(_on_phase_started);
	SignalBus.phase_ended.connect(_on_phase_ended);

func _on_phase_started(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.INTRODUCTION:
		visible = true;
	notepad.set_anchors_preset(Control.PRESET_CENTER, true);

func _on_phase_ended(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.PREPARATION:
		visible = false;
	if phase == LevelState.Phase.INTRODUCTION:
		notepad.position = preparation_position.position;
		notepad.scale = preparation_position.scale;
