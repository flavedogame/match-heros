extends Node2D

class_name CombatArena

var BattleStatesUIBuilder = preload("res://Scenes/battle/hookableUI/BattleStatesUIBuilder.gd")

onready var turn_queue = $turn_queue

onready var hero = $"spawnpositions/party/5/HeroBattler"
onready var enemy = $"spawnpositions/enemy/5/EnemyBattler"

func _ready():
	initialize([enemy],[hero])
	#enemies = 
	#initialize()

func initialize(enemies, party):
	ready_field(enemies, party)

func ready_field(enemies, party):
	print("ready field")
	enemies[0].stats.reset()
	party[0].stats.reset()
	BattleStatesUIBuilder.initialize(enemies)
	BattleStatesUIBuilder.initialize(party)
	
	
func attack(actor, targets):
	if actor.party_member and not targets:
		return false

	for target in targets:
		yield(actor.skin.move_to(target), "completed")
		var hit = Hit.new(actor.stats.strength)
		target.take_damage(hit)
		yield(actor.get_tree().create_timer(1.0), "timeout")
		yield(actor.skin.return_to_start(), "completed")
	return true

func get_targets():
	return [enemy]

func play_turn():
	pass


func _on_grid_make_a_move(move_details):
	print("make a move")
	attack(hero, get_targets())
