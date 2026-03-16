extends StateMachineState


@export var parentRef :Node


func _enter_state() -> void:
	print("CallingState")

	_play_open_phone_animation()


func _exit_state() -> void:
	parentRef.animation_player.stop()
	parentRef.animation_player.play_backwards("open_phone")
	parentRef.display_conversation(false)


func _play_open_phone_animation() -> void:
	parentRef.animation_player.animation_finished.connect(_on_open_anim_finished, CONNECT_ONE_SHOT)
	parentRef.animation_player.play("open_phone")


func _on_open_anim_finished(anim_name :String) -> void:
	if is_current_state():
		parentRef.animation_player.play("calling_animation")
		parentRef.display_conversation(true)
