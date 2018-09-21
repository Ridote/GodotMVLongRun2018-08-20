extends Node2D

enum DIRECTION {UP=0, DOWN=1, LEFT=2, RIGHT=3}

static func animate(velocity, desiredDirection, lastAnimation, animationPlayer):
	#if we are moving fast, we are running
	if (abs(velocity.x) > 0.1) or (abs(velocity.y) > 0.1):
		match desiredDirection:
			DIRECTION.UP:
				if lastAnimation != "RunningUp":
					return "RunningUp"
			DIRECTION.DOWN:
				if lastAnimation != "RunningDown":
					return "RunningDown"
			DIRECTION.LEFT:
				if lastAnimation != "RunningLeft":
					return "RunningLeft"
			DIRECTION.RIGHT:
				if lastAnimation != "RunningRight":
					return "RunningRight"
			_:
				print("Unknown error on player animate")
				error()
	#if not, we are idle
	else:
		match desiredDirection:
			DIRECTION.UP:
				return "IdleUp"
			DIRECTION.DOWN:
				return "IdleDown"
			DIRECTION.LEFT:
				return "IdleLeft"
			DIRECTION.RIGHT:
				return "IdleRight"
			_:
				print("Unknown error on player animate")
				error()
	return lastAnimation