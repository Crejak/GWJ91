class_name HitLightZone
extends Sprite2D

func _ready() -> void:
	modulate = Color.TRANSPARENT;

var t: Tween;

func light_up() -> void:
	if t:
		t.stop();
	t = create_tween();
	t.tween_property(self, "modulate", Color.WHITE, 0.2);
	t.tween_property(self, "modulate", Color.TRANSPARENT, 0.2);
