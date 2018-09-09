extends Node

signal player_hp
signal player_mana

export var player_hp = 100 setget player_hp_emitter
export var player_mana = 100 setget player_mana_emitter

func player_hp_emitter(val):
	player_hp = val
	emit_signal("player_hp")

func player_mana_emitter(val):
	player_mana = val
	emit_signal("player_mana")