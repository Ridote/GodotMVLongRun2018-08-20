extends Node2D

export var length = 5
export var numPositions = 5

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


func _ready():
	$KinematicBody2D/Mouth/MouthAnimation.get_animation("MouthAnimation").set_loop(true)
	positionManager = positionManagerScript.new()
	positionManager.initPositions($KinematicBody2D.global_position, $KinematicBody2D.global_rotation, numPositions)
	firstBody = bodyClass.instance()
	firstBody.setBodies(self, null)
	firstBody.grow(length)
	add_child(firstBody)

func _physics_process(delta):
	if path.size() > 0:
		$KinematicBody2D.look_at(path[0])
		$KinematicBody2D.rotation += 90
		if $KinematicBody2D.global_position.distance_to(path[0]) < 2:
			path.remove(0)
	else:
		self.get_parent().update_path()
	
	var speedDirection = Vector2(sin($KinematicBody2D.rotation), -cos($KinematicBody2D.rotation)).normalized()
	var collision = $KinematicBody2D.move_and_collide(speedDirection*speed*delta)
	if collision != null:
		if collision.get_collider().has_method("receiveDamage"):
			collision.get_collider().receiveDamage(1,1)
	positionManager.updatePositions($KinematicBody2D.global_position, $KinematicBody2D.global_rotation)
	firstBody.update()


func _on_Area2D_body_entered(body):
	body.receiveDamage(1,1)
