# Base entity that represents a character or a monster in combat
# Every battler has an AI node so all characters can work as a monster
# or as a computer-controlled player ally
extends Position2D

class_name Battler

export var stats: Resource

onready var skin = $Skin
onready var bars = $Bars


var display_name: String

export var party_member = false

var target_global_position: Vector2
export var TARGET_OFFSET_DISTANCE: float = 120.0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var direction: Vector2 = Vector2(1.0, 0.0) if party_member else Vector2(-1.0, 0.0)
	target_global_position = $TargetAnchor.global_position + direction * TARGET_OFFSET_DISTANCE
	initialize()

func initialize():
	skin.initialize()
	stats = stats.copy()
	stats.connect("health_depleted", self, "_on_health_depleted")

func is_able_to_play() -> bool:
	# Returns true if the battler can perform an action
	return stats.health > 0

func take_damage(hit):
	stats.take_damage(hit)
	# prevent playing both stagger and death animation if health <= 0
	if stats.health > 0:
		skin.play_stagger()

func _on_health_depleted():
	yield(skin.play_death(), "completed")
	emit_signal("died", self)

func is_finished():
	print("is finished?")
	print(skin.anim.name)
	if (skin.anim.is_playing()):
		yield( skin.anim, "animation_finished" )
	print("is finished!")
	
	yield(get_tree(), "idle_frame")
	return
	
