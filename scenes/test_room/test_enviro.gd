extends Node2D

@export var state_on_ready: LevelState.Phase

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	SignalBus.phase_started.emit(state_on_ready);
