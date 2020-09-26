extends Node

var achievement

var battle_won:String = "battle_won"

var SAVE_KEY = "Achievements"

func is_battle_won(battle_id):
	if achievement.has(battle_won) and achievement[battle_won].has(battle_id):
		return achievement[battle_won][battle_id] > 0

func is_achievement_finished(dictionary):
	var result = true
	for key in dictionary:
		var value = dictionary[key]
		if key == battle_won:
			if not is_battle_won(value):
				result = false
				break
	return result

func battle_won(battle_id):
	if not achievement.has(battle_won):
		achievement[battle_won] = {}
	if not achievement[battle_won].has(battle_id):
		achievement[battle_won][battle_id] = 0
	achievement[battle_won][battle_id] += 1
	Events.emit_signal("achievement_update")

func _ready():
	achievement = load("res://resources/achievements/achievements.tres").achievements
	Events.connect("battle_won",self,battle_won)
	
func save(saved_game: Resource):
	saved_game.data[SAVE_KEY] = achievement
	
func load(saved_game: Resource):
	achievement = saved_game.data[SAVE_KEY]
	if achievement == null:
		achievement = {}
	Events.emit_signal("achievement_update")
