class_name PickableObject
extends Node2D

@export var monetary_value: int = 0;
@export var mass: float = 0; 

func _on_interactable_player_interacted(source: Character) -> void:
	get_parent().remove_child(self);
	source.pick_up(self);
