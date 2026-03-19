extends Control

@onready var danger_bar: ProgressBar = %DangerBar;
@onready var objective_list_label: Label = %ObjectiveListLabel;

func _ready() -> void:
	SignalBus.phase_started.connect(_on_phase_started);
	SignalBus.phase_ended.connect(_on_phase_ended);
	SignalBus.objective_list_updated.connect(_update_objective_list_label);
	visible = false;

func _process(_delta: float) -> void:
	if !visible:
		return;
	danger_bar.value = GameState.get_current_level_state().danger_level;

func _on_phase_started(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.INFILTRATION:
		visible = true;
		_update_objective_list_label();

func _on_phase_ended(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.INFILTRATION:
		visible = false;

func _update_objective_list_label() -> void:
	if Level.current == null:
		return;
	var objective_list: Array[Objective] = Level.current.objectives;
	var level_state: LevelState = GameState.get_current_level_state();
	var text: String = "Objectives :\n";
	for index in range(objective_list.size()):
		var done: bool = level_state.objectives.get(index) == true;
		text += "[x]" if done else "[ ]";
		text += " %s\n" % objective_list[index].name;
	objective_list_label.text = text;
