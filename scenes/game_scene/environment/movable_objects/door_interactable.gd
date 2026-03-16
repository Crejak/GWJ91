extends Node2D

@onready var door: RigidBody2D = %Door
var character: Character
var pin_joint: PinJoint2D

func _on_interactable_player_interacted(source: Character) -> void:
	character = source
	pin_joint = PinJoint2D.new()
	character.add_child(pin_joint)
	pin_joint.node_a = door.get_path()
	pin_joint.node_b = character.get_path()
	pin_joint.disable_collision = false
	pin_joint.softness = 16
	pin_joint.global_position = character.global_position
