extends Resource
class_name SoundLibrary


@export var bus :String = ""
@export var library :Array[SoundRes] = []


func get_by_name(name :String) -> SoundRes:

    for sound in library:
        if sound.name == name:
            return sound

    return null