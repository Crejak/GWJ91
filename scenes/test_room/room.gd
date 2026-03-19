extends Area2D

var light_on: bool = false
@onready var mask: Sprite2D = %Sprite2D
@export var color_light: Color = Color.GRAY

var pnjs: Array[PNJ] = []

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	SignalBus.phase_started.connect(_on_phase_changed)

func _on_phase_changed(in_phase: LevelState.Phase) -> void:
	match in_phase:
		LevelState.Phase.PREPARATION:
			hide()
		LevelState.Phase.INFILTRATION:
			visible = true
			light_on = true
			try_hide_room()

func _on_body_entered(in_body: Node2D) -> void:
	if in_body.is_in_group("PNJ"):
		add_pnj(in_body.get_parent() as PNJ)
		display_room()
	elif in_body is MovableObject:
		var object: MovableObject = in_body
		object.on_light_changed.emit(true)
	elif in_body is Character and light_on:
		SignalBus.character_caught.emit()


func _on_body_exited(in_body: Node2D) -> void:
	if in_body.is_in_group("PNJ"):
		remove_pnj(in_body.get_parent() as PNJ)
		try_hide_room()


func display_room() -> void:
	if not visible: return
	if light_on: return
	light_on = true
	var t: Tween = create_tween()
	t.tween_property(mask, "modulate", color_light, 0.5)
	for obj: Node2D in get_overlapping_bodies():
		if obj is MovableObject:
			(obj as MovableObject).on_light_changed.emit(true)
		if obj.is_in_group("PNJ"):
			(obj.get_parent() as PNJ)._display()
		if obj is Character:
			SignalBus.character_caught.emit()


func add_pnj(in_pnj: PNJ) -> void:
	pnjs.append(in_pnj)
	in_pnj.state_changed.connect(_on_pnj_change_state)


func remove_pnj(in_pnj: PNJ) -> void:
	pnjs.erase(in_pnj)
	in_pnj.state_changed.disconnect(_on_pnj_change_state)


func _on_pnj_change_state(in_state: PNJ.State) -> void:
	if in_state == PNJ.State.SLEEP:
		try_hide_room()
	else:
		display_room()


func try_hide_room() -> void:
	if not visible: return
	if not light_on: return
	if pnjs.any(func(in_pnj: PNJ) -> bool: return in_pnj.state_machine.current_state != in_pnj.states[PNJ.State.SLEEP]):
		return
	light_on = false
	var t: Tween = create_tween()
	t.tween_property(mask, "modulate", Color.TRANSPARENT, 0.5)
	for obj: Node2D in get_overlapping_bodies():
		if obj is MovableObject:
			(obj as MovableObject).on_light_changed.emit(false)
		if obj.is_in_group("PNJ"):
			(obj.get_parent() as PNJ)._hide()
