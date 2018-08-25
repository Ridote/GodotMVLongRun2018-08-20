extends Navigation2D


func update_path():
	var start = $DevourerHead.get_node("KinematicBody2D/Mouth").global_position
	var end = $Player.global_position
	print("path", self.get_simple_path(start, end))
	$DevourerHead.path = self.get_simple_path(start, end)