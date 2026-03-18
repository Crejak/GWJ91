@tool
extends RigidBody2D
class_name MovableObject

@warning_ignore("unused_signal")
signal on_start_pushing()
@warning_ignore("unused_signal")
signal on_finished_pushing()
signal on_light_changed(in_is_light_on: bool)

@export var flip_h: bool = false:
	set(value):
		flip_h = value
		@warning_ignore("unsafe_property_access")
		%Sprite2D.flip_h = value
		
@export var flip_v: bool = false:
	set(value):
		flip_v = value
		@warning_ignore("unsafe_property_access")
		%Sprite2D.flip_v = value

@export var can_move: bool = true

@export_group("Pickable object")
## If true, the object can be picked up when interacted with
@export var pickable: bool = false:
	set(value):
		pickable = value;
		var pickable_area: Area2D = %PickableArea2D;
		pickable_area.visible = value;
		pickable_area.monitoring = value;
## Value, in dollar, of the item
@export var monetary_value: int = 0;
## Texture to use in the inventory UI when the item is picked up
@export var item_texture: Texture2D;
## Name to be displayed in the inventory UI when the item is picked up
@export var item_name: String;

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = [];
	if pickable && item_texture == null:
		warnings.push_back("A pickable object must have an item texture");
	return [];

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(in_body: Node2D) -> void:
	if in_body is Character:
		SignalBus.detection.on_movable_object_noise_start.emit(global_position, self, mass * (in_body as Character).linear_velocity.length_squared())

func _on_body_exited(in_body: Node2D) -> void:
	if in_body is Character:
		SignalBus.detection.on_movable_object_noise_stop.emit(self)

func _on_pick_up_interactable_player_interacted(source: Character) -> void:
	if !pickable:
		return;
	source.pick_up(self);
	get_parent().remove_child(self);
