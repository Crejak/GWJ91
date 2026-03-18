extends StateMachineState


@export var parentRef :Node


func _enter_state() -> void:
	print("CallingState")

	_play_open_phone_animation()
	parentRef.phone_text.text = "Calling ..."


func _exit_state() -> void:
	parentRef.animation_player.stop()
	parentRef.display_conversation(false)
	parentRef.phone_screen.visible = false


func _play_open_phone_animation() -> void:
	parentRef.animation_player.animation_finished.connect(_on_open_anim_finished, CONNECT_ONE_SHOT)
	parentRef.animation_player.play("open_phone")


func _on_open_anim_finished(anim_name :String) -> void:
	if is_current_state():
		parentRef.animation_player.play("calling_animation")
		parentRef.display_conversation(true)


#func _process(delta: float) -> void:
#	if Input.is_action_just_pressed("skip_dialog"):
#		parentRef.dialog_text_label.inputManagement()