extends Node2D

var direction = Vector2(0,0)
var speed = 500

func _ready():
	$AnimationPlayer.get_animation("spin").set_loop(true)
	$AnimationPlayer.play("spin")
	
func _physics_process(delta):
	direction = Vector2(3, 5)
	
	$KBody2D.move_and_collide(direction.normalized()*speed*delta)
