extends Node2D

class_name BattleScene

var BattleStatesUIBuilder = preload("res://Scenes/battle/hookableUI/BattleStatesUIBuilder.gd")

onready var turn_queue = $turn_queue

var is_hero_turn = true

var active: bool = false

onready var hero = $"spawnpositions/party/5/HeroBattler"
onready var enemy = $"spawnpositions/enemy/5/EnemyBattler"

func _ready():
	initialize([enemy],[hero])
	#enemies = 
	#initialize()

func initialize(enemies, party):
	ready_field(enemies, party)

func ready_field(enemies, party):
	enemies[0].stats.reset()
	party[0].stats.reset()
	BattleStatesUIBuilder.initialize(enemies)
	BattleStatesUIBuilder.initialize(party)
	battle_start()
	
func battle_start():
	#play into
	active = true
	play_turn()
	
func attack(actor, targets, attack_value):
	if actor.party_member and not targets:
		return false
	if attack_value == 0:
		return false
	for target in targets:
		var hit = Hit.new(actor.stats.strength * attack_value)
		yield(actor.skin.move_to(target), "completed")
		target.take_damage(hit)
		yield(actor.get_tree().create_timer(1.0), "timeout")
		yield(actor.skin.return_to_start(), "completed")
	return true

func get_targets():
	return [enemy]

func play_turn():
	if is_hero_turn:
		yield($"../grid","finish_a_move")
	else:
		$enemies_ai.choose_action([enemy],[hero])
	is_hero_turn = !is_hero_turn
	if active:
		play_turn()

func battle_end():
	emit_signal("battle_ends")
	active = false

func _on_grid_make_a_move(move_details):
	var attack_value = move_details.get("orange",0)
	attack(hero, get_targets(),attack_value)
