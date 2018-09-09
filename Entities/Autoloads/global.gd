extends Node


var questWelcome = preload("res://Entities/GUI/QuestWelcome.tscn")
var devourerBody = preload("res://Entities/Enemies/Devourer/Body.tscn")

func _ready():
	utils.newTimer(2, self, "showQuest", false)

func showQuest():
	#var q = questWelcome.instance()
	#get_tree().get_root().add_child(q)
	pass # Valiente porculo tu puta quest
	
func getDevourerBodyInstance():
	return devourerBody.instance()