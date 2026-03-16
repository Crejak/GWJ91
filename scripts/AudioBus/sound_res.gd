extends Resource
class_name SoundRes


@export var name :String = ""
@export var stream :AudioStream = AudioStream.new()
@export var variants :Array[AudioStream] = []