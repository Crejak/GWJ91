extends PathFollow2D
class_name PNJ

enum State {SLEEP, MOVE, WAIT, CHASE}
@onready var state_machine: StateMachine = %StateMachine
@onready var states: Dictionary[State, StateMachineState] = {
	State.SLEEP: %SLEEP,
	State.MOVE: %MOVE,
	State.WAIT: %WAIT,
	State.CHASE: %CHASE
}
signal state_changed(in_state: State)

@export_group("Detection")
var detection: float = 0.0
@export var chase_threshold: float = 50.0
@onready var detection_progress_bar: ProgressBar = %DetectionProgressBar
@export var chase_path: Path2D

@export_group("Movement")
@onready var body: RigidBody2D = %RigidBody2D

@export var path_following_speed: float = 10.0

@export var min_speed: float = 25
@export var max_speed: float = 100
@export var min_square_dist_to_move: float = 100
@export var max_speed_distance: float = 600

@export_group("Timeline")
signal step_done()
var timer: Timer
var timeline_index: int = 0
var is_waiting_for_step_to_finish: bool
@export var timeline: Array[Step]

@export_group("Visual")
@onready var status_animations: AnimatedSprite2D = %StatusAnimations
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var sprite: Sprite2D = %Sprite2D
@export var walk_texture: Texture2D
@export var idle_texture: Texture2D

@export_group("Detection")
@export var object_noise_factor: float = 0.2
@export var wall_noise_factor: float = 0.2

@export_group("Sound")
@onready var audio_player :AudioStreamPlayer2D = %AudioStreamPlayer2D

func _ready() -> void:
	SignalBus.phase_started.connect(_on_game_phase_changed)
	SignalBus.detection.on_movable_object_noise_start.connect(_on_movable_object_noise_start)
	SignalBus.detection.on_movable_object_noise_stop.connect(_on_movable_object_noise_stop)
	SignalBus.detection.on_wall_noise_start.connect(_on_wall_noise_start)
	SignalBus.detection.on_wall_noise_stop.connect(_on_wall_noise_stop)
	SignalBus.detection.on_player_move.connect(_on_player_move_detection)

func _process(in_delta: float) -> void:
	_increase_detection(in_delta)

func _on_game_phase_changed(in_phase: LevelState.Phase) -> void:
	match in_phase:
		LevelState.Phase.PREPARATION:
			start_game_timer()
			_display()
		LevelState.Phase.INFILTRATION:
			start_game_timer()
			if timeline[0].pnj_state == State.SLEEP:
				_hide()
		LevelState.Phase.CONCLUSION:
			reset()

#region --- Visual ---
func _hide() -> void:
	var t: Tween = create_tween()
	t.tween_property(sprite, "modulate", Color.TRANSPARENT, 0.5)

func _display() -> void:
	var t: Tween = create_tween()
	t.tween_property(sprite, "modulate", Color.WHITE, 0.5)

#endregion --- Visual ---

#region --- Timeline ---
func reset() -> void:
	progress = 0.0
	body.global_position = global_position
	body.linear_velocity = Vector2.ZERO
	state_changed.emit(State.SLEEP)
	state_machine.set_current_state(states[State.SLEEP])
	if not timer:
		timer = Timer.new()
		timer.autostart = false
		timer.one_shot = true
		add_child(timer)
	detection_progress_bar.value = 0
	detection_progress_bar.max_value = chase_threshold
	clear()

func clear() -> void:
	EventBus.clear_signal(timer.timeout)
	EventBus.clear_signal(step_done)
	timeline_index = -1

func start_game_timer() -> void:
	reset()
	await get_tree().process_frame
	reset()
	await get_tree().process_frame

	if timeline.is_empty(): return
	timer.timeout.connect(next_timeline_step, CONNECT_ONE_SHOT)
	@warning_ignore("unsafe_call_argument")
	timer.start(max(0.01, timeline[timeline_index].trigger_at_game_time))

func next_timeline_step() -> void:
	timeline_index += 1
	if timeline.size() <= timeline_index: 
		return
	print("%s - Step [%d] - %s" % [name, timeline_index, State.keys()[timeline[timeline_index].pnj_state]])
	is_waiting_for_step_to_finish = true

	# await minimum duration
	if timeline[timeline_index].duration > 0:
		timer.timeout.connect(try_end_step, CONNECT_ONE_SHOT)
		timer.start(timeline[timeline_index].duration)

	# change state
	var new_state: State = timeline[timeline_index].pnj_state
	step_done.connect(func() -> void: 
		is_waiting_for_step_to_finish = false
		try_end_step()
		, CONNECT_ONE_SHOT)
	state_machine.set_current_state(states[new_state])
	state_changed.emit(new_state)

func try_end_step() -> void:
	if is_waiting_for_step_to_finish: return
	if timer.time_left > 0: return
	if timeline.size() <= timeline_index: return
	next_timeline_step()
#endregion --- Timeline ---

#region --- Detection ---
var object_making_noise: Dictionary[MovableObject, float]
var wall_making_noise: Dictionary[StaticBody2D, float]

func _on_movable_object_noise_start(in_position: Vector2, in_object: MovableObject, in_sound_intensity: float) -> void:
	object_making_noise[in_object] = in_sound_intensity / body.global_position.distance_squared_to(in_position)
	add_detection(object_making_noise[in_object] * object_noise_factor)

func _on_movable_object_noise_stop(in_object: MovableObject) -> void:
	object_making_noise.erase(in_object)

func _on_wall_noise_start(in_position: Vector2, in_wall: StaticBody2D, in_sound_intensity: float) -> void:
	wall_making_noise[in_wall] = in_sound_intensity / body.global_position.distance_squared_to(in_position)
	add_detection(wall_making_noise[in_wall] * wall_noise_factor)
	
func _on_wall_noise_stop(in_wall: StaticBody2D) -> void:
	wall_making_noise.erase(in_wall)

func _on_player_move_detection(in_position: Vector2, in_sound_intensity: float) -> void:
	add_detection(in_sound_intensity / body.global_position.distance_squared_to(in_position))

func _increase_detection(in_delta: float) -> void:
	for obj: MovableObject in object_making_noise:
		add_detection(object_making_noise[obj] * in_delta)
	for wall: StaticBody2D in wall_making_noise:
		add_detection(wall_making_noise[wall] * in_delta)

var warning_index: int = 0
func add_detection(in_value: float) -> void:
	if state_machine.get_current_state() == states[State.CHASE]: return
	if state_machine.get_current_state() == states[State.SLEEP]:
		detection += in_value / 2
	else:
		detection += in_value
	if int(detection * 5) > warning_index:
		status_animations.play("warning")
		warning_index = int(detection * 5)
		await status_animations.animation_finished
		if state_machine.get_current_state() == states[State.SLEEP]:
			status_animations.play("sleep")
	detection_progress_bar.value = detection
	if detection >= chase_threshold:
		print(name, " start CHASE")
		state_machine.set_current_state(states[State.CHASE])
	

#endregion --- Detection ---
