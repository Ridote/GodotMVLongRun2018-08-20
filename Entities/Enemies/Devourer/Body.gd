extends "res://Entities/Enemies/Enemy.gd"

var previous = null
var next = null
var positionManagerScript = preload("res://Entities/Enemies/Devourer/PositionRegister.gd")
var positionManager = null

func setBodies(previous, next):
	self.previous = previous
	self.next = next
	positionManager = positionManagerScript.new()
	positionManager.initPositions(Vector2(0,1000000), 0, previous.positionManager.getNumPositions(), previous.positionManager.speed)
	

func _process(delta):
	pass

func update():
	if next == null:
		set_body(false)
	else:
		set_body(true)
	global_position = previous.positionManager.getPosition()
	global_rotation = previous.positionManager.getRotation()
	positionManager.updatePositions(global_position, global_rotation)
	if next != null:
		next.update()

func set_body(body = true):
	if body:
		$BodyArea2D/Sprite.frame = 1
	else:
		$BodyArea2D/Sprite.frame = 2
func grow(length):
	
	next = global.getDevourerBodyInstance()
	add_child(next)
	next.setBodies(self, null)
	if length > 0:
		next.grow(length-1)

func _on_BodyArea2D_body_entered(body):
	body.get_parent().receiveDamage(1,1, $BodyArea2D.global_position)
