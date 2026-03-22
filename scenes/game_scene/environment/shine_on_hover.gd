@tool
extends PointLight2D

var parent_area_2d: Area2D;

func _ready() -> void:
	var parent := get_parent();
	if parent is Area2D:
		parent_area_2d = parent;
	else:
		push_error("ShineOnHover must be a child of Area2D");
	parent_area_2d.mouse_entered.connect(on_mouse_entered);
	parent_area_2d.mouse_shape_exited.connect(on_mouse_exited);

func _get_configuration_warnings() -> PackedStringArray:
	if get_parent() == null || !(get_parent() is Area2D):
		return ["ShineOnHover must be a child of Area2D"];
	return [];
	

func on_mouse_entered(body: Node2D) -> void:
	visible = true

func on_mouse_exited(_body: Node2D) -> void:
	visible = false
