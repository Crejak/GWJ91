extends Node2D

const DRAWABLE_LINE_2D: PackedScene = preload("uid://n63f22xokvxw")

var last_mouse_position: Vector2
var current_line: drawable_line_2d = null


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("draw"):
		current_line = DRAWABLE_LINE_2D.instantiate()
		add_child(current_line)
	
	elif event.is_action_released("draw"):
		current_line = null

func _process(delta: float) -> void:
	if Input.is_action_pressed("draw") && current_line != null:
		last_mouse_position = get_viewport().get_mouse_position()
		current_line.add_new_point(last_mouse_position)
