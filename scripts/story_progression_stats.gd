extends Resource
class_name StoryProgressionStats

@export var story_progression :int = 0
@export var last_story_event :int = -1


func set_story_progression(level_id :int) -> void:
	if level_id > story_progression:
		story_progression = level_id
	
func event_catch_up() -> void:
	last_story_event = story_progression

func has_story_progressed() -> bool:
	return last_story_event < story_progression
