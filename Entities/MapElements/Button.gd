extends Node2D

var pression = 0
export var minPression = 1
export var linkedItems = []

func _process(delta):
	if pression > minPression:
		$AnimationPlayer.play("Pressed")
		get_parent().open()
	else:
		$AnimationPlayer.play("NotPressed")
		get_parent().close()

func _on_Area2D_body_entered(body):
	pression += 1

func _on_Area2D_body_shape_entered(body_id, body, body_shape, area_shape):
	pression += 1

func _on_Area2D_body_exited(body):
	pression -= 1

func _on_Area2D_body_shape_exited(body_id, body, body_shape, area_shape):
	pression -= 1