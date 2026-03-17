extends Control

@export var item_box_scene: PackedScene;

var active: bool = false;
var active_character: Character; 

func _ready() -> void:
	SignalBus.active_character_changed.connect(_on_active_character_changed);

func _on_active_character_changed(character: Character) -> void:
	if active_character != null && active_character.inventory_changed.is_connected(_on_character_inventory_changed):
		active_character.inventory_changed.disconnect(_on_character_inventory_changed);
	active_character = character;
	if active_character != null:
		active_character.inventory_changed.connect(_on_character_inventory_changed);
	init_boxes();
	update_box_content();
		
func _on_character_inventory_changed() -> void:
	update_box_content();

func init_boxes() -> void:
	for item_box: Node in get_children():
		item_box.queue_free();
	var box_count: int = active_character.INVENTORY_SIZE if active_character != null else 0;
	for i: int in range(box_count):
		var item_box: ItemBox = item_box_scene.instantiate();
		item_box.inventory_index = i;
		add_child(item_box);

func update_box_content() -> void:
	for item_box: ItemBox in get_children():
		var index := item_box.inventory_index;
		var pickable_object: PickableObject = null;
		if active_character != null:
			pickable_object = active_character.picked_up_objects.get(index);
		item_box.object = pickable_object;
