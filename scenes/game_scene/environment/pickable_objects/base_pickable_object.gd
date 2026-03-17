class_name PickableObject
extends Node2D

@export var monetary_value: int = 0;
@export var mass: float = 0; 
@export var item_texture: Texture2D;

func _on_interactable_player_interacted(source: Character) -> void:
	if source.pick_up(self):
		get_parent().remove_child(self);
