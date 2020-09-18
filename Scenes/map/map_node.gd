extends Node2D

onready var local_map:Map = get_parent()


func _on_Button_pressed():
	local_map.start_encounter(null)
