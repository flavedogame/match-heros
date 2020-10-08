extends Control


class_name BattleGame

onready var tween = $Tween
var glowing_piece = preload("res://Scenes/match_3_game/fly_to_attacker_glow_part.tscn")
var glocing_piece_flying_time = 0.5
onready var battle_view:BattleScene = $battle_scene
onready var grid = $grid
onready var rewards = $Rewards
onready var control_view = $control_view
#todo: move grid under this
onready var control_start_position = $control_start_position
var dialog_view = preload("res://DialogueSystem/Scene/DialogueView.tscn")
var actions
var action_finished = []
var battle_id

signal battle_completed
func _ready():
	grid.battle_scene = battle_view
	grid.margin_top = GlobalValues.stage_height
	control_view.margin_top = GlobalValues.stage_height
	grid.initialize()
	

	
func initialize(_battle_id, battle_info, party):
	#$background.rect_size = size
	battle_id = _battle_id
	actions = battle_info.get("actions",[])
	for action in actions:
		action_finished.append(false)
	battle_view.initialize(battle_id, battle_info.formation,party)
	#todo can put grid info here, like width height obstacles etc

func battle_start():
	yield(check_actions("battle_start"),"completed")
	battle_view.battle_start()
	grid.battle_start()
	
func check_actions(condition):
	for i in actions.size():
		if not action_finished[i]:
			var action = actions[i]
			var action_key  = action.action_key
			var action_condition = action.condition
			if action_key == "show_dialog":
				if action_condition == condition:
					var dialog_view_instance = dialog_view.instance()
					dialog_view_instance.init(action.get("dialog_id",action.dialog_file), action.dialog_file)
					control_view.add_child(dialog_view_instance)
					yield(Events,"finish_dialog")
	yield(get_tree(), 'idle_frame')

func _on_grid_piece_destroyed(start_position,color,texture):
	var targets = $battle_scene.get_attack_party_member(color)
	for target in targets:
		var target_position = target.get_global_transform()[2]
		
		#add_child(tween)
		var glowing_piece_new = glowing_piece.instance()
		add_child(glowing_piece_new)
		glowing_piece_new.sprite.texture = texture
		tween.interpolate_property(
			glowing_piece_new, 
			"position", 
			start_position, target.get_global_transform()[2], glocing_piece_flying_time,
			Tween.TRANS_QUART, Tween.EASE_IN)
			
		tween.start()
		yield(tween,"tween_completed")
		glowing_piece_new.queue_free()
	

func battle_end(is_won):
	if is_won:
		yield(check_actions("battle_won"),"completed")
		Events.emit_signal("battle_won",battle_id)
		yield(rewards.on_battle_completed(), "completed")
	
	emit_signal("battle_complete",is_won)

func _on_Rewards_battle_completed():
	emit_signal("battle_completed")
