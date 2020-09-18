extends Node2D

const combat_arena_scene = preload("res://Scenes/combat_arena_scene.tscn")
const Transition_Overlay = preload("res://Scenes/battle/Transition_overlay.tscn")
onready var transition
onready var local_map = $local_map
onready var party = $party

var transitioning = false
var combat_arena :CombatArena

func enter_battle(formation):
	# Plays the combat transition animation and initializes the combat scene
	if transitioning:
		return
	transitioning = true
	transition = Transition_Overlay.instance()
	add_child(transition)
	yield(transition.fade_to_color(), "completed")
	print("fade to color")
	remove_child(local_map)
	combat_arena = combat_arena_scene.instance()
	add_child(combat_arena)
	combat_arena.connect("victory", self, "_on_CombatArena_player_victory")
	combat_arena.connect("game_over", self, "_on_CombatArena_game_over")
	combat_arena.connect(
		"battle_completed", self, "_on_CombatArena_battle_completed", [combat_arena]
	)
	combat_arena.initialize(formation, party.get_active_members())

	yield(transition.fade_from_color(), "completed")
	transition.queue_free()
	transitioning = false

	combat_arena.battle_start()
	emit_signal("combat_started")


func _on_map_enemies_encountered(formation):
	enter_battle(formation)


func _on_CombatArena_battle_completed(arena):
	pass
	# At the end of an encounter, fade the screen, remove the combat arena
	# and add the local map back
#	gui.show()
#
#	transitioning = true
#	yield(transition.fade_to_color(), "completed")
#	combat_arena.queue_free()
#
#	add_child(local_map)
#	yield(transition.fade_from_color(), "completed")
#	transitioning = false
#	music_player.stop()


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
