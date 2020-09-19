# Represents a Battler's actual stats: health, strength, etc.
# See the child class GrowthStats.gd for stats growth curves
# and lookup tables
extends Resource

class_name CareerStats

signal health_changed(new_health, old_health)
signal health_depleted

export var color_related: String

	
func copy() -> CareerStats:
	# Perform a more accurate duplication, as normally Resource duplication
	# does not retain any changes, instead duplicating from what's registered
	# in the ResourceLoader
	var copy = duplicate()
	copy.color_related = color_related
	return copy



