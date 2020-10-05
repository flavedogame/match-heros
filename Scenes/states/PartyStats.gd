# Represents a Battler's actual stats: health, strength, etc.
# See the child class GrowthStats.gd for stats growth curves
# and lookup tables
extends Resource

class_name PartyStats

export(Dictionary) var battle_party_members
"""
{
	"5":
		{anim = "HeroAnim", stats = "hero", career = "hero_career", id_name = "Aaron"},
}
"""
