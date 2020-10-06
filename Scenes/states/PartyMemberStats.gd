# Represents a Battler's actual stats: health, strength, etc.
# See the child class GrowthStats.gd for stats growth curves
# and lookup tables
extends Resource

class_name PartyMemberStats

export(String) var anim
export(String) var stats
export(String) var id_name
export(String) var career

"""
{
		{anim = "HeroAnim", stats = "hero", career = "hero_career", id_name = "Aaron"},
}
"""
