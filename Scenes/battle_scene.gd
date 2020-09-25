extends Node2D

class_name BattleScene

var BattleStatesUIBuilder = preload("res://Scenes/battle/hookableUI/BattleStatesUIBuilder.gd")


var is_hero_turn = true

var active: bool = false

var party
var formation
onready var battle_game = get_parent()

onready var party_positions = $"spawnpositions/party"
onready var formation_positions = $spawnpositions/formation

onready var hero = $"spawnpositions/party/5/HeroBattler"
onready var enemy = $"spawnpositions/enemy/5/EnemyBattler"

var battler_scene = preload("res://Scenes/battler/Battler.tscn")

#func _ready():
#	pass
	#initialize([enemy],[hero])
	#formation = 
	#initialize()

func initialize(_formation, _party):
	party = {}
	for i in party_positions.get_children():
		if _party.has(i.name):
			var info = _party[i.name]
			#load battler, load correct animation, career, stat
			var battler:Battler = battler_scene.instance()
			battler.init(info, true)
			i.add_child(battler)
			party[battler] = i.name

	formation = {}
	for i in formation_positions.get_children():
		if _formation.has(i.name):
			var info = _formation[i.name]
			#load battler, load correct animation, career, stat
			var battler:Battler = battler_scene.instance()
			battler.init(info, false)
			i.add_child(battler)
			formation[battler] = i.name
	battle_game.rewards.initialize(party.keys(),formation.keys())
	ready_field()

func ready_field():
	#formation[0].stats.reset()
	for k in party:
		k.stats.reset()
	for k in formation:
		k.stats.reset()
	
	BattleStatesUIBuilder.initialize(formation.keys())
	BattleStatesUIBuilder.initialize(party.keys())
	
func battle_start():
	#play into
	active = true

func party_attack(move_details):
	#print("party_attack ",move_details)
	#yield(get_tree().create_timer(0.5), "timeout")
	yield($party_ai.attack(party.keys(),formation.keys(),move_details),"completed")
	return check_battle_end()

func enemy_attack():
	#yield(get_tree().create_timer(0.5), "timeout")
	yield($enemies_ai.attack(formation.keys(),party.keys()),"completed")
	return check_battle_end()

func one_side_has_alive(side:Array):
	var alive_count = 0
	for i in range(side.size()):
		var battler = side[i]
		if battler.is_alive:
			alive_count+=1
	return alive_count>0

func check_battle_end():
	var party_has_alive = one_side_has_alive(party.keys())
	var formation_has_alive = one_side_has_alive(formation.keys())
	if not party_has_alive or not formation_has_alive:
		print("battle end")
		if party_has_alive:
			battle_end(true)
		else:
			battle_end(false)
		return true
	return false

func get_attack_party_member(color):
	#orange
	var related_battlers = []
	for k in party:
		if k.color_related == color:
			related_battlers.append(k)
	return related_battlers

func battle_end(is_won):
	emit_signal("battle_ends")
	active = false
	emit_signal("battle_complete",is_won)
	if is_won:
		Events.emit_signal("battle_won","forest_monsters_1")
		yield(battle_game.rewards.on_battle_completed(), "completed")
