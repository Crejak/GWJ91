@tool
extends RigidBody2D
class_name MovableObject

@warning_ignore("unused_signal")
signal on_start_pushing()
@warning_ignore("unused_signal")
signal on_finished_pushing()

@export var flip_h: bool = false:
	set(value):
		flip_h = value
		@warning_ignore("unsafe_property_access")
		%Sprite2D.flip_h = value
		
@export var flip_v: bool = false:
	set(value):
		flip_v = value
		@warning_ignore("unsafe_property_access")
		%Sprite2D.flip_v = value

@export var can_move: bool = true

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(in_body: Node2D) -> void:
	if in_body is Character:
		SignalBus.detection.on_movable_object_noise_start.emit(global_position, self, mass * (in_body as Character).linear_velocity.length_squared())

func _on_body_exited(in_body: Node2D) -> void:
	if in_body is Character:
		SignalBus.detection.on_movable_object_noise_stop.emit(self)
