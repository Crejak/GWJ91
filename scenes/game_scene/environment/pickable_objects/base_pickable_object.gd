class_name PickableObject
extends Node2D

@export var monetary_value: int = 0;
@export var mass: float = 0; 
@export var item_texture: Texture2D;

@onready var sprite: Sprite2D = %Sprite2D;

var t: Tween

func _ready() -> void:
	SignalBus.phase_started.connect(_on_phase_started);
	SignalBus.phase_ended.connect(_on_phase_ended);

func _on_interactable_player_interacted(source: Character) -> void:
	if source.pick_up(self):
		get_parent().remove_child(self);

func _on_phase_started(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.INFILTRATION:
		_hide();
	
func _on_phase_ended(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.INFILTRATION:
		_display();
		
func _display() -> void:
	if t:
		t.stop()
	#sprite.material.set("shader_parameter/is_active", true)
	sprite.modulate = Color.WHITE
	sprite.visible = true

func _hide() -> void:
	if t:
		t.stop()
	t = create_tween()
	t.tween_property(sprite, "modulate", Color.TRANSPARENT, 0.5)
	t.tween_callback(func() -> void: sprite.visible = false)
