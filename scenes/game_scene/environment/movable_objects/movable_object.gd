@tool
extends CollisionObject2D
class_name MovableObject

signal on_start_pushing()
signal on_finished_pushing()

@export var flip_h: bool = false:
	set(value):
		flip_h = value
		%Sprite2D.flip_h = value
		
@export var flip_v: bool = false:
	set(value):
		flip_v = value
		%Sprite2D.flip_v = value

@export var can_move: bool = true
