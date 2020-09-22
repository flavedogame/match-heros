# Represents a Battler's actual stats: health, strength, etc.
# See the child class GrowthStats.gd for stats growth curves
# and lookup tables
extends Resource

class_name MapNodeStats

signal health_changed(new_health, old_health)
signal health_depleted


export var name: String
export var map_node_id:String
export var visible_condition:String
export var buttons:Array
