extends Sprite2D

@export var points :Array = [
	Vector2(32.40001, 106.8), Vector2(60.00002, 116.4), Vector2(80.40002, 117.6), Vector2(102.0, 116.4), Vector2(123.6, 112.8), Vector2(148.8, 104.4), Vector2(170.4, 86.4), Vector2(180.0, 66.00001), Vector2(175.2, 42.0), Vector2(153.6, 33.6), Vector2(133.2, 32.4), Vector2(115.2, 42.0), Vector2(109.2, 63.6), Vector2(109.2, 86.4), Vector2(121.2, 103.2), Vector2(140.4, 115.2), Vector2(169.2, 120.0), Vector2(201.6, 126.0), Vector2(224.4, 126.0)
]

@onready var current_line :drawable_line_2d = %Line
@onready var cursor = %Cursor
var animate :bool = true

signal restart_animation


func _ready() -> void:
	SignalBus.start_drawing.connect(_on_start_drawing)
	restart_animation.connect(_animate_draw_line)
	global_position = get_parent().global_position
	global_position.x -= 150
	_animate_draw_line()


func _animate_draw_line() -> void:
	current_line.clear_points()
	for point in points:
		current_line.add_point(point)
		cursor.position = point
		await get_tree().create_timer(0.03).timeout

	await get_tree().create_timer(1).timeout
	if animate:
		restart_animation.emit()


func _on_start_drawing() -> void:
	visible = false
	animate = false
