# Base entity that represents a character or a monster in combat
# Every battler has an AI node so all characters can work as a monster
# or as a computer-controlled player ally
extends Position2D

class_name Battler

export var stats: Resource

onready var skin = $Skin
onready var bars = $Bars

var is_alive = true

export var attack_move_time = 0.5


var display_name: String

export var party_member = false

var target_global_position: Vector2
export var TARGET_OFFSET_DISTANCE: float = 120.0

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
	is_alive = false
	yield(skin.play_death(), "completed")
	emit_signal("died", self)

func attack(target, move_details):
	var attack_value = 1
	if move_details:
		attack_value = move_details.get("orange",0)
		if attack_value == 0:
			yield(get_tree(), "idle_frame")
			return
	var hit = Hit.new(stats.strength * attack_value)
	yield(skin.move_to(target), "completed")
	target.take_damage(hit)
	yield(get_tree().create_timer(attack_move_time), "timeout")
	yield(skin.return_to_start(), "completed")
	
