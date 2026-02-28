extends Marker2D

@onready var main = $"../.."
@onready var tower:Node2D = %Tower;

# Boxes
const BOX = preload("uid://b75eev621m460")
const RECTANGLE = preload("uid://clsie1pb08l4w")
const TRIANGLE = preload("uid://dguk4gspbrfn4")
const BOXES:Array[PackedScene] = [BOX, RECTANGLE, TRIANGLE];

var box:RigidBody2D;

func _ready():
	spawn_new_box();

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("drop"):
		drop_box();
	if event.is_action_pressed("rotate"):
		if box: box.rotation_degrees += 90;

func on_settled(height):
	spawn_new_box();

func spawn_new_box():
	if box != null: return;
	box = BOXES.pick_random().instantiate();
	self.add_child(box);
	box.settled.connect(main.on_box_settled);
	box.settled.connect(self.on_settled);

func drop_box():
	if box == null: return;
	box.reparent(tower, true);
	box.global_position = self.global_position;
	box.enable();
	box = null;


func _on_game_restarted():
	if !box: spawn_new_box();
