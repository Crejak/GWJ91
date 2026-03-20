extends Control

func _ready() -> void:
	SignalBus.character_caught.connect(_on_character_caught);
	visible = false;

func _on_character_caught() -> void:
	visible = true;
	await get_tree().create_timer(3).timeout;
	GameState.get_current_level_state().set_phase(LevelState.Phase.CONCLUSION);
