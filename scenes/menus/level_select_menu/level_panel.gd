extends PanelContainer
class_name LevelPanel


@onready var level_name_label = %LevelName

@export var level_panel_res :LevelPanelRes = LevelPanelRes.new()


signal clicked(level_id :int)


func _ready() -> void:
	init(level_panel_res)


func init(level_res :LevelPanelRes) -> void:
	level_panel_res = level_res
	level_name_label.text = "[wave amp=10 freq=1]" + level_panel_res.level_name
	level_name_label.add_theme_color_override("default_color", level_panel_res.dialog_res.text_color)
	level_name_label.add_theme_color_override("font_outline_color", level_panel_res.dialog_res.outline_color)


func _on_button_pressed() -> void:
	clicked.emit(level_panel_res.level_id)
