extends CanvasLayer

@onready var main = $".."
@export var title_label:Label;
@export var score_label:Label;

# Functions
func toggle_pause():
	if main.game_ended == true: return;
	title_label.text = "Game Paused";
	var is_paused = !get_tree().paused;
	get_tree().paused = is_paused;
	self.visible = is_paused;
	
func show_game_over():
	title_label.text = "Game Over";
	self.visible = true;

# Events
func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"): toggle_pause();

#Signals
func _on_main_menu_pressed():
	main.save_score();
	get_tree().change_scene_to_file("res://scenes/start/start.tscn")

func _on_restart_pressed():
	main.restart_game();

func _on_height_changed(height):
	score_label.text = "%.1f" % HighscoreService.score_from_height(height);
