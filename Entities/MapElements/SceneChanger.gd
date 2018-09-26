extends Node2D

export var scene = "res://Maps/TestMap.tscn"
export(Vector2) var location = Vector2(0,0)

func _on_Area2D_body_entered(body):
	utils.get_tree().get_root().get_node("Main").changeScene(scene, location)
