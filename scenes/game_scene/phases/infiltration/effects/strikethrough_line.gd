class_name StrikethroughLine
extends Control

@export var striketrough_duration: float = 1.5;

var line_progress: float = 0.:
	set(value):
		line_progress = value;
		queue_redraw();
var t: Tween;

func start_strikethrough_effect() -> void:
	if t != null:
		t.stop();
	t = create_tween();
	t.tween_property(self, "line_progress", 1.0, striketrough_duration) \
		.set_ease(Tween.EASE_IN_OUT) \
		.set_trans(Tween.TRANS_CUBIC);

func _draw() -> void:
	print(line_progress)
	var left: Vector2 = position + Vector2(0, size.y / 2);
	var right: Vector2 = position + Vector2(size.x * line_progress, size.y / 2);
	draw_line(left, right, Color.WHITE, 2, true);
