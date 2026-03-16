extends Control


@onready var conversation_container = %ConversationContainer
@onready var animation_player :AnimationPlayer = %AnimationPlayer

# State Machine
@onready var state_machine :StateMachine = %PhoneStateMachine
@onready var disable_state :StateMachineState = %DisableState
@onready var ringing_state :StateMachineState = %RingingState
@onready var calling_state :StateMachineState = %CallingState



func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_down"):
		state_machine.set_current_state(ringing_state)
	if Input.is_action_just_pressed("move_up"):
		state_machine.set_current_state(disable_state)


func _on_btn_phone_pressed() -> void:
	if ringing_state.is_current_state():
		state_machine.set_current_state(calling_state)


func display_conversation(enabled :bool = true) -> void:
	conversation_container.visible = enabled
