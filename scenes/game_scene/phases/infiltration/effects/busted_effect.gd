class_name BustedEffect
extends Label

func _ready() -> void:
	visible = false;
	if get_tree().current_scene == self:
		start_effect();
	
func start_effect() -> void:
	visible = true;
	var t := create_tween();
	t.tween_property(self, "scale", Vector2(2, 2), 1) \
		.set_ease(Tween.EASE_IN) \
		.set_trans(Tween.TRANS_BACK);
