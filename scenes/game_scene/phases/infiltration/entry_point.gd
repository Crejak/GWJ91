extends Control

@export var character: Character;

func _ready() -> void:
	SignalBus.phase_started.connect(_on_phase_started);
	visible = false;
	
func _on_phase_started(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.INFILTRATION:
		visible = true;

func _on_texture_button_pressed() -> void:
	character.can_move = true;
	character.visible = true;
	queue_free();
