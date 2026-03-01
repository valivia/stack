extends Area2D

func _on_body_entered(body: Node2D):
	if body.has_method("on_enter_freeze_zone"):
		body.on_enter_freeze_zone();
