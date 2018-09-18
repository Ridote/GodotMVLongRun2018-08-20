extends Node2D

enum STATE{
	CLOSED,
	OPENING,
	CLOSING,
	OPENED
}

var state = STATE.CLOSED

func _ready():
	$AnimationPlayer.play("Closed")

func open():
	if state == STATE.OPENED:
		$AnimationPlayer.play_backwards("Open")
		$Opening.start()
		state = STATE.CLOSING
	elif state == STATE.CLOSED:
		$AnimationPlayer.play("Open")
		$Opening.start()
		state = STATE.OPENING
	


func _on_Opening_timeout():
	if state == STATE.OPENING:
		state = STATE.OPENED
	elif state == STATE.CLOSING:
		state = STATE.CLOSED
