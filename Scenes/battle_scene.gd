extends Node2D

class_name BattleScene

var BattleStatesUIBuilder = preload("res://Scenes/battle/hookableUI/BattleStatesUIBuilder.gd")

onready var rewards = $Rewards

var is_hero_turn = true

var active: bool = false

var party
var enemies

onready var party_positions = $"spawnpositions/party"

onready var hero = $"spawnpositions/party/5/HeroBattler"
onready var enemy = $"spawnpositions/enemy/5/EnemyBattler"

#func _ready():
#	pass
	#initialize([enemy],[hero])
	#enemies = 
	#initialize()

func initialize(_enemies, _party):
	
	party = _party
	
	for k in party:
		for i in party_positions.get_children():
			if i.name == party[k]:
				#var k_instance = k.duplicate()
				print(k)
				print(k.get_parent())
				var old_parent = k.get_parent()
				old_parent.remove_child(k)
#				self.remove_child(source)
#				target.add_child(source)
#				source.set_owner(target)
				i.add_child(k)
				k.set_owner(i)
				break
	
	enemies = [enemy]#_enemies
	#rewards.initialize(party,enemies)
	ready_field()

func ready_field():
	enemies[0].stats.reset()
	for k in party:
		k.stats.reset()
	
	BattleStatesUIBuilder.initialize(enemies)
	BattleStatesUIBuilder.initialize(party.keys())
	
func battle_start():
	#play into
	active = true

func party_attack(move_details):
	print("party_attack ",move_details)
	#yield(get_tree().create_timer(0.5), "timeout")
	yield($party_ai.attack(party.keys(),enemies,move_details),"completed")
	return check_battle_end()

func enemy_attack():
	#yield(get_tree().create_timer(0.5), "timeout")
	yield($enemies_ai.attack(enemies,party.keys()),"completed")

func one_side_has_alive(side:Array):
	for i in side.size():
		var battler = side[i]
		if not battler.is_alive:
			side.remove(i)
	return side.size()>0

func check_battle_end():
	var party_has_alive = one_side_has_alive(party.keys())
	var enemies_has_alive = one_side_has_alive(enemies)
	if not party_has_alive or not enemies_has_alive:
		print("battle end")
		if party_has_alive:
			battle_end(true)
		else:
			battle_end(false)
		return true
	return false

func get_attack_party_member(color):
	if color == "orange":
		return party.keys()
	return []

func battle_end(is_won):
	emit_signal("battle_ends")
	active = false
	emit_signal("battle_complete",is_won)
	if is_won:
		yield(rewards.on_battle_completed(), "completed")
