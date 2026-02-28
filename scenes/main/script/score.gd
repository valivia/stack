extends Label

var tween:Tween;

const BASE_POSITION = 0;

func _ready():
	update_label(0.0);

func _on_height_changed(height):
	update_label(height);

func update_label(height: float):
	self.text = "%.1f M" % HighscoreService.score_from_height(height);
	var new_pos = -height - 8;
	tween = self.create_tween();
	tween.set_trans(Tween.TRANS_CUBIC);
	tween.tween_property(
		self,
		"global_position",
		Vector2(self.global_position.x, new_pos),
		0.5
	);
