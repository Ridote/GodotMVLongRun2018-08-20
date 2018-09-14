extends Node2D

var opened = false

func _ready():
	$StaticBody2D/AnimationPlayer.play("Closed")

func _process(delta):
	pass

func open():
	opened = true
	$StaticBody2D/AnimationPlayer.play("Opened")