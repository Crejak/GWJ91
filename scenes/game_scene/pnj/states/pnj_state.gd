extends StateMachineState
class_name PNJ_State

@export var pnj: PNJ
@export var done_on_start: bool

func _on_step_done() -> void:
	await get_tree().create_timer(0.5).timeout
	pnj.step_done.emit()

func _enter_state() -> void:
	pnj.body.global_position = pnj.global_position
	pnj.body.top_level = false
	pnj.body.sleeping = false
	pnj.body.position = Vector2.ZERO
	pnj.animation_player.stop()
	pnj.audio_player.stream_paused = true
	if done_on_start:
		_on_step_done()
