extends Position2D

class_name BattlerAnim

onready var anim = $animationNode/AnimationPlayer
#onready var extents: RectExtents = $RectExtents

func _ready():
	var direction = 1 if owner.party_member else -1
	$animationNode/Sprite.scale.x = direction

func play_stagger():
	anim.play("take_damage")
	yield(anim, "animation_finished")


func play_death():
	anim.play("death")
	yield(anim, "animation_finished")
