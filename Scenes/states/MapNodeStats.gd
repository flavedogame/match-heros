# Represents a Battler's actual stats: health, strength, etc.
# See the child class GrowthStats.gd for stats growth curves
# and lookup tables
extends Resource

class_name MapNodeStats

export var name: String
export var map_node_id:String
export(Array, Dictionary) var visible_condition
export var position:Vector2
export var buttons:Array
