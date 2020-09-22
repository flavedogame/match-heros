extends Node2D

onready var local_map:Map = get_parent()
export var stats: Resource

func _on_Button_pressed():
	for action in stats.actions:
		for action_key in action:
			if action_key == "battle_action":
				var action_content = action[action_key] 
				print(action_content)
				local_map.start_encounter(action_content)
