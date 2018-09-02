extends CanvasLayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$Container/VBoxContainer/Mana.value = 100
	$Container/VBoxContainer/HP.value = 100
	state.connect("player_hp", self, "update_player_hp")
	state.connect("player_mana", self, "update_player_mana")
	
func update_player_hp():
	$Container/VBoxContainer/HP.value = state.player_hp

func update_player_mana():
	$Container/VBoxContainer/Mana.value = state.player_mana
