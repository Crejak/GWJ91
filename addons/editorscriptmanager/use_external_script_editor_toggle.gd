@tool
extends EditorScript

func _run() -> void:
	var settings = EditorInterface.get_editor_settings()
	settings.set_setting("text_editor/external/use_external_editor", not settings.get_setting("text_editor/external/use_external_editor"))
