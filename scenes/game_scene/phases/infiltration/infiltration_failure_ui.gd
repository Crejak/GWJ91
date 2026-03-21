extends Control

@onready var busted_effect: BustedEffect = %BustedEffect;

func _ready() -> void:
	SignalBus.character_caught.connect(_on_character_caught);
	visible = false;

func _on_character_caught() -> void:
	visible = true;
	busted_effect.start_effect();
	await get_tree().create_timer(2.5).timeout;
	GameState.get_current_level_state().set_phase(LevelState.Phase.CONCLUSION);
