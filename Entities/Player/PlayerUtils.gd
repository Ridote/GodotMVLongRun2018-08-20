extends Node2D

static func animate(velocity, desiredDirection, lastAnimation, animationPlayer):
	#if we are moving fast, we are running
	if (abs(velocity.x) > 0.1) or (abs(velocity.y) > 0.1):
		match desiredDirection:
			utils.DIRECTION.UP:
				if lastAnimation != "RunningUp":
					return "RunningUp"
			utils.DIRECTION.DOWN:
				if lastAnimation != "RunningDown":
					return "RunningDown"
			utils.DIRECTION.LEFT:
				if lastAnimation != "RunningLeft":
					return "RunningLeft"
			utils.DIRECTION.RIGHT:
				if lastAnimation != "RunningRight":
					return "RunningRight"
			_:
				print("Unknown error on player animate")
				error()
	#if not, we are idle
	else:
		match desiredDirection:
			utils.DIRECTION.UP:
				return "IdleUp"
			utils.DIRECTION.DOWN:
				return "IdleDown"
			utils.DIRECTION.LEFT:
				return "IdleLeft"
			utils.DIRECTION.RIGHT:
				return "IdleRight"
			_:
				print("Unknown error on player animate")
				error()
	return lastAnimation