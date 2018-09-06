extends "res://Entities/Enemies/Enemy.gd"

export var length = 5
export var numPositions = 5
#How fast body parts need to be updated to not break the chain
export var partsSpeed = 10

export var hitRecoveryTime = 1.5

var positionManagerScript = preload("res://Entities/Enemies/Devourer/PositionRegister.gd")
var positionManager = null
var bodyClass = preload("res://Entities/Enemies/Devourer/Body.tscn")
var firstBody = null

export var path = []

var maxSpeed = 200
var minSpeed = 70
var speed = 150
var turn = 0.01
var maxTurn = 0.2

var player = null

var hitRecovery = false


func _ready():
	$KinematicBody2D/Mouth/MouthAnimation.get_animation("MouthAnimation").set_loop(true)
	positionManager = positionManagerScript.new()
	positionManager.initPositions($KinematicBody2D.global_position, $KinematicBody2D.global_rotation, numPositions, partsSpeed)
	firstBody = bodyClass.instance()
	firstBody.setBodies(self, null)
	firstBody.grow(length)
	add_child(firstBody)
	
	if(self.get_parent().get_node("Player") != null):
		player = self.get_parent().get_node("Player").get_node("Rigid")
		$Reroute.start()

func _physics_process(delta):
	if !hitRecovery:
		if path.size() > 0:
			$KinematicBody2D.look_at(path[0])
			# random 0.5 degree
			$KinematicBody2D.rotation += 89.5
			if $KinematicBody2D.global_position.distance_to(path[0]) < 2:
				path.remove(0)
		else:
			if player:
				path = self.get_parent().update_path($KinematicBody2D/Mouth, player)
		
		var speedDirection = Vector2(sin($KinematicBody2D.rotation), -cos($KinematicBody2D.rotation)).normalized()
		var collision = $KinematicBody2D.move_and_collide(speedDirection*speed*delta)
		if collision != null:
			if collision.get_collider().has_method("receiveDamage"):
				collision.get_collider().receiveDamage(15,1)
	positionManager.updatePositions($KinematicBody2D.global_position, $KinematicBody2D.global_rotation)
	firstBody.update()

func receiveDmg(fis, mag):
	hitRecovery = true
	$HitRecovery.wait_time = hitRecoveryTime
	$HitRecovery.start()

func _on_Area2D_body_entered(body):
	body.get_parent().receiveDamage(15,1, $KinematicBody2D.global_position)

func _on_Reroute_timeout():
	path = self.get_parent().update_path($KinematicBody2D/Mouth, player)
	$Reroute.start()

func _on_HitRecovery_timeout():
	hitRecovery = false
