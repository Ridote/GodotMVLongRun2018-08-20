extends Node2D

#CHANGE THE DIRECTION FROM THE SOURCE!!!!!
var boomerangDirection = Vector2(3, 5).normalized()

var speed = 250
var maxSpeed = 600
var flyingSpeed = 0.35

var target = Vector2(0,0)
var turnBack = false

#Who throwed the boomerang, to whom it will go back
var source = null

func _ready():
	$AnimationPlayer.get_animation("spin").set_loop(true)
	$AnimationPlayer.play("spin")
	$Timer.start()
	$Timer.wait_time = flyingSpeed
	
func _physics_process(delta):
	if turnBack:
		if source:
			var sourcePos = source.getGlobalPosition()
			var desiredDirection = (sourcePos-$KBody2D.global_position).normalized()
			#If this fails it is because we assume boomerangDirection will always be a normalised vector
			boomerangDirection = Vector2(0.0*boomerangDirection + 1.0*desiredDirection)

		var collision = $KBody2D.move_and_collide(boomerangDirection*speed*delta)
		if collision:
			collision.get_collider().get_parent().onBoomerangBack()
			queue_free()
	else:
		var collision = $KBody2D.move_and_collide(boomerangDirection*speed*delta)
		
		speed *= 1.05
		if speed > maxSpeed:
			speed = maxSpeed

		#If we collide, no matter with what, we come back and try to apply damage
		if collision != null:
			#First we come back straight without colliding with anybody else
			$KBody2D.collision_mask = 0x1
			boomerangDirection = (source.getGlobalPosition()-$KBody2D.global_position).normalized()
			if collision.get_collider().has_method("receiveDamage"):
				collision.get_collider().receiveDamage(1.0,0.0)

func receiveDamage(fis, mag, sourcePos):
	turnBack = true

func setStartingPosition(pos):
	$KBody2D.global_position = pos

func _on_Timer_timeout():
	#Disable all collisions but the one with the player
	turnBack = true;
	$KBody2D.collision_mask = 0x1 #We will only collide now with the source to come back