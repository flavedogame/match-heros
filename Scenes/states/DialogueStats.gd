# Represents a Battler's actual stats: health, strength, etc.
# See the child class GrowthStats.gd for stats growth curves
# and lookup tables
extends Resource

class_name DialogueStats


export var name: String
export var battle_id:String
export(Array, Dictionary) var visible_condition
"""
[
	{condition_type:condition_value,condition_type:condition_value},    and relation
	or relation
	{condition_type:condition_value,condition_type:condition_value},
]
"""
export(Array, Dictionary) var dialogues
"""
[
	{
		"speaker":"Aaron",
		"text":"what are we going to learn today?"
	}
]
"""
#export(Array, Dictionary, int, String) var b
#export(Array, Dictionary, int, Array) var c
#export(Array, Dictionary, int, Array, Dictionary, int, int) var d
#export(Dictionary, int, Dictionary, int, int) var e
