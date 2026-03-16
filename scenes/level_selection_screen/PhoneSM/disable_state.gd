extends StateMachineState


@export var parentRef :Node


func _enter_state() -> void:
	print("DisableState")

	#if parentRef.animation_player != null:
	#	parentRef.animation_player.stop()
