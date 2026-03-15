extends Node2D

@export var pushForce: int = 1000

@onready var body: CharacterBody2D = get_parent()

func _physics_process(_delta) -> void:
	if body.move_and_slide(): # true if collided
		for i in body.get_slide_collision_count():
			var col: KinematicCollision2D = body.get_slide_collision(i)
			if col.get_collider() is RigidBody2D:
				var object: RigidBody2D = col.get_collider()
				if "can_move" in object and object.can_move:
					object.apply_force(col.get_normal() * - pushForce)
					
