extends Node


var save_game_res :SaveGameStats

var thread: Thread = Thread.new()
var semaphore := Semaphore.new()


func _ready():
	SignalBus.save_requested.connect(trigger_save)
	_create_or_load_save()
	#_init_language()
	thread.start(save)


func save():
	while true:
		semaphore.wait()
		save_game_res.write_savegame()


func trigger_save():
	semaphore.post()


func _init_language() -> void:
	var lang = ProjectSettings.get_setting("internationalization/locale/fallback")
	TranslationServer.set_locale(lang)


func _create_or_load_save() -> void:
	if SaveGameStats.save_exists():
		save_game_res = SaveGameStats.load_savegame()
	else:
		save_game_res = SaveGameStats.new()

	SignalBus.savegame_loaded.emit()
