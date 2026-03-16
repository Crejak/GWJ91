extends Node2D

## The mass in kilogram, that will impede the player movement.
@export var mass: float = 2.;
## The monetary value of the object.
@export var monetary_value: int = 50;

func _on_interactable_player_interacted(character: Character) -> void:
	character.pick_up(mass, monetary_value);
	queue_free();
	
