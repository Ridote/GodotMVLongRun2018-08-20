extends Node2D

export var length = 5
export var numPositions = 10

var positionManagerScript = preload("res://Entities/Enemies/Devourer/PositionRegister.gd")
var positionManager = null
var bodyClass = preload("res://Entities/Enemies/Devourer/Body.tscn")
var firstBody = null

var maxSpeed = 200
var minSpeed = 70
var speed = 100
var turn = 0.01
var maxTurn = 0.2

func _ready():
	$KinematicBody2D/Mouth/MouthAnimation.get_animation("MouthAnimation").set_loop(true)
	$ChangePositionTimer.start()
	$TurnUpdate.start()
	positionManager = positionManagerScript.new()
	positionManager.initPositions($KinematicBody2D.global_position, $KinematicBody2D.rotation, numPositions)
	firstBody = bodyClass.instance()
	firstBody.setBodies(self, null)
	
	firstBody.grow(length)
	
	add_child(firstBody)

func _physics_process(delta):
	var speedDirection = Vector2(sin($KinematicBody2D.rotation), -cos($KinematicBody2D.rotation)).normalized()
	var collision = $KinematicBody2D.move_and_collide(speedDirection*speed*delta)
	if collision != null:
		if collision.get_collider().has_method("receiveDamage"):
			collision.get_collider().receiveDamage(1,1)
		else:
			$KinematicBody2D.rotation += PI * rand_range(-1, 1)
	positionManager.updatePositions($KinematicBody2D.global_position, $KinematicBody2D.rotation)
	firstBody.update()

func _on_ChangePositionTimer_timeout():
	$KinematicBody2D.rotation += turn
	$ChangePositionTimer.start()

func _on_TurnUpdate_timeout():
	turn = rand_range(-maxTurn, maxTurn)
	$TurnUpdate.start()

func _on_Area2D_body_entered(body):
	body.receiveDamage(1,1)
