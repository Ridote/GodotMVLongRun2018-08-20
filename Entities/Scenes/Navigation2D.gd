extends Navigation2D


func update_path(entityStart, entityEnd):
	var start = entityStart.global_position
	var end = entityEnd.global_position
	return self.get_simple_path(start, end)