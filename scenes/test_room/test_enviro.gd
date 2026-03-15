extends Node2D

@export var state_on_ready: PhaseManager.Phase

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	match state_on_ready:
		PhaseManager.Phase.PREPARATION:
			SignalBus.preparation_phase_started.emit()
		PhaseManager.Phase.INFILTRATION:
			SignalBus.infiltration_phase_started.emit()
