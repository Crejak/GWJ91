extends Control

@export var pages: Array[NotepadPageContent]:
	set(value):
		pages = value;
		(%NotePad as NotePad).pages = pages;

@onready var notepad: NotePad = %NotePad;
@onready var preparation_position: Control = %PreparationPosition;
@onready var zoomed_position: Control = %ZoomedPosition;

var preparation_phase: bool = false;
var t: Tween;

func _ready() -> void:
	SignalBus.phase_started.connect(_on_phase_started);
	SignalBus.phase_ended.connect(_on_phase_ended);

func _on_phase_started(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.INTRODUCTION:
		visible = true;
		notepad.set_anchors_preset(Control.PRESET_CENTER, true);
	if phase == LevelState.Phase.PREPARATION:
		preparation_phase = true;

func _on_phase_ended(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.PREPARATION:
		visible = false;
	if phase == LevelState.Phase.INTRODUCTION:
		_tween_to_position(preparation_position);

func _on_zoom_button_mouse_entered() -> void:
	print("mouse entered !!");
	if !preparation_phase:
		return;
	_tween_to_position(zoomed_position);

func _on_zoom_button_mouse_exited() -> void:
	print("mouse exited !!");
	if !preparation_phase:
		return;
	_tween_to_position(preparation_position);

func _tween_to_position(ref: Control) -> void:
	if t:
		t.stop();
	t = create_tween();
	t.set_parallel();
	t.tween_property(notepad, "position", ref.position, .2);
	t.tween_property(notepad, "scale", ref.scale, .2);
