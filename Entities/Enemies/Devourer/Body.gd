extends Area2D

var previous = null
var next = null
var positionManagerScript = preload("res://Entities/Enemies/Devourer/PositionRegister.gd")
var positionManager = null

#Is this nasty? is there any other way to do it?
var bodyClass = preload("res://Entities/Enemies/Devourer/Body.tscn")

func setBodies(previous, next):
	self.previous = previous
	self.next = next
	positionManager = positionManagerScript.new()
	positionManager.initPositions(Vector2(0,0), 0, previous.positionManager.getNumPositions())
	

func _process(delta):
	pass

func update():
	if next == null:
		set_body(false)
	else:
		set_body(true)
	global_position = previous.positionManager.getPosition(0)
	rotation = previous.positionManager.getRotation(0)
	positionManager.updatePositions(global_position, rotation)
	if next != null:
		next.update()

func set_body(body = true):
	if body:
		$Sprite.frame = 1
	else:
		$Sprite.frame = 2
func grow(length):
	next = bodyClass.instance()
	add_child(next)
	next.setBodies(self, null)
	if length > 0:
		next.grow(length-1)