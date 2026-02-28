extends Area2D

@onready var main = $"..";

func _ready():
	self.body_entered.connect(on_area_enter);

func on_area_enter(body: RigidBody2D):
	body.queue_free();
	main.end_game();
