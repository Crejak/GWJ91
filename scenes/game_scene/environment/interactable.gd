@tool
class_name Interactable

extends Node

signal player_interacted;

var parent_area_2d: Area2D;

func _ready() -> void:
	var parent := get_parent();
	if parent is Area2D:
		parent_area_2d = parent;
	else:
		push_error("Interactable must be a child of Area2D");

func _get_configuration_warnings() -> PackedStringArray:
	if get_parent() == null || !(get_parent() is Area2D):
		return ["Interactable must be a child of Area2D"];
	return [];
	
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return;
	var overlapping_bodies := parent_area_2d.get_overlapping_bodies();
	if overlapping_bodies.is_empty():
		return;
	if Input.is_action_just_pressed("interact"):
		player_interacted.emit();
