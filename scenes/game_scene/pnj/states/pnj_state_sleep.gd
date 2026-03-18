extends PNJ_State
class_name PNJ_State_Sleep

func _enter_state() -> void:
	super._enter_state()
	pnj.status_animations.play("sleep")


func _exit_state() -> void:
	super._exit_state()
	pnj.status_animations.stop()
