extends Node2D

func _on_Area2D_body_entered(body):
	var collider = body.get_parent()
	if(collider.has_method("addKeys")):
		collider.addKeys(1)
		queue_free()
