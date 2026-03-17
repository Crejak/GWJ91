extends Control


@onready var animation_player :AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	animation_player.play("news_appearing")