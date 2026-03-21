extends Control

@export var pages: Array[NotepadPageContent]:
	set(value):
		pages = value;
		(%NotePad as NotePad).pages = pages;

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
		var t := create_tween();
		t.set_parallel();
		t.tween_property(notepad, "position", preparation_position.position, .5);
		t.tween_property(notepad, "scale", preparation_position.scale, .5);
