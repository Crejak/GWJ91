extends Node2D

## Node where level props are. This is node is used as the parent for items dropped by
## the player.
@export var prop_container_node: Node2D;

func _ready() -> void:
	SignalBus.phase_started.connect(on_phase_started);
	SignalBus.phase_ended.connect(on_phase_ended);
	visible = false;
	
func on_phase_started(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.PREPARATION:
		visible = true;

func on_phase_ended(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.INFILTRATION:
		visible = false;

func _on_character_object_dropped(source: Character, object: MovableObject) -> void:
	prop_container_node.add_child(object);
	object.global_position = source.global_position;
