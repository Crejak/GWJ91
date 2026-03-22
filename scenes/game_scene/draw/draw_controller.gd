class_name DrawController

extends Node2D

@export var enable_draw = true

const DRAWABLE_LINE_2D: PackedScene = preload("uid://n63f22xokvxw")

var last_mouse_position: Vector2
var current_line: drawable_line_2d = null

func _ready() -> void:
	SignalBus.phase_started.connect(_on_phase_started);
	SignalBus.phase_ended.connect(_on_phase_ended);
	GlobalDrawSave.clear_drawings.connect(erase_lines);

func _input(event: InputEvent) -> void:
	if !Level.current:
		return;
	if !(Level.current.level_state.current_phase == LevelState.Phase.PREPARATION):
		return
	if Input.is_action_just_pressed("draw"):
		SignalBus.start_drawing.emit()
		AudioBus.play_sfx("SCRIBBLE")
		current_line = DRAWABLE_LINE_2D.instantiate()
		add_child(current_line)
	
	elif event.is_action_released("draw"):
		AudioBus.stop_sfx("SCRIBBLE")
		current_line = null

func _process(delta: float) -> void:
	if ! enable_draw:
		return
	
	if Input.is_action_pressed("draw") && current_line != null:
		last_mouse_position = get_global_mouse_position()
		current_line.add_new_point(last_mouse_position)

func _on_phase_started(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.PREPARATION:
		draw_previous_lines()
		enable_draw = true;
		visible = true;

func _on_phase_ended(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.PREPARATION:
		enable_draw = false;
		_save_points()
	if phase == LevelState.Phase.INFILTRATION:
		visible = false;
		#erase_lines();
	AudioBus.stop_sfx("SCRIBBLE")
		
func erase_lines() -> void:
	for child: Node in get_children():
		child.queue_free();


func draw_previous_lines() -> void:
	if !GlobalDrawSave.lines.is_empty():
		var lines = GlobalDrawSave.lines
		for points in lines:
			var line :drawable_line_2d = DRAWABLE_LINE_2D.instantiate()
			line.points = points
			add_child(line)


func _save_points():
	for child: Node in get_children():
		if child is drawable_line_2d:
			GlobalDrawSave.save_new_line(child.points)
