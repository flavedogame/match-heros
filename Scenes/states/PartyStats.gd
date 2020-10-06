# Represents a Battler's actual stats: health, strength, etc.
# See the child class GrowthStats.gd for stats growth curves
# and lookup tables
extends Resource

class_name PartyStats

export(Dictionary) var battle_positon_to_party_members
export(Dictionary) var party_members
"""
{
	5:"hero",
}

{
	"hero":5,
	"heress":-1
}

"""
