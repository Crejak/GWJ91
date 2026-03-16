extends Node2D

@onready var door: RigidBody2D = %Door
var pin_joint: PinJoint2D

func _on_interactable_player_interacted(source: Character) -> void:
	pin_joint = PinJoint2D.new()
	source.add_child(pin_joint)
	pin_joint.node_a = door.get_path()
	pin_joint.node_b = source.get_path()
	pin_joint.disable_collision = false
	pin_joint.softness = 16
	pin_joint.global_position = source.global_position


func _on_interactable_player_stop_interaction() -> void:
	if pin_joint:
		pin_joint.queue_free()
