extends Control

@onready var level: Level = $"../.."
@onready var character: Character = level.starting_character

func _ready() -> void:
	SignalBus.phase_started.connect(_on_phase_started);
	visible = false;
	
func _on_phase_started(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.INFILTRATION:
		visible = true;

func _on_texture_button_pressed() -> void:
	character.can_move = true;
	character.visible = true;
	SignalBus.character_entered.emit();
	queue_free();
