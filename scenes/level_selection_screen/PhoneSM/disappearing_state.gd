extends StateMachineState


@export var parentRef :Node


func _enter_state() -> void:
	print("DisappearingState")
	parentRef.animation_player.animation_finished.connect(_on_disappearing_finished, CONNECT_ONE_SHOT)
	parentRef.animation_player.play("disappearing")


func _on_disappearing_finished(anim_name :String):
	if anim_name == "disappearing":
		parentRef.state_machine.set_current_state(parentRef.disable_state)
		parentRef.queue_free()
