extends Node

@export var back_ground_color: ColorRect
@export var color_infiltration: Color
@export var color_preparation: Color

@export var blueprint_sprite: Sprite2D

func _ready() -> void:
	SignalBus.phase_started.connect(_on_phase_started)

func _on_phase_started(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.PREPARATION:
		blueprint_sprite.material.set("shader_parameter/is_active", false)
		var t: Tween = create_tween()
		t.tween_property(back_ground_color, "self_modulate", color_preparation, 0.5)
	elif phase == LevelState.Phase.INFILTRATION:
		blueprint_sprite.material.set("shader_parameter/is_active", true)
		var t: Tween = create_tween()
		t.tween_property(back_ground_color, "self_modulate", color_infiltration, 0.5)
