extends Control
class_name PhoneDialogs


@onready var background :PanelContainer = %Background
@onready var animation_player :AnimationPlayer = %AnimationPlayer

# State Machine
@onready var state_machine :StateMachine = %PhoneStateMachine
@onready var disable_state :StateMachineState = %DisableState
@onready var appearing_state :StateMachineState = %AppearingState
@onready var ringing_state :StateMachineState = %RingingState
@onready var calling_state :StateMachineState = %CallingState
@onready var disappearing_state :StateMachineState = %DisappearingState

# Dialog
@onready var conversation_container = %ConversationContainer
@onready var dialog_text_label = %ConversationTextLabel
@onready var phone_screen = %PhoneScreenInfos
@onready var phone_text = %CallingText
@onready var phone_caller_name = %IncommingCallName

@export var dialogs :Array[ConversationRes]
var current_dialog :ConversationRes = ConversationRes.new()


func _ready() -> void:
	dialog_text_label.end_dialog.connect(_on_dialog_ended)

	current_dialog = dialogs[0]

	state_machine.set_current_state(disable_state)


func start_dialog(dialog_index :int) -> void:
	if dialog_index >= dialogs.size():
		return

	current_dialog = dialogs[dialog_index]
	state_machine.set_current_state(appearing_state)


func _on_btn_phone_pressed() -> void:
	if ringing_state.is_current_state():
		state_machine.set_current_state(calling_state)


func display_screen_caller_name() -> void:
	phone_caller_name.text = current_dialog.caller_name
	phone_caller_name.add_theme_color_override("default_color", current_dialog.text_color)
	phone_caller_name.add_theme_color_override("font_outline_color", current_dialog.outline_color)
	phone_screen.visible = true


func display_conversation(enabled :bool = true) -> void:
	if enabled:
		dialog_text_label.init(current_dialog)
	
	conversation_container.visible = enabled
	dialog_text_label.is_enabled = enabled


func _on_dialog_ended() -> void:
	state_machine.set_current_state(disappearing_state)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_down"):
		state_machine.set_current_state(appearing_state)
	if Input.is_action_just_pressed("move_up"):
		state_machine.set_current_state(disable_state)
