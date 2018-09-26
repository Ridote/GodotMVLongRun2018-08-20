extends Node2D

var main_scene = null
var new_scene = null
var new_position = Vector2(0,0)

func _ready():
	main_scene = $Navigation2D/Map

func changeScene(new_scene, new_position):
	utils.newTimer(1, self, "on_shade_timeout", false)
	$CanvasModulate/CanvasAnimation.play("ShadeIn")
	self.new_scene = new_scene
	self.new_position = new_position
	
func on_shade_timeout():
	main_scene.queue_free()
	
	# Remove the current level
	$Navigation2D.remove_child(main_scene)
	main_scene.call_deferred("free")

	# Add the next level
	var next_scene = load(new_scene)
	var next_level = next_scene.instance()
	$Navigation2D.add_child(next_level)
	$Navigation2D/Player.setGlobalPosition(position)
	$CanvasModulate/CanvasAnimation.play("ShadeOut")