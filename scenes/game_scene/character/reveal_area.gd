extends Area2D

func _ready() -> void:
	body_entered.connect(_on_object_entered)
	body_exited.connect(_on_object_exited)
	
func _on_object_entered(in_body: Node2D) -> void:
	print(in_body.name)
	if not in_body is MovableObject:
		return
	(in_body as MovableObject).on_start_pushing.emit()
	
func _on_object_exited(in_body: Node2D) -> void:
	if not in_body is MovableObject:
		return
	(in_body as MovableObject).on_finished_pushing.emit()
