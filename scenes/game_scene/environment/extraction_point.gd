extends Node2D

@onready var visible_layer: CanvasGroup = %VisibleLayer

func _ready() -> void:
	SignalBus.objective_list_cleared.connect(on_objective_list_cleared)

func _on_interactable_player_interacted(character: Character) -> void:
	if !GameState.get_current_level_state().objectives_cleared:
		return;
	var level_state := GameState.get_current_level_state();
	level_state.total_stolen_value = character.get_total_picked_up_value();
	level_state.set_phase(LevelState.Phase.CONCLUSION);

func on_objective_list_cleared() -> void :
	visible_layer.visible = true
