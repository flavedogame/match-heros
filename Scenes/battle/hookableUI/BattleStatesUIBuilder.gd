extends Node



static func initialize(battlers: Array) -> void:
	for battler in battlers:
		create_lifebar(battler)


static func create_lifebar(battler:Battler) -> void:
	var HookableLifebar = preload("res://Scenes/battle/hookableUI/HookableLifeBar.tscn")
	var lifebar = HookableLifebar.instance()
	battler.bars.add_child(lifebar)
	lifebar.initialize(battler)
