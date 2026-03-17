class_name ItemBox
extends Control

@export var object: PickableObject:
	set = set_pickable_object;
@export var inventory_index: int;

@onready var texture: TextureRect = %TextureRect;

func set_pickable_object(pickable_object: PickableObject) -> void:
	object = pickable_object;
	if object == null:
		texture.texture = null;
	else:
		texture.texture = object.item_texture;
