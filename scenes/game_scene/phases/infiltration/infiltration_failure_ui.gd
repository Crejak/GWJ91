extends Control

func _ready() -> void:
	SignalBus.character_caught.connect(_on_character_caught);
	visible = false;

func _on_character_caught() -> void:
	visible = true;

func _on_retry_level_button_pressed() -> void:
	SceneLoader.reload_current_scene();
