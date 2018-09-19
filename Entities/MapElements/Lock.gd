extends Node2D

func open():
	self.visible = false
	$StaticBody2D.collision_layer = 0