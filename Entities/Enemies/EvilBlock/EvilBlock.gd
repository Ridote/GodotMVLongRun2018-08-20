extends Node2D


export var moveDirection = "Down"

var direction = utils.DIRECTION.DOWN
var speed = 150
var impulse = 20

func _ready():
	match moveDirection.to_lower():
		"down":
			direction = utils.DIRECTION.DOWN
		"up":
			direction = utils.DIRECTION.UP
		"left":
			direction = utils.DIRECTION.LEFT
		"right":
			direction = utils.DIRECTION.RIGHT
		_:
			direction = utils.DIRECTION.DOWN

func _physics_process(delta):
	var collision = $Kinematic2D.move_and_collide(utils.DIRECTION_VECTOR[direction]*speed*delta)
	if collision:
		var collider = collision.get_collider().get_parent()
		if collider.has_method("receiveDamage"):
			collider.receiveDamage(0,0, $Kinematic2D.global_position)
		
		direction = utils.oppositeDirection(direction)

func receiveDmg(fis,mag):
	pass