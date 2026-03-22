extends Node


@export var sfx_library :SoundLibrary = SoundLibrary.new()
@export var music_library :SoundLibrary = SoundLibrary.new()

var audio_stream_players :Array = []


func _ready() -> void:

	for child in get_children():
		if child is AudioStreamPlayer:
			audio_stream_players.append(child)


func _get_audio_stream_player(bus :String) -> AudioStreamPlayer:

	for audio_player :AudioStreamPlayer in audio_stream_players:
		if audio_player.bus == bus:
			return audio_player
	
	return null


func _get_available_stream_player(bus :String, forced :bool = true) -> AudioStreamPlayer:

	for audio_player :AudioStreamPlayer in audio_stream_players:
		if audio_player.bus == bus and !audio_player.playing:
			return audio_player

	if forced:
		return _get_audio_stream_player(bus)

	return null


func play_sound_from_file(filePath :String, bus :String) -> void:

	var stream :AudioStream = null
	var extension :String = filePath.get_extension().to_lower()

	if extension == "wav":
		stream = AudioStreamWAV.load_from_file(filePath)
	elif extension == "ogg":
		stream = AudioStreamOggVorbis.load_from_file(filePath)
	elif extension == "mp3":
		stream = AudioStreamMP3.load_from_file(filePath)

	play_audio_stream(stream, bus)


func play_audio_stream(stream :AudioStream, bus :String):
	var audio_player :AudioStreamPlayer = _get_available_stream_player(bus)

	if audio_player == null:
		return

	if stream == null:
		return
	
	audio_player.stream = stream
	audio_player.play()


func play_sfx(soundName :String, useVariants :bool = true, fadeIn :bool = false):

	var sound :SoundRes = sfx_library.get_by_name(soundName)

	if sound == null:
		return

	var stream = sound.stream

	if useVariants and not sound.variants.is_empty():
		stream = sound.variants.pick_random()
	
	var audio_player :AudioStreamPlayer = _get_available_stream_player(sfx_library.bus)

	if audio_player == null:
		return

	if stream == null:
		return
	
	audio_player.stream = stream
	audio_player.play()

	if fadeIn:
		audio_player.volume_db = -80
		await fade_in_sound(audio_player, 0.1)
	else:
		audio_player.volume_db = 0


func stop_sfx(soundName :String) -> void:
	
	var sound :SoundRes = sfx_library.get_by_name(soundName)

	for audio_player :AudioStreamPlayer in audio_stream_players:
		if audio_player.bus == sfx_library.bus and audio_player.playing:
			if sound.stream == audio_player.stream:
				audio_player.stop()


func play_music(musicName :String, fadeOut :bool = true, fadeIn :bool = true):

	var audio_player = _get_audio_stream_player(music_library.bus)

	var sound = music_library.get_by_name(musicName)

	if audio_player.stream != null:
		if sound.stream == audio_player.stream:
			return
	
	if audio_player.playing and fadeOut:
		await fade_out_sound(audio_player)

	if sound == null:
		return
	
	audio_player.stream = sound.stream
	audio_player.play()

	if fadeIn:
		await fade_in_sound(audio_player)
	else:
		audio_player.volume_db = 0


func stop_music(fadeOut :bool = true):

	var audio_player = _get_audio_stream_player(music_library.bus)

	if audio_player.playing and fadeOut:
		await fade_out_sound(audio_player)

	audio_player.stop()


func fade_out_sound(audio_player :AudioStreamPlayer, duration :float = 1.5):
	
	var tween :Tween = get_tree().create_tween().bind_node(audio_player).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(audio_player, "volume_db", -80, duration)
	tween.play()

	await tween.finished

	return


func fade_in_sound(audio_player :AudioStreamPlayer, duration :float = 1.5):
	
	var tween :Tween = get_tree().create_tween().bind_node(audio_player).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(audio_player, "volume_db", 0, duration)
	tween.play()

	await tween.finished

	return
