extends Node

var questWelcome = preload("res://Entities/GUI/QuestWelcome.tscn")

export var playerHP = 0

func _ready():
	utils.newTimer(2, self, "showQuest", false)

func showQuest():
	var q = questWelcome.instance()
	get_tree().get_root().add_child(q)
	