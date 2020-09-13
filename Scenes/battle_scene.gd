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


func get_targets():
	return [enemy]

func party_attack(move_details):
	print("party_attack ",move_details)
	yield($party_ai.attack([hero],[enemy],move_details),"completed")

func enemy_attack():
	yield(get_tree().create_timer(0.2), "timeout")
	yield($enemies_ai.attack([enemy],[hero]),"completed")

func battle_end():
	emit_signal("battle_ends")
	active = false
