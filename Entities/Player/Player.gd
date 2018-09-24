extends Node2D

var boomerangFactory = load("res://Entities/Skills/Boomerang.tscn")
var playerUtils = load("res://Entities/Player/PlayerUtils.gd")

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

var desiredDirection = utils.DIRECTION.DOWN
var moveDirection = Vector2(0,0)

var lastAnimation = null
var externalForce = Vector2(0,0)

func _ready():
	print("Player:\nFlechas para moverte\nQ para atacar\nE para usar el boomerang\nSpacebar para intentar interaccionar con el medio (cofres)")

func _physics_process(delta):
	if !casting:
		move(delta)
		#Important to update the interaction now before process skills
		updateInteraction()
		processSkills()
	else:
		$Rigid.linear_velocity = Vector2(0,0)
	
	#Animations are now under another script
	var nextAnimation = playerUtils.animate($Rigid.linear_velocity, desiredDirection, lastAnimation, $Rigid/Sprite/AnimationPlayer)
	if nextAnimation != lastAnimation:
		lastAnimation = nextAnimation
		$Rigid/Sprite/AnimationPlayer.play(nextAnimation)
	
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
			desiredDirection = utils.DIRECTION.RIGHT
		elif moveDirection.x < -0.1:
			desiredDirection = utils.DIRECTION.LEFT
	elif (abs(moveDirection.y) - abs(moveDirection.x)) > 0.1:
		if moveDirection.y < -0.1:
			desiredDirection = utils.DIRECTION.UP
		elif moveDirection.y > 0.1:
			desiredDirection = utils.DIRECTION.DOWN
	
	#Clamp to max speed
	var linVel = $Rigid.linear_velocity
	if((abs(linVel.x) + abs(linVel.y))> maxSpeed):
		$Rigid.set_linear_velocity(moveDirection.normalized()*maxSpeed)
	
	$Rigid.apply_impulse(Vector2(0,0), externalForce*delta*acceleration)
	externalForce *= 0.9

func updateInteraction():
	match desiredDirection:
		utils.DIRECTION.UP:
			$Rigid/Interaction.position = Vector2(0, -16)
		utils.DIRECTION.DOWN:
			$Rigid/Interaction.position = Vector2(0, 16)
		utils.DIRECTION.LEFT:
			$Rigid/Interaction.position = Vector2(-16, 0)
		utils.DIRECTION.RIGHT:
			$Rigid/Interaction.position = Vector2(16, 0)

func processSkills():
	if skill1:
		match desiredDirection:
			utils.DIRECTION.UP:
				$Rigid/Sword.rotation = 0
				$Rigid/Sword.position.x = 0
				$Rigid/Sword.position.y = -16
			utils.DIRECTION.DOWN:
				$Rigid/Sword.rotation = PI
				$Rigid/Sword.position.x = 0
				$Rigid/Sword.position.y = 16
			utils.DIRECTION.LEFT:
				$Rigid/Sword.rotation = -PI/2
				$Rigid/Sword.position.x = -16
				$Rigid/Sword.position.y = 0
			utils.DIRECTION.RIGHT:
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
			utils.DIRECTION.UP:
				boomerang.setStartingPosition($Rigid.global_position + Vector2(0.0, -8.0))
				boomerangDirection.y = -1
			utils.DIRECTION.DOWN:
				boomerang.setStartingPosition($Rigid.global_position + Vector2(0.0, 8.0))
				boomerangDirection.y = 1
			utils.DIRECTION.LEFT:
				boomerang.setStartingPosition($Rigid.global_position + Vector2(-8.0, 0.0))
				boomerangDirection.x = -1
			utils.DIRECTION.RIGHT:
				boomerang.setStartingPosition($Rigid.global_position + Vector2(8.0, 0.0))
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

func addKeys(num):
	state.player_keys += num
	
func onBoomerangBack():
	boomerangOnFlight = false

func _on_DamagedTimer_timeout():
	damaged = false
	#Writting back enemies and enemies projectiles into the collision mask
	$Rigid.collision_mask |= 12


func _on_Casting_timeout():
	casting = false


func _on_Sword_body_entered(body):
	body.get_parent().receiveDmg(1,0)


func _on_Interaction_body_entered(body):
	$Rigid/Interaction.collision_mask = 0
	match body.get_parent().get_name():
		"SmallChest":
			if(state.player_keys > 0):
				body.get_parent().open()
				addKeys(-1)
		"Door":
			body.get_parent().open()
		"Lock":
			if(state.player_keys > 0):
				body.get_parent().open()
				addKeys(-1)