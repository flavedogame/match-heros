extends Node2D


export (String) var color

var move_tween
var matched = false

# Called when the node enters the scene tree for the first time.
func _ready():
	move_tween = $move_tween

func move(target):
	move_tween.interpolate_property(self,"position",position,target,.3, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	move_tween.start()

func set_matched():
	$Sprite.modulate = Color(1,1,1,.5)
	matched = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
