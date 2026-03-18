@tool
extends Node
class_name OnHitComponent

@export var shader: ShaderMaterial
@export var movable_object: MovableObject

@onready var parent: Node = get_parent()
var sprite: Sprite2D
var t: Tween
var is_light_on: bool = true

func _get_configuration_warnings() -> PackedStringArray:
	if parent and not parent is Sprite2D:
		return ["Hit Component (%s) is not child of a Sprite2D" % str(get_path())]
	return []

func _ready() -> void:
	if Engine.is_editor_hint(): return
	sprite = parent
	sprite.material = shader
	if movable_object:
		movable_object.on_start_pushing.connect(_display)
		movable_object.on_finished_pushing.connect(_hide)
		movable_object.on_light_changed.connect(_change_light)
	SignalBus.phase_started.connect(_on_phase_started)

func _change_light(in_is_light_on: bool) -> void:
	is_light_on = in_is_light_on
	if is_light_on:
		_display()
	else:
		_hide()

func _display() -> void:
	if t:
		t.stop()
	sprite.material.set("shader_parameter/is_active", not is_light_on)
	sprite.modulate = Color.WHITE
	sprite.visible = true

func _hide() -> void:
	if is_light_on:
		return
	if t:
		t.stop()
	t = create_tween()
	t.tween_property(sprite, "modulate", Color.TRANSPARENT, 0.5)
	t.tween_callback(func() -> void: sprite.visible = false)

func _on_phase_started(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.INFILTRATION:
		_hide();
