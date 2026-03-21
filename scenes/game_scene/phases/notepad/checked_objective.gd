class_name ObjectiveEntry
extends HBoxContainer

@export var is_checked: bool = false:
	set(value):
		is_checked = value;
		(%Check as Label).text = "[X]" if is_checked else "[ ]";

@export var objective_text: String = "":
	set(value):
		objective_text = value;
		(%Objective as Label).text = objective_text;
