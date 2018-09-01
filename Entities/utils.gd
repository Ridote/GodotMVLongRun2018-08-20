extends Node


func newTimer(time, functionOwner, function):
	var timer = Timer.new()
	timer.set_wait_time(time)
	timer.one_shot = true
	timer.connect("timeout",functionOwner,function) 
	add_child(timer)
	timer.start()