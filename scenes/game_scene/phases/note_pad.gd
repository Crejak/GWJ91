class_name NotePad;
extends TextureRect

@export var objective_entry_scene: PackedScene;

@onready var objective_container: Container = %ObjectiveContainer;

func _ready() -> void:
	SignalBus.objective_list_updated.connect(_on_objective_list_updated);

func _on_objective_list_updated() -> void:
	if Level.current == null:
		return;
	for objective: Node in objective_container.get_children():
		objective.queue_free();
	var objective_list := Level.current.objectives;
	var cleared_objectives := GameState.get_current_level_state().objectives;
	for index in range(objective_list.size()):
		var entry: ObjectiveEntry = objective_entry_scene.instantiate();
		objective_container.add_child(entry);
		entry.objective_text = objective_list.get(index).name;
		entry.is_checked = cleared_objectives.get(index) == true;
