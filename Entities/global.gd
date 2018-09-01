extends Node

var questWelcome = preload("res://Entities/GUI/QuestWelcome.tscn")

export var playerHP = 0

func _ready():
	newTimer(2, self, "showQuest")

func showQuest():
	var q = questWelcome.instance()
	get_tree().get_root().add_child(q)
	
	
func newTimer(time, functionOwner, function):
	var timer = Timer.new()
	timer.set_wait_time(time)
	timer.one_shot = true
	timer.connect("timeout",self,function) 
	add_child(timer)
	timer.start()