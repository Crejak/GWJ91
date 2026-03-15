@tool
class_name Interactable

extends Node

signal player_interacted;

var parent_area_2d: Area2D;
var is_player_in_range: bool;

func _ready() -> void:
	var parent := get_parent();
	if parent is Area2D:
		parent_area_2d = parent;
	else:
		push_error("Interactable must be a child of Area2D");
	parent_area_2d.body_entered.connect(on_body_entered);
	parent_area_2d.body_exited.connect(on_body_exited);

func _get_configuration_warnings() -> PackedStringArray:
	if get_parent() == null || !(get_parent() is Area2D):
		return ["Interactable must be a child of Area2D"];
	return [];
	
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return;
	if is_player_in_range && Input.is_action_just_pressed("interact"):
		player_interacted.emit();

func on_body_entered(_body: Node2D) -> void:
	is_player_in_range = true;

func on_body_exited(_body: Node2D) -> void:
	is_player_in_range = false;
