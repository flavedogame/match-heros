extends Node2D

class_name BattleGame

onready var tween = $Tween
var glowing_piece = preload("res://Scenes/match_3_game/fly_to_attacker_glow_part.tscn")
var glocing_piece_flying_time = 0.5
onready var battle_view:BattleScene = $battle_scene
onready var grid = $grid
onready var rewards = $Rewards
signal battle_completed
func _ready():
	grid.battle_scene = battle_view
	
func initialize(formation, party):
	battle_view.initialize(formation,party)
	#todo can put grid info here, like width height obstacles etc
	grid.initialize()

func battle_start():
	battle_view.battle_start()
	grid.battle_start()


func _on_grid_piece_destroyed(start_position,color,texture):
	var targets = $battle_scene.get_attack_party_member(color)
	for target in targets:
		var target_position = target.get_global_transform()[2]
		
		#add_child(tween)
		var glowing_piece_new = glowing_piece.instance()
		add_child(glowing_piece_new)
		glowing_piece_new.sprite.texture = texture
		print(target_position)
		tween.interpolate_property(
			glowing_piece_new, 
			"position", 
			start_position, target.get_global_transform()[2], glocing_piece_flying_time,
			Tween.TRANS_QUART, Tween.EASE_IN)
			
		tween.start()
		yield(tween,"tween_completed")
		glowing_piece_new.queue_free()
	


func _on_Rewards_battle_completed():
	emit_signal("battle_completed")
