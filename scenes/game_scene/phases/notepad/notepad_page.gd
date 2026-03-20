class_name NotepadPage
extends VBoxContainer

@export var title: String:
	set(value):
		title = value;
		($Title as Label).text = value;
@export var content: String:
	set(value):
		content = value;
		($Content as Label).text = value;
