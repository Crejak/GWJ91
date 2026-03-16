extends StateMachineState


@export var parentRef :Node


func _enter_state() -> void:
	print("RingingState")

	_play_ringing_animation()


func _exit_state() -> void:
	parentRef.animation_player.animation_finished.disconnect(_on_ringing_anim_finished)



func _play_ringing_animation() -> void:
	parentRef.animation_player.animation_finished.connect(_on_ringing_anim_finished, CONNECT_ONE_SHOT)
	AudioBus.play_sfx("PHONE_RING")
	parentRef.animation_player.play("phone_ringing")


func _on_ringing_anim_finished(anim_name :String) -> void:
	if is_current_state():
		_play_ringing_animation()