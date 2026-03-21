extends Control

@onready var busted_effect: BustedEffect = %BustedEffect;
@onready var time_out_effect: BustedEffect = %TimeOutEffect;

func _ready() -> void:
	SignalBus.character_caught.connect(_on_character_caught);
	SignalBus.infiltration_timed_out.connect(_on_infiltration_timed_out);
	visible = false;

func _on_character_caught() -> void:
	visible = true;
	busted_effect.start_effect();
	await get_tree().create_timer(2.5).timeout;
	GameState.get_current_level_state().set_phase(LevelState.Phase.CONCLUSION);

func _on_infiltration_timed_out() -> void:
	visible = true;
	time_out_effect.start_effect();
	await get_tree().create_timer(2.5).timeout;
	GameState.get_current_level_state().set_phase(LevelState.Phase.CONCLUSION);
