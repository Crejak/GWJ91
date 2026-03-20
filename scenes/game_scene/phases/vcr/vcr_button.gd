extends TextureButton

@export var hover_text: String;

@onready var helper_label: Label = %HelperLabel;

func _on_mouse_entered() -> void:
	if disabled:
		return;
	helper_label.text = hover_text;

func _on_mouse_exited() -> void:
	helper_label.text = "";
