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
	$Area2D.position += utils.DIRECTION_VECTOR[direction]*speed*delta

func _on_Area2D_body_entered(body):
	var collider = body.get_parent()
	if collider.has_method("receiveDamage"):
		collider.receiveDamage(0,0, $Area2D.global_position)
	match collider.get_name():
		"Player","Map", "EvilBlock":
			direction = utils.oppositeDirection(direction)

func _on_Area2D_area_shape_entered(area_id, area, area_shape, self_shape):
	match area.get_parent().get_name().substr(0,9):
		"EvilBlock":
			direction = utils.oppositeDirection(direction)