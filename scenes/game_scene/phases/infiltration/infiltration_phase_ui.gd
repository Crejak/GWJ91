extends Control

@export var objective_found_effect_scene: PackedScene;
@export var all_objectives_found_effect_scene: PackedScene;

@onready var danger_bar: ProgressBar = %DangerBar;

func _ready() -> void:
	SignalBus.phase_started.connect(_on_phase_started);
	SignalBus.phase_ended.connect(_on_phase_ended);
	SignalBus.objective_found.connect(_on_objective_found);
	SignalBus.objective_list_cleared.connect(_on_objective_list_cleared);
	visible = false;

func _process(_delta: float) -> void:
	if !visible:
		return;
	danger_bar.value = GameState.get_current_level_state().danger_level;

func _on_phase_started(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.INFILTRATION:
		visible = true;

func _on_phase_ended(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.INFILTRATION:
		visible = false;

func _on_objective_found(character: Character, index: int) -> void:
	var effect: ObjectiveFoundEffect = objective_found_effect_scene.instantiate();
	add_child(effect);
	effect.global_position = character.global_position;
	effect.text = Level.current.objectives[index].name;
	effect.start_effect();

func _on_objective_list_cleared() -> void:
	var effect: AllObjectivesFoundEffect = all_objectives_found_effect_scene.instantiate();
	add_child(effect);
	effect.global_position = Character.current.global_position;
	effect.visible = false;
	await get_tree().create_timer(1.5).timeout;
	effect.visible = true;
	effect.start_effect();
