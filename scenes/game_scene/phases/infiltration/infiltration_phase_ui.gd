extends Control

@export var objective_found_effect_scene: PackedScene;
@export var floating_text_effect: PackedScene;
@export var infiltration_phase_time: float = 120;

@onready var danger_bar: ProgressBar = %DangerBar;
@onready var infiltration_timer: Timer = %InfiltrationTimer;
@onready var timer_label: Label = %TimerLabel;

func _ready() -> void:
	SignalBus.phase_started.connect(_on_phase_started);
	SignalBus.phase_ended.connect(_on_phase_ended);
	SignalBus.objective_found.connect(_on_objective_found);
	SignalBus.objective_list_cleared.connect(_on_objective_list_cleared);
	SignalBus.character_entered.connect(_on_character_entered);
	visible = false;

func _process(_delta: float) -> void:
	if !visible:
		return;
	danger_bar.value = GameState.get_current_level_state().danger_level;
	if !infiltration_timer.is_stopped():
		timer_label.text = ("%.2f" % infiltration_timer.time_left).replace(".", ":");

func _on_phase_started(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.INFILTRATION:
		visible = true;
		
func _on_phase_ended(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.INFILTRATION:
		visible = false;

func _on_character_entered() -> void:
	infiltration_timer.start(infiltration_phase_time);

func _on_objective_found(character: Character, index: int) -> void:
	var effect: ObjectiveFoundEffect = objective_found_effect_scene.instantiate();
	add_child(effect);
	effect.global_position = character.get_global_transform_with_canvas().origin;
	effect.text = Level.current.objectives[index].name;
	effect.start_effect();

func _on_objective_list_cleared() -> void:
	var effect: FloatingTextEffect = floating_text_effect.instantiate();
	add_child(effect);
	effect.global_position = Character.current.get_global_transform_with_canvas().origin;
	effect.text = "All objectives found !"
	effect.visible = false;
	await get_tree().create_timer(1.5).timeout;
	effect.visible = true;
	effect.start_effect();

func _on_infiltration_timer_timeout() -> void:
	SignalBus.infiltration_timed_out.emit();
