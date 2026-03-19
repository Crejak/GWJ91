class_name NotePad;
extends TextureRect

@export var objective_entry_scene: PackedScene;
@export var pages: Array[NotepadPageContent];
@export var page_scene: PackedScene;

@onready var page_container: Control = %PageContainer;
@onready var objective_page: Container = %ObjectivePage;
@onready var objective_container: Container = %ObjectiveContainer;
@onready var previous_button: TextureButton = %ButtonPrevious;
@onready var next_button: TextureButton = %ButtonNext;

var page_nodes: Array[Container]:
	set(value):
		page_nodes = value;
		_update_pages();
var current_page_index: int = 0:
	set = _set_page_index;

func _ready() -> void:
	SignalBus.objective_list_updated.connect(_on_objective_list_updated);
	SignalBus.phase_started.connect(_on_phase_started);
	_update_pages();

func _update_pages() -> void:
	if pages == null:
		return;
	for page: Node in page_container.get_children():
		page.queue_free();
	page_nodes.clear();
	for page_content: NotepadPageContent in pages:
		var page: NotepadPage = page_scene.instantiate();
		page_container.add_child(page);
		page.title = page_content.title;
		page.content = page_content.content;
		page.visible = false;
		page_nodes.push_back(page);
	page_nodes.push_back(objective_page);
	current_page_index = 0;

func _set_page_index(selected_index: int) -> void:
	current_page_index = selected_index;
	for index: int in range(page_nodes.size()):
		page_nodes[index].visible = index == selected_index;
	previous_button.disabled = current_page_index == 0;
	next_button.disabled = current_page_index == page_nodes.size() - 1;

func _on_objective_list_updated() -> void:
	if Level.current == null:
		return;
	for objective: Node in objective_container.get_children():
		objective.queue_free();
	var objective_list := Level.current.objectives;
	var cleared_objectives := GameState.get_current_level_state().objectives;
	for index in range(objective_list.size()):
		var entry: ObjectiveEntry = objective_entry_scene.instantiate();
		objective_container.add_child(entry);
		entry.objective_text = objective_list.get(index).name;
		entry.is_checked = cleared_objectives.get(index) == true;

func _on_phase_started(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.PREPARATION:
		# Focus the objective page
		current_page_index = page_nodes.size() - 1;
		previous_button.disabled = true;

func _on_button_previous_pressed() -> void:
	current_page_index = clampi(current_page_index - 1, 0, page_nodes.size() - 1);

func _on_button_next_pressed() -> void:
	current_page_index = clampi(current_page_index + 1, 0, page_nodes.size() - 1);
