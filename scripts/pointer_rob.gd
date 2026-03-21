extends Node

const PEN_TEXTURE: Texture2D = preload("uid://yfia1mxd0gij")
const POINTER: Texture2D = preload("uid://ceujkhuhmijja")

func _ready() -> void:
	SignalBus.phase_started.connect(on_phase_changed)

func on_phase_changed(in_phase: LevelState.Phase) -> void:
	match in_phase:
		LevelState.Phase.PREPARATION:
			Input.set_custom_mouse_cursor(PEN_TEXTURE, 0, Vector2(66, 133))
		LevelState.Phase.INFILTRATION:
			Input.set_custom_mouse_cursor(POINTER, 0, Vector2(63, 63))
		_:
			Input.set_custom_mouse_cursor(null, 0, Vector2.ZERO)
