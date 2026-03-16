extends Node2D

func _on_interactable_player_interacted(_character: Character) -> void:
	GameState.get_current_level_state().set_phase(LevelState.Phase.CONCLUSION);
