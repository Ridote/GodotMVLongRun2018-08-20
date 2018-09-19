extends Node2D

var boomerangFactory = load("res://Entities/Skills/Boomerang.tscn")

#Conf
export var maxSpeed = 200
export var acceleration = 500
export var dmgInvulnTime = 1

#Inputs
var skill1 = null
var skill2 = null
var skill3 = null
var skill4 = null
var interact = null
var moveRight = null
var moveLeft = null
var moveUp = null
var moveDown = null

#Control
var damaged = false
var casting = false
var boomerangOnFlight = false


enum DIRECTION {UP, DOWN, LEFT, RIGHT}
var desiredDirection = DIRECTION.DOWN
var moveDirection = Vector2(0,0)

var lastAnimation = null
var externalForce = Vector2(0,0)

func _ready():
	pass

func _physics_process(delta):
	if !casting:
		move(delta)
		#Important to update the interaction now before process skills
		updateInteraction()
		processSkills()
	else:
		$Rigid.linear_velocity = Vector2(0,0)
	animate()
	
func _input(event):
	skill1 = Input.is_action_pressed("Skill1")
	skill2 = Input.is_action_pressed("Skill2")
	skill3 = Input.is_action_pressed("Skill3")
	skill4 = Input.is_action_pressed("Skill4")
	if !interact:
		interact = Input.is_action_just_pressed("Interact")
	if Input.is_action_just_released("Interact"):
		$Rigid/Interaction.collision_mask = 0
		interact = false
	moveRight = Input.is_action_pressed("ui_right")
	moveLeft = Input.is_action_pressed("ui_left")
	moveUp = Input.is_action_pressed("ui_up")
	moveDown = Input.is_action_pressed("ui_down")

	
func move(delta):
	if moveRight:
		moveDirection.x = 1
	elif moveLeft:
		moveDirection.x = -1
	else:
		moveDirection.x = 0
		$Rigid.linear_velocity.x /= 2
	if moveUp:
		moveDirection.y = -1
	elif moveDown:
		moveDirection.y = 1
	else:
		moveDirection.y = 0
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
	
	$Rigid.apply_impulse(Vector2(0,0), externalForce*delta*acceleration)
	externalForce *= 0.9

func updateInteraction():
	match desiredDirection:
		DIRECTION.UP:
			$Rigid/Interaction.position = Vector2(0, -16)
		DIRECTION.DOWN:
			$Rigid/Interaction.position = Vector2(0, 16)
		DIRECTION.LEFT:
			$Rigid/Interaction.position = Vector2(-16, 0)
		DIRECTION.RIGHT:
			$Rigid/Interaction.position = Vector2(16, 0)
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

func processSkills():
	if skill1:
		match desiredDirection:
			DIRECTION.UP:
				$Rigid/Sword.rotation = 0
				$Rigid/Sword.position.x = 0
				$Rigid/Sword.position.y = -16
			DIRECTION.DOWN:
				$Rigid/Sword.rotation = PI
				$Rigid/Sword.position.x = 0
				$Rigid/Sword.position.y = 16
			DIRECTION.LEFT:
				$Rigid/Sword.rotation = -PI/2
				$Rigid/Sword.position.x = -16
				$Rigid/Sword.position.y = 0
			DIRECTION.RIGHT:
				$Rigid/Sword.rotation = PI/2
				$Rigid/Sword.position.x = 16
				$Rigid/Sword.position.y = 0
				
			_:
				print("Unknown error on player animate")
				error()
		$Rigid/Sword/SwordAnimation.play("DashDown")
		casting = true
		$Casting.wait_time = 0.3
		$Casting.start()
		return
		
	if skill2 && !boomerangOnFlight:
		var boomerangDirection = Vector2(0,0)
		var boomerang = boomerangFactory.instance()
		self.add_child(boomerang)
		#If we are not moving we'll use desired direction
		match desiredDirection:
			DIRECTION.UP:
				boomerang.setStartingPosition($Rigid.global_position + Vector2(0.0, -16.0))
				boomerangDirection.y = -1
			DIRECTION.DOWN:
				boomerang.setStartingPosition($Rigid.global_position + Vector2(0.0, 16.0))
				boomerangDirection.y = 1
			DIRECTION.LEFT:
				boomerang.setStartingPosition($Rigid.global_position + Vector2(-16.0, 0.0))
				boomerangDirection.x = -1
			DIRECTION.RIGHT:
				boomerang.setStartingPosition($Rigid.global_position + Vector2(16.0, 0.0))
				boomerangDirection.x = 1
		if(moveDirection.x != 0 && moveDirection.y != 0):
			boomerangDirection = moveDirection.normalized()
		boomerang.source = self
		boomerang.boomerangDirection = boomerangDirection
		boomerangOnFlight = true
		
	if interact:
		$Rigid/Interaction.collision_mask = 128 # Interaction collision mask
		
func getGlobalPosition():
	return $Rigid.global_position
func receiveDamage(fis, mag, from):
	if !damaged:
		damaged = true
		#$Sprite/DamagedAnimation.play("Damaged")
		#Removing enemies and enemies projectiles from the collision mask
		$Rigid.collision_mask &= ~12
		$DamagedTimer.set_wait_time(dmgInvulnTime)
		$DamagedTimer.start()
		# I don't know why but "fis" is always 1
		state.player_hp = state.player_hp - 10
		externalForce += ($Rigid.global_position - from).normalized()*50
	if state.player_hp == 0:
		queue_free()

func onBoomerangBack():
	boomerangOnFlight = false

func _on_DamagedTimer_timeout():
	damaged = false
	#Writting back enemies and enemies projectiles into the collision mask
	$Rigid.collision_mask |= 12


func _on_Casting_timeout():
	casting = false


func _on_Sword_body_entered(body):
	print(body.get_parent().get_name())
	body.get_parent().receiveDmg(1,0)


func _on_Interaction_body_entered(body):
	$Rigid/Interaction.collision_mask = 0
	match body.get_parent().get_name():
		"SmallChest":
			body.get_parent().open()
		"Door":
			body.get_parent().open()
		"Lock":
			body.get_parent().open()