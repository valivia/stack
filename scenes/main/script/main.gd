extends Node2D

@onready var tower:Node2D = %Tower;

signal height_changed(height: float);
signal game_restarted();
signal first_hit();

# State
var game_ended:bool = false;
var height = 0.0;

# Events
func _ready():
	get_tree().paused = false;
	print("Game started");

# Functions
func end_game(game_over := true):
	if (game_ended): return;
	game_ended = true;
	get_tree().paused = true;
	%Menu.show_game_over();
	self.save_score();
	print("Game ended");

func save_score():
	HighscoreService.upsert_highscore(
		Global.playerName,
		HighscoreService.score_from_height(self.height)
	);

func set_height(new_score: float):
	height = new_score;
	height_changed.emit(height);

func restart_game():
	self.save_score();
	%Menu.visible = false;
	game_ended = false;
	get_tree().paused = false;
	set_height(0);
	for child in tower.get_children():
		child.queue_free();
	game_restarted.emit();

# Signals
func on_box_settled(new_height: float):
	if new_height > height:
		set_height(new_height);
