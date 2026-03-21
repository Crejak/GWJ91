extends PNJ_State
class_name PNJ_State_Sleep

func _enter_state() -> void:
	super._enter_state()
	pnj.sprite.texture = pnj.idle_texture
	pnj.status_animations.play("sleep")
	pnj.audio_player.stream_paused = true


func _exit_state() -> void:
	super._exit_state()
	pnj.status_animations.stop()
