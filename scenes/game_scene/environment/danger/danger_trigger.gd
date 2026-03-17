@tool
class_name DangerTrigger

extends Node

## Danger progress per second (danger ranges from 0.0 to 1.0).
@export var danger_progress_rate: float = .5;

var parent_area_2d: Area2D;
var character_in_range: Character;

func _ready() -> void:
	var parent := get_parent();
	if parent is Area2D:
		parent_area_2d = parent;
	else:
		push_error("DangerTrigger must be a child of Area2D");
	parent_area_2d.body_entered.connect(on_body_entered);
	parent_area_2d.body_exited.connect(on_body_exited);

func _get_configuration_warnings() -> PackedStringArray:
	if get_parent() == null || !(get_parent() is Area2D):
		return ["DangerTrigger must be a child of Area2D"];
	return [];
	
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return;
	if character_in_range:
		GameState.get_current_level_state().danger_level += danger_progress_rate * delta;

func on_body_entered(body: Node2D) -> void:
	character_in_range = body as Character;

func on_body_exited(_body: Node2D) -> void:
	character_in_range = null;
