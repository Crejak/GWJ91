@tool
class_name ItemBox
extends Control

@export var object: MovableObject:
	set = set_pickable_object;
@export var inventory_index: int;
@export var selected: bool = false:
	set = set_selected;
	
@export_group("Visuals")
@export var normal_color: Color = Color("7b7b7b");
@export var selected_color: Color = Color("ababab");

@onready var texture: TextureRect = %TextureRect;
@onready var selected_frame: Panel = %SelectedFrame;

func set_pickable_object(pickable_object: MovableObject) -> void:
	object = pickable_object;
	if object == null:
		texture.texture = null;
	else:
		texture.texture = object.item_texture;

func set_selected(is_selected: bool) -> void:
	selected = is_selected;
	print("Box %s / selected : %s", inventory_index, selected);
	selected_frame.visible = selected;
