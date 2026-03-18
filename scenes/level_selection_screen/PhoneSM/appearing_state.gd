extends StateMachineState


@export var parentRef :Node


func _enter_state() -> void:
	print("AppearingState")
	parentRef.animation_player.animation_finished.connect(_on_appearing_finished, CONNECT_ONE_SHOT)
	parentRef.animation_player.play("appearing")


func _on_appearing_finished(anim_name :String):
	if anim_name == "appearing":
		parentRef.state_machine.set_current_state(parentRef.ringing_state)