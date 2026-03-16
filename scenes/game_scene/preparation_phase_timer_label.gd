extends Label

@export var timer: Timer;

func _process(_delta: float) -> void:
	text = "Preparation phase remaining time : %d" % timer.time_left;
