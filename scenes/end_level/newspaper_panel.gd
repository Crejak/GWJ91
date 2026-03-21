class_name NewspaperPanel
extends Control

@onready var animation_player :AnimationPlayer = %AnimationPlayer
@onready var news_column_label = %NewsColumnLabel


signal continue_pressed
signal main_menu_pressed
signal restart_pressed

@export var news_column :Array[NewsColumn] = []


func appear() -> void:
	visible = true;
	_fill_news_column(Level.current.level_id-1)
	animation_player.play("news_appearing", -1, 1.5)


func _fill_news_column(level_id :int) -> void:
	if level_id >= news_column.size():
		return
	news_column_label.text = news_column[level_id].text


func _on_btn_continue_pressed() -> void:
	GameState.get_current_level_state().set_phase(LevelState.Phase.COMPLETED);
	continue_pressed.emit()
