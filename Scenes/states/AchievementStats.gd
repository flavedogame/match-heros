# Represents a Battler's actual stats: health, strength, etc.
# See the child class GrowthStats.gd for stats growth curves
# and lookup tables
extends Resource

class_name AchievementStats

export(Dictionary) var achievements
"""
{
	"battle_won" : {
		"forest_battle_1":1,
	},
}
"""
