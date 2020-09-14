extends Node2D

var TURN_START_MOVE_DISTANCE = 100
var TWEEN_DURATION = 1
onready var tween = $Tween

func _ready():
	position = Vector2(30,30)
	move_forward(1)

func move_forward(di):
	var direction = Vector2(di, 0.0)
	tween.interpolate_property(
		self,
		'position',
		position,
		position + TURN_START_MOVE_DISTANCE * direction,
		TWEEN_DURATION,
		Tween.TRANS_QUAD,
		Tween.EASE_OUT
	)
	tween.start()
	yield(tween, "tween_completed")
	di = -di
	yield(move_forward(di),"completed")
