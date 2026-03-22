extends Node


var lines :Array = []


signal clear_drawings;

func _ready() -> void:
	clear_drawings.connect(clear_points)

func save_new_line(new_points :Array[Vector2]) -> void:
	var points :Array[Vector2] = []
	points.append_array(new_points)
	lines.append(points)


func clear_points() -> void:
	lines.clear()
