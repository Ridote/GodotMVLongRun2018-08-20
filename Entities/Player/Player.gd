extends KinematicBody2D

export var speed = 300.0

#Control
var playingAnimation = ""
var damaged = false
var dmgInvulnTime = 2.0
var casting = false
var speedDirection = Vector2(0,0)
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

func _ready():
	$MovementAnimation.get_animation("WalkUp").set_loop(true)
	$MovementAnimation.get_animation("WalkLeft").set_loop(true)
	$MovementAnimation.get_animation("WalkRight").set_loop(true)
	$MovementAnimation.get_animation("WalkDown").set_loop(true)
	$Light2D/LightAnimation.get_animation("LightAttenuation").set_loop(true)
	$Sprite/DamagedAnimation.get_animation("Damaged").set_loop(true)

func _physics_process(delta):
	if !casting:
		readInput()
		move(delta)
		if skill1:
			$Casting.wait_time = 2
			$Casting.start()
			casting = true
			$Sword/SwordAnimation.play("Slash")
	animate(speedDirection)

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
	speedDirection = Vector2(int(moveRight) + (int(moveLeft)*-1), int(moveDown) + (int(moveUp)*-1)).normalized()
	#move_and_collide <- needs delta
	#move_and_slide <- doesn't need delta
	move_and_slide(speedDirection*speed)

func animate(speedDirection):
	var prevAnim = playingAnimation
	if speedDirection.x > 0.1:
		playingAnimation = "WalkRight"
	elif speedDirection.x < -0.1:
		playingAnimation = "WalkLeft"
	elif speedDirection.y < -0.1:
		playingAnimation = "WalkUp"
	elif speedDirection.y > 0.1:
		playingAnimation = "WalkDown"
	else:
		if playingAnimation in ["WalkRight", "IddleRight"]:
			playingAnimation = "IddleRight"
		elif playingAnimation in ["WalkLeft", "IddleLeft"]:
			playingAnimation = "IddleLeft"
		elif playingAnimation in ["WalkUp", "IddleUp"]:
			playingAnimation = "IddleUp"
		else:
			playingAnimation = "IddleDown"
	if prevAnim != playingAnimation:
		$MovementAnimation.play(playingAnimation)

func receiveDamage(fis, mag):
	if !damaged:
		damaged = true
		$Sprite/DamagedAnimation.play("Damaged")
		#Removing enemies and enemies projectiles from the collision mask
		collision_mask &= ~12
		$DamagedTimer.set_wait_time(dmgInvulnTime)
		$DamagedTimer.start()

func _on_Damaged_timeout():
	damaged = false
	$Sprite/DamagedAnimation.play("NotDamaged")
	#Writting back enemies and enemies projectiles into the collision mask
	collision_mask |= 12
