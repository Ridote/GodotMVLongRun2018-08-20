var positions = []

func _ready():
	pass

func updatePositions(global_position, rotation):
	for i in range(0, positions.size()-1):
		positions[i] = positions[i+1]
	positions[positions.size()-1] = [global_position, rotation]

func initPositions(global_position, rotation, numPositions = 5):
	for i in range(0, numPositions):
		positions.push_back([global_position, rotation])

func getPosition(ind):
	return positions[ind][0]

func getRotation(ind):
	return positions[ind][1]

func getNumPositions():
	return positions.size()