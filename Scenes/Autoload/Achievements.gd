extends Node

var achievement

var battle_won:String = "battle_won"
var battle_finish:String = "battle_finish"
var finish_dialog:String = "finish_dialog"

var SAVE_KEY = "Achievements"

func is_battle_won(battle_id):
	if achievement.has(battle_won) and achievement[battle_won].has(battle_id):
		return achievement[battle_won][battle_id] > 0

func is_achievement_finished(dictionary):
	var result = true
	for key in dictionary:
		var value = dictionary[key]
		if not (achievement.has(key) and achievement[key].has(value) and achievement[key][value] > 0):
			return false
	return result

func finish_achievement_with_id(achivement_name, id):
	if not achievement.has(achivement_name):
		achievement[achivement_name] = {}
	if not achievement[achivement_name].has(id):
		achievement[achivement_name][id] = 0
	achievement[achivement_name][id] += 1
	Events.emit_signal("achievement_update")

func battle_won(battle_id):
	finish_achievement_with_id(battle_won,battle_id)
	
func finish_dialog(dialog_id):
	finish_achievement_with_id(finish_dialog,dialog_id)

func _ready():
	achievement = load("res://resources/achievements/achievements.tres").achievements
	Events.connect("battle_won",self,battle_won)
	Events.connect("finish_dialog",self,finish_dialog)
	
func save(saved_game: Resource):
	saved_game.data[SAVE_KEY] = achievement
	
func load(saved_game: Resource):
	achievement = saved_game.data[SAVE_KEY]
	if achievement == null:
		achievement = {}
	Events.emit_signal("achievement_update")
