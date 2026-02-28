extends Control

@onready var leaderboard = $Leaderboard;
@onready var highscoreList = $Leaderboard/Highscores;
@onready var playerName = $Main/VBoxContainer/LineEdit;
@onready var quit = $Main/VBoxContainer/quit;

const GAME_SCENE = preload("uid://dasro6j817sjn")

func _ready():
	get_tree().paused = false;
	load_highscores();
	if OS.has_feature("web"):
		quit.visible = false;

func load_highscores():
	var highscores := HighscoreService.get_highscore_list();
	
	if highscores.size() == 0:
		return;
	else:
		leaderboard.visible = true;

	var rank = 0;
	var players = "";
	for player in highscores:
		rank += 1;
		players += "%s: %.1f\n" % [player.name, player.score];
	highscoreList.text = "[ol]%s[/ol]" % players

func _on_start_pressed():
	Global.playerName = playerName.text;
	get_tree().change_scene_to_packed(GAME_SCENE);


func _on_quit_pressed():
	get_tree().quit();
