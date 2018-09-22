extends Node

enum DIRECTION {UP=0, DOWN=1, LEFT=2, RIGHT=3}
var DIRECTION_VECTOR = {DIRECTION.UP:Vector2(0,-1), DIRECTION.DOWN:Vector2(0,1), DIRECTION.LEFT:Vector2(-1,0), DIRECTION.RIGHT:Vector2(1,0)}

func oppositeDirection(direction):
	match direction:
		DIRECTION.UP:
			return DIRECTION.DOWN
		DIRECTION.DOWN:
			return DIRECTION.UP
		DIRECTION.LEFT:
			return DIRECTION.RIGHT
		DIRECTION.RIGHT:
			return DIRECTION.LEFT
			
func newTimer(time, functionOwner, function, repeat):
	var timer = Timer.new()
	timer.set_wait_time(time)
	if not repeat:
		timer.one_shot = true
	timer.connect("timeout",functionOwner,function) 
	add_child(timer)
	timer.start()