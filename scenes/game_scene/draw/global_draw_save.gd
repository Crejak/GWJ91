extends Node


var points :Array[Vector2] = []


signal clear_drawings;

func _ready() -> void:
	clear_drawings.connect(clear_points)

func save_points(new_points :Array[Vector2]) -> void:
	points.append_array(new_points)


func clear_points() -> void:
	points.clear()
