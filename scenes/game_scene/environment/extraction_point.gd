extends Node2D

@export var floating_text_effect_scene: PackedScene;

@onready var visuals: Node2D = %Visuals;

func _ready() -> void:
	SignalBus.phase_started.connect(_on_phase_started);
	SignalBus.phase_ended.connect(_on_phase_ended);
	SignalBus.character_entered.connect(_on_character_entered);
	visuals.visible = false;

func _on_phase_started(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.PREPARATION:
		visuals.visible = true;

func _on_phase_ended(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.PREPARATION:
		visuals.visible = false;

func _on_character_entered() -> void:
	visuals.visible = true;

func _on_area_2d_body_entered(body: Node2D) -> void:
	if GameState.get_current_level_state().current_phase != LevelState.Phase.INFILTRATION:
		return;
	if !(body is Character):
		return;
	var character := body as Character;
	if !GameState.get_current_level_state().objectives_cleared:
		_show_missing_objective_effect();
		return;
	var level_state := GameState.get_current_level_state();
	level_state.total_stolen_value = character.get_total_picked_up_value();
	level_state.level_won = true;
	level_state.set_phase(LevelState.Phase.CONCLUSION);
	
func _show_missing_objective_effect() -> void:
	var effect: FloatingTextEffect = floating_text_effect_scene.instantiate();
	add_child(effect);
	effect.global_position = global_position;
	effect.text = "Some objectives are still missing";
	effect.start_effect();
