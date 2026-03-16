extends RichTextLabel
class_name DialogTextLabel


@export var dialog :ConversationRes = ConversationRes.new()
var current_line :String = ""
var current_line_id :int = 0
var current_character :int = 0

var is_printing :bool = false

signal end_dialog


func init(new_dialog :ConversationRes) -> void:
	dialog = new_dialog
	current_line_id = 0
	current_character = 0
	_display_next_line()


func _process(delta: float) -> void:	
	if is_printing:
		_display_next_character(delta)
	
	inputManagement()


func inputManagement():
	if Input.is_action_just_pressed("ui_accept"):
		if is_printing:
			_end_printing_line()
		else:
			_display_next_line()


func _display_next_line() -> void:
	text = ""
	current_line = dialog.get_line(current_line_id)
	if current_line.is_empty():
		end_dialog.emit()
		return
	is_printing = true


func _end_printing_line() -> void:
	is_printing = false
	text = current_line
	current_character = 0
	current_line_id += 1


func _display_next_character(delta: float) -> void:
	if current_character >= current_line.length():
		_end_printing_line()
		return
	text = text + current_line[current_character]
	current_character += 1