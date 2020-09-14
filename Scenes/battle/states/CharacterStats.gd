# Represents a Battler's actual stats: health, strength, etc.
# See the child class GrowthStats.gd for stats growth curves
# and lookup tables
extends Resource

class_name CharacterStats

signal health_changed(new_health, old_health)
signal health_depleted

var health: int
export var max_health: int = 1 setget set_max_health, _get_max_health
export var strength: int = 1 setget , _get_strength
export var defense: int = 1 setget , _get_defense
var is_alive: bool setget , _is_alive

func reset():
	health = self.max_health
	
func copy() -> CharacterStats:
	# Perform a more accurate duplication, as normally Resource duplication
	# does not retain any changes, instead duplicating from what's registered
	# in the ResourceLoader
	var copy = duplicate()
	copy.health = health
	return copy
	
func take_damage(hit: Hit):
	var old_health = health
	health -= hit.damage
	health = max(0, health)
	emit_signal("health_changed", health, old_health)
	if health == 0:
		emit_signal("health_depleted")

func set_max_health(value: int):
	if value == null:
		return
	max_health = max(1, value)

func _get_max_health() -> int:
	return max_health
	
func _get_strength() -> int:
	return strength

func _get_defense() -> int:
	return defense

func _is_alive() -> bool:
	return health > 0
