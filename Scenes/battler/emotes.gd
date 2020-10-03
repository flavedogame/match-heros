extends Node2D

onready var animation_player = $AnimationPlayer
onready var sprite = $Sprite
func start_talking():
	sprite.visible = true
	animation_player.play("talking")

func stop_talking():
	print("stop")
	sprite.visible = false
	animation_player.stop()
