extends Node2D

#Conf
export var maxSpeed = 200
export var acceleration = 500
export var dmgInvulnTime = 1

#Inputs
var skill1 = null
var skill2 = null
var skill3 = null
var skill4 = null
var skill5 = null
var moveRight = null
var moveLeft = null
var moveUp = null
var moveDown = null

#Control
var damaged = false
enum DIRECTION {UP, DOWN, LEFT, RIGHT}
var desiredDirection = DIRECTION.DOWN
var lastAnimation = null

func _ready():
	pass

func _physics_process(delta):
	readInput()
	move(delta)
	animate()
	
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
	var moveDirection = Vector2(0,0)
	if moveRight:
		moveDirection.x = 1
	elif moveLeft:
		moveDirection.x = -1
	else:
		$Rigid.linear_velocity.x /= 2
	if moveUp:
		moveDirection.y = -1
	elif moveDown:
		moveDirection.y = 1
	else:
		$Rigid.linear_velocity.y /= 2
	$Rigid.apply_impulse(Vector2(0,0), moveDirection.normalized()*delta*acceleration)
	
	#Get the direction we want to move to update the sprite despite of the real velocity
	if (abs(moveDirection.x) - abs(moveDirection.y)) > 0.1:
		if moveDirection.x > 0.1:
			desiredDirection = DIRECTION.RIGHT
		elif moveDirection.x < -0.1:
			desiredDirection = DIRECTION.LEFT
	elif (abs(moveDirection.y) - abs(moveDirection.x)) > 0.1:
		if moveDirection.y < -0.1:
			desiredDirection = DIRECTION.UP
		elif moveDirection.y > 0.1:
			desiredDirection = DIRECTION.DOWN
	
	#Clamp to max speed
	var linVel = $Rigid.linear_velocity
	if((abs(linVel.x) + abs(linVel.y))> maxSpeed):
		$Rigid.set_linear_velocity(moveDirection.normalized()*maxSpeed)

func animate():
	#if we are moving fast, we are running
	if (abs($Rigid.linear_velocity.x) > 0.1) or (abs($Rigid.linear_velocity.y) > 0.1):
		match desiredDirection:
			DIRECTION.UP:
				if lastAnimation != "RunningUp":
					$Rigid/Sprite/AnimationPlayer.play("RunningUp")
					lastAnimation = "RunningUp"
			DIRECTION.DOWN:
				if lastAnimation != "RunningDown":
					$Rigid/Sprite/AnimationPlayer.play("RunningDown")
					lastAnimation = "RunningDown"
			DIRECTION.LEFT:
				if lastAnimation != "RunningLeft":
					$Rigid/Sprite/AnimationPlayer.play("RunningLeft")
					lastAnimation = "RunningLeft"
			DIRECTION.RIGHT:
				if lastAnimation != "RunningRight":
					$Rigid/Sprite/AnimationPlayer.play("RunningRight")
					lastAnimation = "RunningRight"
			_:
				print("Unknown error on player animate")
				error()
	#if not, we are idle
	else:
		match desiredDirection:
			DIRECTION.UP:
				$Rigid/Sprite/AnimationPlayer.play("IdleUp")
				lastAnimation = "IdleUp"
			DIRECTION.DOWN:
				$Rigid/Sprite/AnimationPlayer.play("IdleDown")
				lastAnimation = "IdleDown"
			DIRECTION.LEFT:
				$Rigid/Sprite/AnimationPlayer.play("IdleLeft")
				lastAnimation = "IdleLeft"
			DIRECTION.RIGHT:
				$Rigid/Sprite/AnimationPlayer.play("IdleRight")
				lastAnimation = "IdleRight"
			_:
				print("Unknown error on player animate")
				error()

func receiveDamage(fis, mag):
	if !damaged:
		damaged = true
		#$Sprite/DamagedAnimation.play("Damaged")
		#Removing enemies and enemies projectiles from the collision mask
		$Rigid.collision_mask &= ~12
		$DamagedTimer.set_wait_time(dmgInvulnTime)
		$DamagedTimer.start()

func _on_DamagedTimer_timeout():
	damaged = false
	#$Sprite/DamagedAnimation.play("NotDamaged")
	#Writting back enemies and enemies projectiles into the collision mask
	$Rigid.collision_mask |= 12
