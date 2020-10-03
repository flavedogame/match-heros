extends Control

const battle_game_scene = preload("res://Scenes/battle_game.tscn")
const Transition_Overlay = preload("res://Scenes/battle/Transition_overlay.tscn")
onready var transition
onready var local_map = $local_map
#onready var party = $party
var party = {
	"1":
		{anim = "HeroAnim", stats = "hero", career = "hero_career", id_name = "aaron"},
	"5":
		{anim = "HeressAnim", stats = "heress", career = "heress_career", id_name = "alex"},
	}
var _formation = {
	"5":
		{anim = "EnemyAnim", stats = "enemy"},
	"9":
		{anim = "EnemyAnim", stats = "enemy"},
	}
var transitioning = false
var battle_game :BattleGame
func enter_battle(battle_id,formation):
	# Plays the combat transition animation and initializes the combat scene
	if transitioning:
		return
	transitioning = true
	transition = Transition_Overlay.instance()
	add_child(transition)
	yield(transition.fade_to_color(), "completed")
	remove_child(local_map)
	battle_game = battle_game_scene.instance()
	add_child(battle_game)
	battle_game.connect("victory", self, "_on_CombatArena_player_victory")
	battle_game.connect("game_over", self, "_on_CombatArena_game_over")
	battle_game.connect(
		"battle_completed", self, "_on_CombatArena_battle_completed", [battle_game]
	)
	battle_game.initialize(battle_id, formation, party)

	yield(transition.fade_from_color(), "completed")
	transition.queue_free()
	transitioning = false

	battle_game.battle_start()
	emit_signal("combat_started")
	
func _ready():
	Events.connect("encounter_battle",self,"enter_battle")


func _on_CombatArena_battle_completed(arena):
	
	# At the end of an encounter, fade the screen, remove the combat arena
	# and add the local map back
#	gui.show()
#
	transitioning = true
	transition = Transition_Overlay.instance()
	add_child(transition)
	yield(transition.fade_to_color(), "completed")
	battle_game.queue_free()

	add_child(local_map)
	yield(transition.fade_from_color(), "completed")
	transition.queue_free()
	transitioning = false
	#music_player.stop()


func _on_CombatArena_player_victory():
	pass
	#music_player.play_victory_fanfare()


func _on_CombatArena_game_over() -> void:
	pass
#	transitioning = true
#	yield(transition.fade_to_color(), "completed")
#	game_over_interface.display(GameOverInterface.Reason.PARTY_DEFEATED)
#	yield(transition.fade_from_color(), "completed")
#	transitioning = false


func _on_GameOverInterface_restart_requested():
	pass
#	game_over_interface.hide()
#	var formation = combat_arena.initial_formation
#	combat_arena.queue_free()
#	enter_battle(formation)
