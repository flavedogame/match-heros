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


func get_targets():
	return [enemy]

func play_turn():
	if is_hero_turn:
		yield($party_ai.choose_action([hero],[enemy]),"completed")
	else:
		yield($enemies_ai.choose_action([enemy],[hero]),"completed")
	is_hero_turn = !is_hero_turn
	if active:
		play_turn()

func battle_end():
	emit_signal("battle_ends")
	active = false
	
func is_finished():
	print("is finished battle scene")
	yield($party_ai.is_finished(),"completed")
	#yield($enemies_ai.is_finished(),"completed")
	return

func _on_grid_make_a_move(move_details):
	$party_ai._on_grid_make_a_move(move_details)
