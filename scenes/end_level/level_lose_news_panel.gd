class_name LevelLoseNewspaperPanel
extends Control

@onready var animation_player :AnimationPlayer = %AnimationPlayer
@onready var news_column_label = %NewsColumnLabel


signal continue_pressed
signal main_menu_pressed
signal restart_pressed

func _ready() -> void:
	if get_tree().current_scene == self:
		appear();

func appear() -> void:
	visible = true;
	animation_player.play("news_appearing", -1, 1.5)

func _on_btn_restart_pressed() -> void:
	SceneLoader.reload_current_scene();
	restart_pressed.emit()

func _on_exit_button_pressed() -> void:
	SceneLoader.load_scene(AppConfig.level_select_scene_path);
	continue_pressed.emit()
