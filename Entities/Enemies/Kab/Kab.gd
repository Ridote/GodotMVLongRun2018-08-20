extends Node2D

export var radius = 20
export var speed = 50

var player = null
var external_force = Vector2(0,0)
var impulse = 5

var original_layer = null

func _ready():
	$KinematicBody2D/DiscoverArea.scale*=radius
	$AnimationPlayer.play("alive")

func _process(delta):
	if player != null:
		var dir = (player.getGlobalPosition()-$KinematicBody2D.global_position).normalized()
		$KinematicBody2D.move_and_slide(dir*speed)
		#We need to check the collisions to see if it collided with the character
		for i in range($KinematicBody2D.get_slide_count()):
			if $KinematicBody2D.get_slide_collision(i).get_collider().get_parent().get_name() == "Player":
				player.receiveDamage(1,0,$KinematicBody2D.global_position)
	
func receiveDmg(fis, mag, from = null):
	external_force += (from - $KinematicBody2D.global_position).normalized()*impulse
	$Invulnerable.start()
	
	original_layer = $KinematicBody2D.collision_layer
	$KinematicBody2D.collision_layer = 0
func _on_Invulnerable_timeout():
	$KinematicBody2D.collision_layer = original_layer
	
func _on_DiscoverArea_body_entered(body):
	player = body.get_parent()

func _on_DiscoverArea_body_exited(body):
	player = null
