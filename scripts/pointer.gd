extends Node

@export var cursors: Dictionary[Input.CursorShape, Dictionary] = {
	Input.CursorShape.CURSOR_ARROW: {"Small": null, "HD": null, "4K": null},
	Input.CursorShape.CURSOR_IBEAM: {"Small": null, "HD": null, "4K": null},
	Input.CursorShape.CURSOR_POINTING_HAND: {"Small": null, "HD": null, "4K": null},
	Input.CursorShape.CURSOR_CROSS: {"Small": null, "HD": null, "4K": null},
	Input.CursorShape.CURSOR_WAIT: {"Small": null, "HD": null, "4K": null},
	Input.CursorShape.CURSOR_BUSY: {"Small": null, "HD": null, "4K": null},
	Input.CursorShape.CURSOR_DRAG: {"Small": null, "HD": null, "4K": null},
	Input.CursorShape.CURSOR_CAN_DROP: {"Small": null, "HD": null, "4K": null},
	Input.CursorShape.CURSOR_FORBIDDEN: {"Small": null, "HD": null, "4K": null},
	Input.CursorShape.CURSOR_VSIZE: {"Small": null, "HD": null, "4K": null},
	Input.CursorShape.CURSOR_HSIZE: {"Small": null, "HD": null, "4K": null},
	Input.CursorShape.CURSOR_BDIAGSIZE: {"Small": null, "HD": null, "4K": null},
	Input.CursorShape.CURSOR_FDIAGSIZE: {"Small": null, "HD": null, "4K": null},
	Input.CursorShape.CURSOR_MOVE: {"Small": null, "HD": null, "4K": null},
	Input.CursorShape.CURSOR_VSPLIT: {"Small": null, "HD": null, "4K": null},
	Input.CursorShape.CURSOR_HSPLIT: {"Small": null, "HD": null, "4K": null},
	Input.CursorShape.CURSOR_HELP: {"Small": null, "HD": null, "4K": null},
}
@export var fall_back: Dictionary = {"Small": null, "HD": null, "4K": null}
@export var hotspot: Dictionary[String, Vector2] = {"Small": Vector2(13, 1), "HD": Vector2(18, 3), "4K": Vector2(36,6)}

func _ready() -> void:
	select_pointer()
	get_viewport().size_changed.connect(select_pointer)

func select_pointer() -> void:
	var screen_size: Vector2i = get_window().size
	if screen_size.x < 1920 or screen_size.y < 1080:
		for i: Input.CursorShape in cursors:
			if cursors[i]["Small"] == null:
				Input.set_custom_mouse_cursor(fall_back["Small"], i, hotspot["Small"])
			else:
				Input.set_custom_mouse_cursor(cursors[i]["Small"], i, hotspot["Small"])
	elif screen_size.x < 3000:
		for i: Input.CursorShape in cursors:
			if cursors[i]["HD"] == null:
				Input.set_custom_mouse_cursor(fall_back["HD"], i, hotspot["HD"])
			else:
				Input.set_custom_mouse_cursor(cursors[i]["HD"], i, hotspot["HD"])
	else:
		for i: Input.CursorShape in cursors:
			if cursors[i]["4K"] == null:
				Input.set_custom_mouse_cursor(fall_back["4K"], i, hotspot["4K"])
			else:
				Input.set_custom_mouse_cursor(cursors[i]["4K"], i, hotspot["4K"])
