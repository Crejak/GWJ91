extends StateMachineState
class_name PNJ_State

@export var pnj: PNJ
@export var done_on_start: bool

func _on_step_done() -> void:
	pnj.step_done.emit()

func _enter_state() -> void:
	if done_on_start:
		_on_step_done()
