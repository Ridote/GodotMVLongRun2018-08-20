extends Node2D

var maxSpeed = 200
var minSpeed = 70
var speed = 100
var turn = 0.01
var maxTurn = 0.2

func _ready():
	$KinematicBody2D/Mouth/MouthAnimation.get_animation("MouthAnimation").set_loop(true)
	$ChangePositionTimer.start()
	$TurnUpdate.start()

func _physics_process(delta):
	var speedDirection = Vector2(sin($KinematicBody2D.rotation), -cos($KinematicBody2D.rotation)).normalized()
	var collision = $KinematicBody2D.move_and_collide(speedDirection*speed*delta)
	if collision != null:
		if collision.get_collider().has_method("receiveDamage"):
			collision.get_collider().receiveDamage(1,1)
		else:
			$KinematicBody2D.rotation += PI * rand_range(-1, 1)


func _on_ChangePositionTimer_timeout():
	$KinematicBody2D.rotation += turn
	$ChangePositionTimer.start()

func _on_TurnUpdate_timeout():
	turn = rand_range(-maxTurn, maxTurn)
	$TurnUpdate.start()

func _on_Area2D_body_entered(body):
	body.receiveDamage(1,1)
