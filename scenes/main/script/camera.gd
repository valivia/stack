extends Camera2D

@onready var marker:Marker2D = $Spawner

const MARKER_PADDING = 100;
const BASE_HEIGHT = -80.0;

func _ready():
	self.global_position.y = BASE_HEIGHT + 40;
	var tween = self.create_tween();
	tween.set_trans(Tween.TRANS_LINEAR);
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(
		self,
		"global_position",
		Vector2(self.global_position.x, BASE_HEIGHT),
		1
	);

func _process(_delta):
	var newPos = get_global_mouse_position();
	var viewport = get_camera_rect();
	var edgeLeft = viewport.position.x;
	var edgeRight = edgeLeft + viewport.size.x;
	newPos.x = clamp(newPos.x, edgeLeft + MARKER_PADDING, edgeRight - MARKER_PADDING); 
	marker.position.x = newPos.x;

func get_camera_rect() -> Rect2:
	var viewport_rect = get_viewport_rect()
	var size = viewport_rect.size / self.zoom
	return Rect2(self.position - size * 0.5, size)

func set_height(height: float):
	var tween = self.create_tween();
	tween.set_trans(Tween.TRANS_CUBIC);
	tween.set_ease(Tween.EASE_OUT);
	tween.tween_property(
		self,
		"global_position",
		Vector2(self.global_position.x, height),
		2
	);

func _on_height_changed(height):
	if (self.global_position.y < -height): return;
	self.set_height(-height);

func _on_game_restarted():
	self.global_position.y = BASE_HEIGHT;
	print(self.global_position.y)

#func _on_first_hit():
	#self.position_smoothing_speed = 10;
	#var tween = self.create_tween();
	#tween.set_trans(Tween.TRANS_ELASTIC);
	#tween.tween_property(
		#self,
		#"global_position",
		#Vector2(self.global_position.x, BASE_HEIGHT - 20),
		#Global.FIRST_HIT_START_DURATION
	#);
	#tween.tween_property(
		#self,
		#"global_position",
		#Vector2(self.global_position.x, BASE_HEIGHT),
		#Global.FIRST_HIT_END_DURATION
	#);
