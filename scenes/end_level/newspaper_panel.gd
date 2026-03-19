extends Control


@onready var animation_player :AnimationPlayer = %AnimationPlayer


signal continue_pressed
signal main_menu_pressed
signal restart_pressed


func _ready() -> void:
	animation_player.play("news_appearing", -1, 1.5)

func _on_btn_continue_pressed() -> void:
	continue_pressed.emit()
