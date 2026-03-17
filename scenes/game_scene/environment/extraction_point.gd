extends Node2D

func _on_interactable_player_interacted(character: Character) -> void:
	var level_state := GameState.get_current_level_state();
	level_state.total_stolen_value = character.get_total_picked_up_value();
	level_state.set_phase(LevelState.Phase.CONCLUSION);
