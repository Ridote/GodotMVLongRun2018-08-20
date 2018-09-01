extends Navigation2D



func update_path():
	var start = $DevourerHead.position
	var end = $Player.position
	$DevourerHead.get_node("head").path = self.get_simple_path(start, end)
	$TurnUpdate.start()