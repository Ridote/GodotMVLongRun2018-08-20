extends KinematicBody2D

export var speed = 300

#Control
#Last direction to set up an iddle animation > 0 Up / 1 Down / 2 Right / 3 Left
enum LAST_DIRECTION{
 	UP,
 	DOWN,
	RIGHT,
	LEFT
}
var lastDirection = LAST_DIRECTION.UP

#Input
var skill1 = false
var skill2 = false
var skill3 = false
var skill4 = false
var skill5 = false
var moveRight = false
var moveLeft = false
var moveDown = false
var moveUp = false

func _physics_process(delta):
	readInput()
	move(delta)

func readInput():
	skill1 = Input.is_action_pressed("Skill1")
	skill2 = Input.is_action_pressed("Skill2")
	skill3 = Input.is_action_pressed("Skill3")
	skill4 = Input.is_action_pressed("Skill4")
	skill5 = Input.is_action_pressed("Skill5")
	moveRight = Input.is_action_pressed("ui_right")
	moveLeft = Input.is_action_pressed("ui_left")
	moveUp = Input.is_action_pressed("ui_up")
	moveDown = Input.is_action_pressed("ui_down")
	
func move(delta):
	var speedDirection = Vector2(int(moveRight) + (int(moveLeft)*-1), int(moveDown) + (int(moveUp)*-1)).normalized()
	animate(speedDirection)
	#move_and_collide <- needs delta
	#move_and_slide <- doesn't need delta
	move_and_slide(speedDirection*speed)

func animate(speedDirection):
	if speedDirection.x > 0.1:
		$AnimationPlayer.play("WalkRight")
		lastDirection = LAST_DIRECTION.RIGHT
	elif speedDirection.x < -0.1:
		$AnimationPlayer.play("WalkLeft")
		lastDirection = LAST_DIRECTION.LEFT
	elif speedDirection.y < -0.1:
		$AnimationPlayer.play("WalkUp")
		lastDirection = LAST_DIRECTION.UP
	elif speedDirection.y > 0.1:
		$AnimationPlayer.play("WalkDown")
		lastDirection = LAST_DIRECTION.DOWN
	else:
		if lastDirection == LAST_DIRECTION.UP:
			pass
		elif lastDirection == LAST_DIRECTION.DOWN:
			pass
		elif lastDirection == LAST_DIRECTION.LEFT:
			pass
		else:
			pass
			