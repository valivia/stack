class_name HighscoreService
extends Node

const SCORE_PATH = "user://score.save"

class Highscore:
	var name: String;
	var score: float;
	
	func _init(name: String, score: float):
		self.name = name;
		self.score = score;

static func score_from_height(height: float):
	return height / 10;

static func upsert_highscore(name: String, score: float) -> void:
	var highscores := get_highscore_dict();
	
	if name.length() <= 2:
		return;

	var current_score = highscores.get(name, 0.0);
	if score <= current_score: return;

	highscores[name] = snappedf(score, 0.1);

	var file := FileAccess.open(SCORE_PATH, FileAccess.WRITE);
	print("Set highscore for %s at %.1f" % [name, score]);
	file.store_string(JSON.stringify(highscores));
	file.close();

static func get_highscore_list() -> Array[Highscore]:
	var highscore_dict = get_highscore_dict();
	var highscores: Array[Highscore] = [];
	
	for key in highscore_dict.keys():
		highscores.append(Highscore.new(key, highscore_dict[key]))
		
	highscores.sort_custom(func(a,b): return a.score > b.score);
	return highscores;

static func get_highscore_dict() -> Dictionary:
	if not FileAccess.file_exists(SCORE_PATH):
		return {};

	var file := FileAccess.open(SCORE_PATH, FileAccess.READ);
	var data = file.get_as_text();
	if (data.length() <= 0): return {};
	data = JSON.parse_string(data);
	file.close();

	print(data);
	if typeof(data) == TYPE_DICTIONARY:
		return data;

	return {};
