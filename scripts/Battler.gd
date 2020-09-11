# Base entity that represents a character or a monster in combat
# Every battler has an AI node so all characters can work as a monster
# or as a computer-controlled player ally
extends Position2D

class_name Battler

export var stats: Resource

export var party_member = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var direction: Vector2 = Vector2(-1.0, 0.0) if party_member else Vector2(1.0, 0.0)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
