extends CanvasLayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$Container/HBoxContainer/VBoxContainer/Mana.value = 100
	$Container/HBoxContainer/VBoxContainer/HP.value = 100
	$Container/HBoxContainer/CenterContainer/KeyText.text = "0"
	state.connect("player_hp", self, "update_player_hp")
	state.connect("player_mana", self, "update_player_mana")
	state.connect("player_keys", self, "update_player_keys")
	
func update_player_hp():
	$Container/HBoxContainer/VBoxContainer/HP.value = state.player_hp

func update_player_mana():
	$Container/HBoxContainer/VBoxContainer/Mana.value = state.player_mana

func update_player_keys():
	$Container/HBoxContainer/CenterContainer/KeyText.text = str(state.player_keys)