extends Node2D

func open():
	$AnimationPlayer.play("Open")
func close():
	$AnimationPlayer.play("Close")