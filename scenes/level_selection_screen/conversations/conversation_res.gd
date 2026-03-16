extends Resource
class_name ConversationRes


@export var caller_name :String = ""
@export var text_color :Color = Color.WHITE
@export var outline_color :Color = Color.WHITE
@export var dialogs :Array[String]


func get_line(id :int) -> String:
	if id < dialogs.size():
		return dialogs[id]
	return ""