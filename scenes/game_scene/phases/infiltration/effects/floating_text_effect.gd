class_name FloatingTextEffect
extends Label

@export var floating_distance: Vector2 = Vector2(0, -100);
@export var floating_duration: float = 2.;
@export var transparency_delay: float = 1.0;

var t: Tween;

func start_effect() -> void:
	start_float_up_effect();

func start_float_up_effect() -> void:
	if t:
		t.stop();
	t = create_tween();
	t.tween_property(self, "position", position + floating_distance, floating_duration);
	t.parallel() \
		.tween_property(self, "modulate", Color.TRANSPARENT, floating_duration - transparency_delay) \
		.set_delay(transparency_delay);
	t.tween_callback(queue_free);
