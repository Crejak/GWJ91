extends Control

## Loads a simple ItemList node within a margin container. SceneLister updates
## the available scenes in the directory provided. Activating a level will update
## the GameState's current_level, and emit a signal. The main menu node will trigger
## a load action from that signal.

signal level_selected

@onready var level_panel_container = %LevelPanelContainer
@onready var level_buttons_container: ItemList = %LevelButtonsContainer
@onready var scene_lister: SceneLister = $SceneLister
var level_paths : Array[String]

@onready var phone_scene :PackedScene = load("res://scenes/level_selection_screen/phone_scene.tscn")


func _ready() -> void:
	#add_levels_to_container()
	_retreive_level_paths()
	_update_level_panels()
	_load_story_event()
	AudioBus.play_music("TITLE_SCREEN")


func _retreive_level_paths() -> void:
	$SceneLister._refresh_files()
	for file :String in $SceneLister.files:
		level_paths.append(file)


func _update_level_panels() -> void:
	var currentStoryProgression :StoryProgressionStats = GlobalState.current.story_progression
	for panel :LevelPanel in level_panel_container.get_children():
		panel.visible = (currentStoryProgression.last_story_event >= panel.level_panel_res.level_id)



func _load_story_event() -> void:
	var currentStoryProgression :StoryProgressionStats = GlobalState.current.story_progression
	if currentStoryProgression.has_story_progressed():
		currentStoryProgression.event_catch_up()
		GlobalState.save()
		var phone :PhoneDialogs = phone_scene.instantiate()
		phone.dialog_terminated.connect(_update_level_panels)
		add_child(phone)
		phone.start_dialog(currentStoryProgression.story_progression)

	
## A fresh level list is propgated into the ItemList, and the file names are cleaned
func add_levels_to_container() -> void:
	level_buttons_container.clear()
	level_paths.clear()
	var game_state := GameState.get_or_create_state()
	for file_path in game_state.level_states.keys():
		var file_name : String = file_path.get_file()  # e.g., "level_1.tscn"
		file_name = file_name.trim_suffix(".tscn")  # Remove the ".tscn" extension
		file_name = file_name.replace("_", " ")  # Replace underscores with spaces
		file_name = file_name.capitalize()  # Convert to proper case
		var button_name := str(file_name)
		level_buttons_container.add_item(button_name)
		level_paths.append(file_path)


func _on_level_buttons_container_item_activated(index: int) -> void:
	GameState.set_checkpoint_level_path(level_paths[index])
	level_selected.emit()


func _on_button_pressed() -> void:
	GameState.set_checkpoint_level_path(level_paths[0])
	level_selected.emit()


func _on_panel_container_clicked(level_id: int) -> void:
	GameState.set_checkpoint_level_path(level_paths[level_id])
	level_selected.emit()
