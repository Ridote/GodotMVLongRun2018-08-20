var positions = []
var speed = 0

func _ready():
	pass

func updatePositions(global_position, rotation):
	
	for i in range(0, positions.size()-1):
		positions[i] = positions[i+1]
	positions[positions.size()-1] = [global_position, rotation]

func initPositions(global_position, rotation, numPositions = 5, speed = 0):
	if speed > numPositions:
		self.speed = numPositions-1
	else:
		self.speed = speed
	for i in range(0, numPositions):
		positions.push_back([global_position, rotation])

func getPosition():
	return positions[speed][0]

func getRotation():
	return positions[speed][1]

func getNumPositions():
	return positions.size()