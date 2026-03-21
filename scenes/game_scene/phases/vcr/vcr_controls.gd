@tool
class_name VCRControls
extends VBoxContainer

signal play_button_pressed;
signal skip_button_pressed;

@export var play_disabled: bool = false:
	set(value):
		play_disabled = value;
		(%PlayButton as TextureButton).disabled = value;
@export var skip_disabled: bool = false:
	set(value):
		skip_disabled = value;
		(%SkipButton as TextureButton).disabled = value;

func _on_play_button_pressed() -> void:
	play_button_pressed.emit();
	AudioBus.play_sfx("PLAY_MAGNETO")

func _on_skip_button_pressed() -> void:
	skip_button_pressed.emit();
	AudioBus.play_sfx("PLAY_MAGNETO")
