extends Node2D

export var radius = 20
export var speed = 5

var player = null

func _ready():
	$KinematicBody2D/DiscoverArea.transform.scaled(Vector2(radius /2, radius / 2))
	$AnimationPlayer.play("alive")

func _process(delta):
	if player != null:
		var dest = player.getGlobalPosition()
		var dir = (dest - global_position).normalized()
	
func receiveDmg(fis, mag):
	print("Not implemented")