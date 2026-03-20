extends Control

@onready var score_label: Label = %ScoreLabel;
@onready var level_win_newspaper: NewspaperPanel = %LevelWinNewsPaper;
@onready var level_lose_newspaper: LevelLoseNewspaperPanel = %LevelLoseNewsPaper;

func _ready() -> void:
	SignalBus.phase_started.connect(on_phase_started);
	SignalBus.phase_ended.connect(on_phase_ended);
	visible = false;
	level_win_newspaper.visible = false;
	level_lose_newspaper.visible = false;

func on_phase_started(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.CONCLUSION:
		score_label.text = "Congratulations ! You stole %s $" % GameState.get_current_level_state().total_stolen_value;
		visible = true;
		if GameState.get_current_level_state().level_won:
			level_win_newspaper.appear();
		else:
			level_lose_newspaper.appear();
	
func on_phase_ended(phase: LevelState.Phase) -> void:
	if phase == LevelState.Phase.CONCLUSION:
		visible = false;

func _on_next_level_button_pressed() -> void:
	GameState.get_current_level_state().set_phase(LevelState.Phase.COMPLETED);
