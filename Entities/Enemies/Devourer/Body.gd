extends Area2D

var previous = null
var next = null
var positionManagerScript = preload("res://Entities/Enemies/Devourer/PositionRegister.gd")
var bodyFactory = preload("res://Entities/Enemies/Devourer/Body.tscn")
var positionManager = null

func setBodies(previous, next):
	self.previous = previous
	self.next = next
	positionManager = positionManagerScript.new()
	positionManager.initPositions(Vector2(0,1000000), 0, previous.positionManager.getNumPositions())
	

func _process(delta):
	pass

func update():
	if next == null:
		set_body(false)
	else:
		set_body(true)
	global_position = previous.positionManager.getPosition(0)
	global_rotation = previous.positionManager.getRotation(0)
	positionManager.updatePositions(global_position, global_rotation)
	if next != null:
		next.update()

func set_body(body = true):
	if body:
		$Sprite.frame = 1
	else:
		$Sprite.frame = 2
func grow(length):
	next = bodyFactory.instance()
	add_child(next)
	next.setBodies(self, null)
	if length > 0:
		next.grow(length-1)